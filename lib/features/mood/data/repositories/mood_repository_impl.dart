import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository{
  final List<MoodEntry> _entries = [];

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future <MoodEntry?> getTodayEntry () async {
    return getEntryForDate(DateTime.now());
  }

  @override
  Future <MoodEntry?> getEntryForDate  (DateTime date) async {
    for(final entry in _entries) {
      if(_isSameDay(entry.loggedAt, date)) return entry;
    }
    return null;
  }

  @override
  Future <void> saveTodayEntry(MoodEntry entry) async {
    _entries.removeWhere((e) => _isSameDay(e.loggedAt, entry.loggedAt));
    _entries.add(entry);
  }
}