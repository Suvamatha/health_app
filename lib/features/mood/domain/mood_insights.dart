import '../../period/domain/entities/period_entry.dart';
import 'entities/mood_entry.dart';

/// Correlates logged mood with cycle timing so the app can gently surface
/// patterns the user might not notice on their own, e.g. "your mood tends
/// to dip in the days before your period."
class MoodInsights {
  MoodInsights._();

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Minimum number of pre-period windows with mood data before an
  /// insight is considered reliable enough to show.
  static const int _minWindowsWithData = 2;

  /// A mood dip is only worth mentioning once it's a meaningfully sized
  /// difference on a 1-4 mood scale, not noise.
  static const double _minNoticeableDelta = 0.4;

  static double? _averageMoodOn(List<MoodEntry> moodEntries, Set<DateTime> targetDays) {
    final matches = moodEntries.where(
      (entry) => targetDays.any((day) => _isSameDay(day, entry.loggedAt)),
    );
    if (matches.isEmpty) return null;
    final total = matches.fold<int>(0, (sum, e) => sum + e.moodLevel);
    return total / matches.length;
  }

  /// Returns a short, human-readable insight, or null if there isn't yet
  /// enough logged history to say anything meaningful.
  static String? preMenstrualMoodInsight({
    required List<MoodEntry> moodEntries,
    required List<DateTime> cycleStarts,
  }) {
    if (moodEntries.length < 4 || cycleStarts.isEmpty) return null;

    final preWindowDays = <DateTime>{};
    for (final start in cycleStarts) {
      for (var offset = 1; offset <= 3; offset++) {
        preWindowDays.add(DateTime(start.year, start.month, start.day).subtract(Duration(days: offset)));
      }
    }

    final windowsWithData = preWindowDays
        .where((day) => moodEntries.any((entry) => _isSameDay(entry.loggedAt, day)))
        .length;
    if (windowsWithData < _minWindowsWithData) return null;

    final preAverage = _averageMoodOn(moodEntries, preWindowDays);
    final overallAverage = moodEntries.fold<int>(0, (sum, e) => sum + e.moodLevel) / moodEntries.length;
    if (preAverage == null) return null;

    final delta = overallAverage - preAverage;
    if (delta >= _minNoticeableDelta) {
      return 'Your mood tends to dip in the 1-3 days before your period, based on your logs.';
    }
    if (delta <= -_minNoticeableDelta) {
      return 'Your mood tends to lift in the days before your period, based on your logs.';
    }
    return "No strong mood pattern around your period yet -- that's a good sign.";
  }
}
