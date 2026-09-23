import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/hydration_entry.dart';
import '../../domain/repositories/hydration_repository.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  static const _key = 'hydration_entries';

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<List<HydrationEntry>> _readAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => HydrationEntry.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _writeAllEntries(List<HydrationEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<List<HydrationEntry>> getEntriesForDate(DateTime date) async {
    final all = await _readAllEntries();
    return all.where((entry) => _isSameDay(entry.loggedAt, date)).toList();
  }

  @override
  Future<List<HydrationEntry>> getTodayEntries() async {
    return getEntriesForDate(DateTime.now());
  }

  @override
  Future<void> addEntry(HydrationEntry entry) async {
    final all = await _readAllEntries();
    all.add(entry);
    await _writeAllEntries(all);
  }
}