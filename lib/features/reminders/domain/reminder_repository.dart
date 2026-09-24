import 'reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getAllReminders();
  Future<void> saveReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
}
