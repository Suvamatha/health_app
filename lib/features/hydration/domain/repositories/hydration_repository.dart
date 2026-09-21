import '../entities/hydration_entry.dart';

abstract class HydrationRepository {
  Future<List<HydrationEntry>> getTodayEntries();
  Future<void> addEntry(HydrationEntry entry);
  Future<List<HydrationEntry>> getEntriesForDate(DateTime date);
}