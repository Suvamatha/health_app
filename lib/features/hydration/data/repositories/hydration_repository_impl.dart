import '../../domain/entities/hydration_entry.dart';
import '../../domain/repositories/hydration_repository.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  final List<HydrationEntry> _entries = [];

  @override
  Future<List<HydrationEntry>> getTodayEntries() async {
    final now = DateTime.now();
    return _entries.where((entry) {
      return entry.loggedAt.year == now.year &&
          entry.loggedAt.month == now.month &&
          entry.loggedAt.day == now.day;
    }).toList();
  }

  @override
  Future<void> addEntry(HydrationEntry entry) async {
    _entries.add(entry);
  }

  @override
  Future<List<HydrationEntry>> getEntriesForDate(DateTime date) async {
    return _entries.where((entry) {
      return entry.loggedAt.year == date.year &&
          entry.loggedAt.month == date.month &&
          entry.loggedAt.day == date.day;
    }).toList();
  }
}