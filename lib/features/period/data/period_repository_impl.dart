// lib/features/period/data/repositories/period_repository_impl.dart

import 'dart:convert';
import 'package:healthtracker/features/period/domain/entities/period_entry.dart';
import 'package:healthtracker/features/period/domain/repositories/period_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeriodRepositoryImpl implements PeriodRepository {
  static const _key = 'period_entries';

  Future<List<PeriodEntry>> _readAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => PeriodEntry.fromJson(jsonDecode(s))).toList();
  }

  Future<void> _writeAllEntries(List<PeriodEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<List<PeriodEntry>> getAllEntries() async {
    return _readAllEntries(); // already returns a fresh list each call — same bug-class fixed as before, naturally, since jsonDecode always builds new objects
  }

  @override
  Future<void> addEntry(PeriodEntry entry) async {
    final all = await _readAllEntries();
    all.add(entry);
    await _writeAllEntries(all);
  }

  @override
  Future<void> removeEntry(String id) async {
    final all = await _readAllEntries();
    all.removeWhere((entry) => entry.id == id);
    await _writeAllEntries(all);
  }

  @override
  Future<List<PeriodEntry>> getEntriesForMonth(DateTime month) async {
    final all = await _readAllEntries();
    return all.where((entry) => entry.date.year == month.year && entry.date.month == month.month).toList();
  }
}