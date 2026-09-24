// lib/features/mood/data/repositories/mood_repository_impl.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository {
  static const _key = 'mood_entries';

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<List<MoodEntry>> _readAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => MoodEntry.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _writeAllEntries(List<MoodEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<MoodEntry?> getTodayEntry() async {
    return getEntryForDate(DateTime.now());
  }

  @override
  Future<MoodEntry?> getEntryForDate(DateTime date) async {
    final all = await _readAllEntries();
    for (final entry in all) {
      if (_isSameDay(entry.loggedAt, date)) return entry;
    }
    return null;
  }

  @override
  Future<void> saveTodayEntry(MoodEntry entry) async {
    final all = await _readAllEntries();
    all.removeWhere((e) => _isSameDay(e.loggedAt, entry.loggedAt));
    all.add(entry);
    await _writeAllEntries(all);
  }

  @override
  Future<List<MoodEntry>> getAllEntries() async {
    return _readAllEntries();
  }
}