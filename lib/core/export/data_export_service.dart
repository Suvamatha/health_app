import 'package:flutter/services.dart';
import '../../features/mood/domain/entities/mood_entry.dart';
import '../../features/period/domain/entities/period_entry.dart';
import '../../features/sleep/domain/sleep_entry.dart';

/// Builds a plain-text CSV export of the user's logged history and copies
/// it to the clipboard, ready to paste into an email or document to share
/// with a doctor. Kept dependency-free (no file-system/share packages) so
/// it works the same on every platform.
class DataExportService {
  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String buildCsv({
    required List<PeriodEntry> periodEntries,
    required List<MoodEntry> moodEntries,
    required List<SleepEntry> sleepEntries,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('type,date,details');

    final sortedPeriod = [...periodEntries]..sort((a, b) => a.date.compareTo(b.date));
    for (final entry in sortedPeriod) {
      final symptoms = entry.symptoms.map((s) => s.label).join('; ');
      buffer.writeln('period,${entry.date.toIso8601String()},${_csvEscape(symptoms)}');
    }

    final sortedMood = [...moodEntries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    for (final entry in sortedMood) {
      buffer.writeln('mood,${entry.loggedAt.toIso8601String()},level ${entry.moodLevel}/4');
    }

    final sortedSleep = [...sleepEntries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    for (final entry in sortedSleep) {
      buffer.writeln(
        'sleep,${entry.loggedAt.toIso8601String()},${entry.hours.toStringAsFixed(1)}h (${entry.quality.label})',
      );
    }

    return buffer.toString();
  }

  Future<void> copyCsvToClipboard({
    required List<PeriodEntry> periodEntries,
    required List<MoodEntry> moodEntries,
    required List<SleepEntry> sleepEntries,
  }) async {
    final csv = buildCsv(
      periodEntries: periodEntries,
      moodEntries: moodEntries,
      sleepEntries: sleepEntries,
    );
    await Clipboard.setData(ClipboardData(text: csv));
  }
}
