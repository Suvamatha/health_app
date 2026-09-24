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

  RemindersCubit(this._repository, this._notificationService)
    : super(const RemindersState());

  Future<void> loadReminders() async {
    final reminders = await _repository.getAllReminders();
    // Reminders created by an older app build may have been saved even when
    // Android rejected their alarm. Re-apply every enabled reminder at app
    // start so those existing rows begin working without requiring the user
    // to delete and recreate them.
    for (final reminder in reminders.where((reminder) => reminder.isEnabled)) {
      try {
        await _notificationService.scheduleReminder(
          id: reminder.notificationId,
          title: reminder.label,
          body: _bodyFor(reminder.type),
          hour: reminder.hour,
          minute: reminder.minute,
        );
      } catch (_) {
        // The add/edit flow reports scheduling errors to the user. Loading
        // must still show saved reminders when Android is temporarily blocked.
      }
    }
    emit(state.copyWith(isLoading: false, reminders: reminders));
  }

  int _newNotificationId() {
    // Reserve id 1 for the built-in hydration reminder; custom reminders
    // start well above the hydration range and use time-based offsets to
    // stay collision-free.
    return 10000 + (DateTime.now().millisecondsSinceEpoch % 2000000000);
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
    await _schedule(reminder);
    await _repository.saveReminder(reminder);
    await loadReminders();
  }

  /// Replaces the scheduled alarm as well as the saved values.  Cancelling
  /// first prevents an old time from surviving an edit on Android devices.
  Future<void> updateReminder(Reminder reminder) async {
    await _notificationService.cancelReminder(reminder.notificationId);
    if (reminder.isEnabled) {
      await _schedule(reminder);
    }
    await _repository.saveReminder(reminder);
    await loadReminders();
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    final reminder = state.reminders.firstWhere((r) => r.id == id);
    final updated = reminder.copyWith(isEnabled: isEnabled);
    if (isEnabled) {
      await _schedule(updated);
    } else {
      await _notificationService.cancelReminder(updated.notificationId);
    }
    await _repository.saveReminder(updated);
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

  Future<void> _schedule(Reminder reminder) async {
    final permitted = await _notificationService.requestPermission();
    if (!permitted || !await _notificationService.areNotificationsEnabled()) {
      throw StateError('Notifications are blocked in your phone settings.');
    }
    await _notificationService.scheduleReminder(
      id: reminder.notificationId,
      title: reminder.label,
      body: _bodyFor(reminder.type),
      hour: reminder.hour,
      minute: reminder.minute,
    );
  }
}
