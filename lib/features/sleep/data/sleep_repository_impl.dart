import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/sleep_entry.dart';
import '../domain/sleep_repository.dart';

class SleepRepositoryImpl implements SleepRepository {
  static const _key = 'sleep_entries';

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<List<SleepEntry>> _readAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => SleepEntry.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _writeAllEntries(List<SleepEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<SleepEntry?> getEntryForDate(DateTime date) async {
    final all = await _readAllEntries();
    for (final entry in all) {
      if (_isSameDay(entry.loggedAt, date)) return entry;
    }
    return null;
  }

  @override
  Future<void> saveEntry(SleepEntry entry) async {
    final all = await _readAllEntries();
    all.removeWhere((e) => _isSameDay(e.loggedAt, entry.loggedAt));
    all.add(entry);
    await _writeAllEntries(all);
  }

  @override
  Future<List<SleepEntry>> getAllEntries() async {
    return _readAllEntries();
  }
}
