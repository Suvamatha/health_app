import '../../domain/reminder.dart';

class RemindersState {
  final bool isLoading;
  final List<Reminder> reminders;

  const RemindersState({
    this.isLoading = true,
    this.reminders = const [],
  });

  RemindersState copyWith({
    bool? isLoading,
    List<Reminder>? reminders,
  }) {
    return RemindersState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
    );
  }
}
