import 'package:flutter/services.dart';
import '../../features/mood/domain/entities/mood_entry.dart';
import '../../features/period/domain/entities/period_entry.dart';
import '../../features/sleep/domain/sleep_entry.dart';

/// Builds a plain-English health summary and copies it to the clipboard,
/// ready to paste into an email, note, or message to share with a doctor.
///
/// A raw CSV is technically "correct" but unreadable once pasted outside a
/// spreadsheet (a doctor pasting into a text message just sees
/// "period,2026-09-21T00:00:00.000,Cramps; Bloating"). This produces a
/// grouped, human-readable report instead — no extra packages needed.
class DataExportService {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  static const _moodLabels = ['Low', 'Okay', 'Good', 'Great'];

  String buildReport({
    required List<PeriodEntry> periodEntries,
    required List<MoodEntry> moodEntries,
    required List<SleepEntry> sleepEntries,
  }) {
    final buffer = StringBuffer();
    final now = DateTime.now();

    buffer.writeln('Wellspring Health Summary');
    buffer.writeln('Exported ${_formatDate(now)}');
    buffer.writeln();

    buffer.writeln('CYCLE');
    if (periodEntries.isEmpty) {
      buffer.writeln('No cycle data logged yet.');
    } else {
      final sorted = [...periodEntries]..sort((a, b) => a.date.compareTo(b.date));
      for (final entry in sorted) {
        final symptoms = entry.symptoms.isEmpty
            ? 'Period day logged'
            : entry.symptoms.map((s) => s.label).join(', ');
        buffer.writeln('${_formatDate(entry.date)} — $symptoms');
      }
    }
    buffer.writeln();

    buffer.writeln('MOOD');
    if (moodEntries.isEmpty) {
      buffer.writeln('No mood check-ins logged yet.');
    } else {
      final sorted = [...moodEntries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      for (final entry in sorted) {
        final label = _moodLabels[entry.moodLevel - 1];
        buffer.writeln('${_formatDate(entry.loggedAt)} — $label');
      }
    }
    buffer.writeln();

    buffer.writeln('SLEEP');
    if (sleepEntries.isEmpty) {
      buffer.writeln('No sleep entries logged yet.');
    } else {
      final sorted = [...sleepEntries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      for (final entry in sorted) {
        buffer.writeln(
          '${_formatDate(entry.loggedAt)} — ${entry.hours.toStringAsFixed(1)}h (${entry.quality.label})',
        );
      }
    }

    return buffer.toString().trim();
  }

  Future<void> copyReportToClipboard({
    required List<PeriodEntry> periodEntries,
    required List<MoodEntry> moodEntries,
    required List<SleepEntry> sleepEntries,
  }) async {
    final report = buildReport(
      periodEntries: periodEntries,
      moodEntries: moodEntries,
      sleepEntries: sleepEntries,
    );
    await Clipboard.setData(ClipboardData(text: report));
  }
}
