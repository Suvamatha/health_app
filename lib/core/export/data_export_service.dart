import 'package:flutter/services.dart';
import '../../features/mood/domain/entities/mood_entry.dart';
import '../../features/period/domain/entities/period_entry.dart';
import '../../features/sleep/domain/sleep_entry.dart';

class DataExportService {
  static const _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  static const _moodLabels = ['Low', 'Okay', 'Good', 'Great'];

  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  String buildReport({
    required List<PeriodEntry> periodEntries,
    required List<MoodEntry> moodEntries,
    required List<SleepEntry> sleepEntries,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Wellspring Health Summary');
    buffer.writeln('Exported ${_formatDate(DateTime.now())}');
    buffer.writeln();

    buffer.writeln('CYCLE');
    if (periodEntries.isEmpty) {
      buffer.writeln('No cycle data logged yet.');
    } else {
      final sorted = [...periodEntries]..sort((a, b) => a.date.compareTo(b.date));
      for (final e in sorted) {
        final symptoms = e.symptoms.isEmpty ? 'Period day logged' : e.symptoms.map((s) => s.label).join(', ');
        buffer.writeln('${_formatDate(e.date)} — $symptoms');
      }
    }
    buffer.writeln();

    buffer.writeln('MOOD');
    if (moodEntries.isEmpty) {
      buffer.writeln('No mood check-ins logged yet.');
    } else {
      final sorted = [...moodEntries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      for (final e in sorted) {
        buffer.writeln('${_formatDate(e.loggedAt)} — ${_moodLabels[e.moodLevel - 1]}');
      }
    }
    buffer.writeln();

    buffer.writeln('SLEEP');
    if (sleepEntries.isEmpty) {
      buffer.writeln('No sleep entries logged yet.');
    } else {
      final sorted = [...sleepEntries]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      for (final e in sorted) {
        buffer.writeln('${_formatDate(e.loggedAt)} — ${e.hours.toStringAsFixed(1)}h (${e.quality.label})');
      }
    }

    return buffer.toString().trim();
  }

  Future<void> copyReportToClipboard({
    required List<PeriodEntry> periodEntries,
    required List<MoodEntry> moodEntries,
    required List<SleepEntry> sleepEntries,
  }) async {
    final report = buildReport(periodEntries: periodEntries, moodEntries: moodEntries, sleepEntries: sleepEntries);
    await Clipboard.setData(ClipboardData(text: report));
  }
}