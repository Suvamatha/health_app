import 'sleep_entry.dart';

abstract class SleepRepository {
  Future<SleepEntry?> getEntryForDate(DateTime date);
  Future<void> saveEntry(SleepEntry entry);
  Future<List<SleepEntry>> getAllEntries();
}
