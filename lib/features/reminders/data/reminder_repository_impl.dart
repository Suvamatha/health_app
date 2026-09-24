import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/reminder.dart';
import '../domain/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  static const _key = 'custom_reminders';

  @override
  Future<List<Reminder>> getAllReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => Reminder.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _writeAll(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = reminders.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    final all = await getAllReminders();
    all.removeWhere((r) => r.id == reminder.id);
    all.add(reminder);
    await _writeAll(all);
  }

  @override
  Future<void> deleteReminder(String id) async {
    final all = await getAllReminders();
    all.removeWhere((r) => r.id == id);
    await _writeAll(all);
  }
}
