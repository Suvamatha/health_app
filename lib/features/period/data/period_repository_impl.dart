
import 'package:healthtracker/features/period/domain/entities/period_entry.dart';
import 'package:healthtracker/features/period/domain/repositories/period_repository.dart';


class PeriodRepositoryImpl implements PeriodRepository {
  final List<PeriodEntry> _entries = [];

  @override
  Future<List<PeriodEntry>> getAllEntries() async {
    return List.of(_entries); // fresh copy — never hand out the internal list itself
  }

  @override
  Future<void> addEntry(PeriodEntry entry) async {
    _entries.add(entry);
  }

  @override
  Future<void> removeEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
  }

  @override
  Future<List<PeriodEntry>> getEntriesForMonth(DateTime month) async {
    return _entries.where((entry) {
      return entry.date.year == month.year && entry.date.month == month.month;
    }).toList();
  }
}