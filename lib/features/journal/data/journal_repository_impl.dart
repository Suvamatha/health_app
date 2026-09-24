import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/journal_entry.dart';
import '../domain/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  static const _key = 'journal_entries';

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<List<JournalEntry>> _readAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => JournalEntry.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _writeAllEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<JournalEntry?> getEntryForDate(DateTime date) async {
    final all = await _readAllEntries();
    for (final entry in all) {
      if (_isSameDay(entry.date, date)) return entry;
    }
    return null;
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    final all = await _readAllEntries();
    all.removeWhere((e) => _isSameDay(e.date, entry.date));
    all.add(entry);
    await _writeAllEntries(all);
  }

  @override
  Future<void> deleteEntryForDate(DateTime date) async {
    final all = await _readAllEntries();
    all.removeWhere((e) => _isSameDay(e.date, date));
    await _writeAllEntries(all);
  }

  @override
  Future<List<JournalEntry>> getAllEntries() async {
    return _readAllEntries();
  }
}
