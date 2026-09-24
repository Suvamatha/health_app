import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../domain/reminder.dart';
import '../../domain/reminder_repository.dart';
import 'reminders_state.dart';

/// Manages user-defined reminders (meds/vitamins, period prep, mood
/// check-ins, or fully custom) on top of the built-in hydration reminder.
/// Each reminder gets its own stable local-notification id so it can be
/// scheduled and cancelled independently.
class RemindersCubit extends Cubit<RemindersState> {
  final ReminderRepository _repository;
  final NotificationService _notificationService;

  RemindersCubit(this._repository, this._notificationService) : super(const RemindersState());

  Future<void> loadReminders() async {
    final reminders = await _repository.getAllReminders();
    emit(state.copyWith(isLoading: false, reminders: reminders));
  }

  int _newNotificationId() {
    // Reserve id 1 for the built-in hydration reminder; custom reminders
    // start at 2000 and use time-based offsets to stay collision-free.
    return 2000 + (DateTime.now().microsecondsSinceEpoch % 100000);
  }

  Future<void> addReminder({
    required String label,
    required ReminderType type,
    required int hour,
    required int minute,
  }) async {
    final reminder = Reminder(
      id: const Uuid().v4(),
      notificationId: _newNotificationId(),
      label: label,
      type: type,
      hour: hour,
      minute: minute,
      isEnabled: true,
    );
    await _repository.saveReminder(reminder);
    await _notificationService.requestPermission();
    await _notificationService.scheduleReminder(
      id: reminder.notificationId,
      title: reminder.label,
      body: _bodyFor(reminder.type),
      hour: reminder.hour,
      minute: reminder.minute,
    );
    await loadReminders();
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    final reminder = state.reminders.firstWhere((r) => r.id == id);
    final updated = reminder.copyWith(isEnabled: isEnabled);
    await _repository.saveReminder(updated);

    if (isEnabled) {
      await _notificationService.scheduleReminder(
        id: updated.notificationId,
        title: updated.label,
        body: _bodyFor(updated.type),
        hour: updated.hour,
        minute: updated.minute,
      );
    } else {
      await _notificationService.cancelReminder(updated.notificationId);
    }
    await loadReminders();
  }

  Future<void> deleteReminder(String id) async {
    final reminder = state.reminders.firstWhere((r) => r.id == id);
    await _notificationService.cancelReminder(reminder.notificationId);
    await _repository.deleteReminder(id);
    await loadReminders();
  }

  String _bodyFor(ReminderType type) {
    switch (type) {
      case ReminderType.medication:
        return "A gentle nudge for your meds or vitamins.";
      case ReminderType.periodPrep:
        return 'A gentle nudge to get period-prep supplies ready.';
      case ReminderType.moodCheckIn:
        return 'A gentle nudge to check in with how you\'re feeling.';
      case ReminderType.custom:
        return 'A gentle reminder from Wellspring.';
    }
  }
}
