import '../entities/mood_entry.dart';

abstract class MoodRepository {
  Future <MoodEntry?> getTodayEntry();
  Future<void> saveTodayEntry(MoodEntry entry);
  Future<MoodEntry?>getEntryForDate(DateTime date);
}