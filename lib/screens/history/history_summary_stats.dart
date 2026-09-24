import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/hydration/presentation/cubit/hydration_cubit.dart';
import '../../../features/hydration/presentation/cubit/hydration_state.dart';
import '../../../features/mood/presentation/cubit/mood_cubit.dart';
import '../../../features/mood/presentation/cubit/mood_state.dart';
import '../../../features/period/presentation/cubit/period_cubit.dart';
import '../../../features/period/presentation/cubit/period_state.dart';
import '../../../features/sleep/presentation/cubit/sleep_cubit.dart';
import '../../../features/sleep/presentation/cubit/sleep_state.dart';
import '../../../widgets/dashboard_card.dart';

enum _StatsRange { week, month }

class _StatsSummary {
  final double avgHydration;
  final double? avgSleepHours;
  final int moodCheckIns;
  final int periodDaysLogged;
  final int totalDays;

  const _StatsSummary({
    required this.avgHydration,
    required this.avgSleepHours,
    required this.moodCheckIns,
    required this.periodDaysLogged,
    required this.totalDays,
  });
}

/// A rolled-up view of the last week or month, so History isn't only a
/// day-by-day log -- it also answers "how am I actually doing lately?"
class HistorySummaryStats extends StatefulWidget {
  const HistorySummaryStats({super.key});

  @override
  State<HistorySummaryStats> createState() => _HistorySummaryStatsState();
}

class _HistorySummaryStatsState extends State<HistorySummaryStats> {
  _StatsRange _range = _StatsRange.week;
  Future<_StatsSummary>? _future;

  @override
  void initState() {
    super.initState();
    _future = _computeSummary(_range);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _inDates(DateTime date, List<DateTime> dates) {
    return dates.any((d) => _isSameDay(d, date));
  }

  Future<_StatsSummary> _computeSummary(_StatsRange range) async {
    final days = range == _StatsRange.week ? 7 : 30;
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final dates = List.generate(
      days,
      (i) => startOfToday.subtract(Duration(days: days - 1 - i)),
    );

    final hydrationCubit = context.read<HydrationCubit>();
    final sleepCubit = context.read<SleepCubit>();
    final moodCubit = context.read<MoodCubit>();
    final periodCubit = context.read<PeriodCubit>();

    final hydrationCounts = await Future.wait(
      dates.map((d) => hydrationCubit.getGlassesCountForDate(d)),
    );
    final avgHydration = hydrationCounts.isEmpty
        ? 0.0
        : hydrationCounts.reduce((a, b) => a + b) / hydrationCounts.length;

    final allSleep = await sleepCubit.getAllEntries();
    final sleepInRange = allSleep.where((e) => _inDates(e.loggedAt, dates)).toList();
    final avgSleepHours = sleepInRange.isEmpty
        ? null
        : sleepInRange.map((e) => e.hours).reduce((a, b) => a + b) / sleepInRange.length;

    final allMood = await moodCubit.getAllEntries();
    final moodInRange = allMood.where((e) => _inDates(e.loggedAt, dates)).toList();

    final periodDaysLogged =
        periodCubit.state.entries.where((e) => _inDates(e.date, dates)).length;

    return _StatsSummary(
      avgHydration: avgHydration,
      avgSleepHours: avgSleepHours,
      moodCheckIns: moodInRange.length,
      periodDaysLogged: periodDaysLogged,
      totalDays: days,
    );
  }

  void _changeRange(_StatsRange range) {
    if (range == _range) return;
    setState(() {
      _range = range;
      _future = _computeSummary(range);
    });
  }

  // Re-run the computation whenever hydration, sleep, mood, or period data
  // changes anywhere in the app. Without this, the summary was only ever
  // computed once (in initState) and stayed frozen at whatever it was the
  // very first time History was opened -- so newly logged glasses, sleep,
  // moods, or period days never showed up here even though the day-by-day
  // row above (which re-fetches on every rebuild) looked correct.
  void _recompute() {
    if (!mounted) return;
    setState(() {
      _future = _computeSummary(_range);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<HydrationCubit, HydrationState>(listener: (_, __) => _recompute()),
        BlocListener<SleepCubit, SleepState>(listener: (_, __) => _recompute()),
        BlocListener<MoodCubit, MoodState>(listener: (_, __) => _recompute()),
        BlocListener<PeriodCubit, PeriodState>(listener: (_, __) => _recompute()),
      ],
      child: DashboardCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights_outlined, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Summary', style: theme.textTheme.labelLarge)),
                _RangeToggle(range: _range, onChanged: _changeRange),
              ],
            ),
            const SizedBox(height: 18),
            FutureBuilder<_StatsSummary>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                final summary = snapshot.data!;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            icon: Icons.water_drop_outlined,
                            label: 'Avg hydration',
                            value: '${summary.avgHydration.toStringAsFixed(1)} glasses/day',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatTile(
                            icon: Icons.bedtime_outlined,
                            label: 'Avg sleep',
                            value: summary.avgSleepHours != null
                                ? '${summary.avgSleepHours!.toStringAsFixed(1)}h'
                                : 'No data',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            icon: Icons.favorite_outline,
                            label: 'Mood check-ins',
                            value: '${summary.moodCheckIns}/${summary.totalDays} days',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatTile(
                            icon: Icons.calendar_today_outlined,
                            label: 'Period days logged',
                            value: '${summary.periodDaysLogged}',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeToggle extends StatelessWidget {
  final _StatsRange range;
  final ValueChanged<_StatsRange> onChanged;

  const _RangeToggle({required this.range, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget chip(String label, _StatsRange value) {
      final isSelected = range == value;
      return GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip('Week', _StatsRange.week),
          chip('Month', _StatsRange.month),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}