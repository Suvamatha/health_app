import 'dart:math' as math;

import '../../../models/symptom.dart';
import 'entities/period_entry.dart';

/// Where the user likely is in their cycle right now.
enum CyclePhase {
  menstrual,
  follicular,
  ovulation,
  luteal,
  unknown;

  String get label {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Period';
      case CyclePhase.follicular:
        return 'Follicular phase';
      case CyclePhase.ovulation:
        return 'Ovulation window';
      case CyclePhase.luteal:
        return 'Luteal phase';
      case CyclePhase.unknown:
        return 'Cycle';
    }
  }

  /// A short, plain-language explanation so the phase name is never
  /// confusing on its own.
  String get description {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Your period. Energy may be lower, so be gentle with yourself.';
      case CyclePhase.follicular:
        return 'Energy tends to build as your body prepares to ovulate.';
      case CyclePhase.ovulation:
        return 'Your estimated fertile window, usually the highest-energy days.';
      case CyclePhase.luteal:
        return 'The days between ovulation and your next period.';
      case CyclePhase.unknown:
        return 'Log a period day to start tracking your cycle.';
    }
  }
}

/// A computed snapshot of cycle predictions, always derived fresh from
/// logged [PeriodEntry] history -- never stored.
class CyclePrediction {
  final DateTime? lastPeriodStart;
  final int currentCycleDay;
  final double averageCycleLength;
  final int predictedLowDaysFromToday;
  final int predictedHighDaysFromToday;
  final DateTime? predictedNextStart;
  final CyclePhase phase;
  final bool hasEnoughData;
  final int loggedCycleCount;

  const CyclePrediction({
    required this.lastPeriodStart,
    required this.currentCycleDay,
    required this.averageCycleLength,
    required this.predictedLowDaysFromToday,
    required this.predictedHighDaysFromToday,
    required this.predictedNextStart,
    required this.phase,
    required this.hasEnoughData,
    required this.loggedCycleCount,
  });
}

/// Pure, stateless cycle math. Kept separate from widgets so predictions
/// stay testable and are never accidentally recomputed inconsistently.
class CycleInsights {
  CycleInsights._();

  static const int defaultCycleLength = 28;

  // `defaultCycleLength.toDouble()` is a method call, which Dart does not
  // allow inside a `const` expression. This double literal must stay in
  // sync with [defaultCycleLength] so the const "no data" prediction below
  // can use it directly.
  static const double _defaultCycleLengthAsDouble = 28.0;

  static const int defaultPeriodLength = 5;
  // The luteal phase (ovulation -> next period) is far more consistent
  // across cycle lengths than the follicular phase, so it's the standard
  // anchor used to estimate ovulation day from a predicted cycle length.
  static const int _lutealPhaseDays = 14;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Groups logged period days into cycles and returns the first day of
  /// each cycle (a "period start"), sorted oldest to newest. Consecutive
  /// calendar days (gap of 1) are treated as the same period.
  static List<DateTime> cycleStartDates(List<PeriodEntry> entries) {
    if (entries.isEmpty) return [];
    final days = entries.map((e) => _dateOnly(e.date)).toSet().toList()..sort();

    final starts = <DateTime>[days.first];
    for (var i = 1; i < days.length; i++) {
      final gap = days[i].difference(days[i - 1]).inDays;
      if (gap > 1) {
        starts.add(days[i]);
      }
    }
    return starts;
  }

  /// Lengths (in days) between consecutive period start dates.
  static List<int> cycleLengths(List<DateTime> starts) {
    final lengths = <int>[];
    for (var i = 1; i < starts.length; i++) {
      lengths.add(starts[i].difference(starts[i - 1]).inDays);
    }
    return lengths;
  }

