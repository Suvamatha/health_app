import '../entities/period_entry.dart';

abstract class PeriodRepository {
  Future <List<PeriodEntry>> getAllEntries();
  Future <void> addEntry (PeriodEntry entry);
  Future <void> removeEntry (String id);
  Future <List<PeriodEntry>> getEntriesForMonth(DateTime month);
}