  static double _average(List<int> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double _standardDeviation(List<int> values, double mean) {
    if (values.length < 2) return 0;
    final variance = values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
        (values.length - 1);
    return variance <= 0 ? 0 : math.sqrt(variance);
  }

  /// Computes the current cycle day, phase, and a predicted range for the
  /// next period -- instead of a single hardcoded number.
  static CyclePrediction predict(
    List<PeriodEntry> entries, {
    DateTime? today,
    int fallbackCycleLength = defaultCycleLength,
  }) {
    final now = _dateOnly(today ?? DateTime.now());
    final starts = cycleStartDates(entries);

    if (starts.isEmpty) {
      return const CyclePrediction(
        lastPeriodStart: null,
        currentCycleDay: 0,
        averageCycleLength: _defaultCycleLengthAsDouble,
        predictedLowDaysFromToday: 0,
        predictedHighDaysFromToday: 0,
        predictedNextStart: null,
        phase: CyclePhase.unknown,
        hasEnoughData: false,
        loggedCycleCount: 0,
      );
    }

    final lengths = cycleLengths(starts);
    final hasEnoughData = lengths.length >= 2;
    final averageCycleLength = lengths.isEmpty ? fallbackCycleLength.toDouble() : _average(lengths);
    final stdDev = _standardDeviation(lengths, averageCycleLength);
    // Confidence window: roughly +/- 1 standard deviation, with a minimum
    // spread so a short history still reads as an honest estimate rather
    // than false precision.
    final spread = stdDev < 1.5 ? 2.0 : stdDev;

    final lastStart = starts.last;
    final currentCycleDay = now.difference(lastStart).inDays + 1;

    final roundedAverage = averageCycleLength.round();
    final predictedNextStart = lastStart.add(Duration(days: roundedAverage));
    final lowDate = predictedNextStart.subtract(Duration(days: spread.round()));
    final highDate = predictedNextStart.add(Duration(days: spread.round()));
    final predictedLow = lowDate.difference(now).inDays;
    final predictedHigh = highDate.difference(now).inDays;

    final ovulationDay = roundedAverage - _lutealPhaseDays;
    CyclePhase phase;
    if (currentCycleDay <= defaultPeriodLength) {
      phase = CyclePhase.menstrual;
    } else if (currentCycleDay >= ovulationDay - 1 && currentCycleDay <= ovulationDay + 1) {
      phase = CyclePhase.ovulation;
    } else if (currentCycleDay < ovulationDay) {
      phase = CyclePhase.follicular;
    } else {
      phase = CyclePhase.luteal;
    }

    return CyclePrediction(
      lastPeriodStart: lastStart,
      currentCycleDay: currentCycleDay,
      averageCycleLength: averageCycleLength,
      predictedLowDaysFromToday: predictedLow,
      predictedHighDaysFromToday: predictedHigh,
      predictedNextStart: predictedNextStart,
      phase: phase,
      hasEnoughData: hasEnoughData,
      loggedCycleCount: lengths.length,
    );
  }

  /// How many times each symptom has been logged, across all history.
  static Map<Symptom, int> symptomFrequency(List<PeriodEntry> entries) {
    final freq = <Symptom, int>{};
    for (final entry in entries) {
      for (final symptom in entry.symptoms) {
        freq[symptom] = (freq[symptom] ?? 0) + 1;
      }
    }
    return freq;
  }

  /// The cycle day (1-indexed, relative to the nearest earlier period
  /// start) each symptom occurrence fell on, so trends can read like
  /// "cramps common on day 1-2" rather than raw calendar dates.
  static Map<Symptom, List<int>> symptomCycleDays(
    List<PeriodEntry> entries,
    List<DateTime> starts,
  ) {
    final result = <Symptom, List<int>>{};
    if (starts.isEmpty) return result;

    for (final entry in entries) {
      final day = _dateOnly(entry.date);
      DateTime? nearestStart;
      for (final start in starts) {
        if (!start.isAfter(day)) {
          if (nearestStart == null || start.isAfter(nearestStart)) {
            nearestStart = start;
          }
        }
      }
      if (nearestStart == null) continue;
      final cycleDay = day.difference(nearestStart).inDays + 1;
      for (final symptom in entry.symptoms) {
        result.putIfAbsent(symptom, () => []).add(cycleDay);
      }
    }
    return result;
  }
}