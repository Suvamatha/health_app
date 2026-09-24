// lib/screens/insights/insights_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/dashboard_card.dart';
import '../../features/period/presentation/cubit/period_cubit.dart';
import '../../features/period/presentation/cubit/period_state.dart';
import '../../features/period/domain/cycle_insights.dart';
import '../../features/period/presentation/widgets/symptom_trends_card.dart';
import '../../features/mood/presentation/cubit/mood_cubit.dart';
import '../../features/mood/domain/mood_insights.dart';
import '../../features/mood/domain/entities/mood_entry.dart';
import '../../features/sleep/presentation/cubit/sleep_cubit.dart';
import '../../features/sleep/domain/sleep_entry.dart';
import '../../features/hydration/widgets/hydration_weekly_chart.dart';
import '../../features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../features/gamification/presentation/cubit/gamification_state.dart';

/// A weekly "recap" screen that pulls together signals the app already
/// collects (cycle, mood, sleep, hydration, streaks) into one gentle
/// summary, rather than making the user piece it together themselves.
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  List<MoodEntry>? _moodEntries;
  List<SleepEntry>? _sleepEntries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final mood = await context.read<MoodCubit>().getAllEntries();
    final sleep = await context.read<SleepCubit>().getAllEntries();
    if (!mounted) return;
    setState(() {
      _moodEntries = mood;
      _sleepEntries = sleep;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PeriodCubit, PeriodState>(
          builder: (context, periodState) {
            final starts = CycleInsights.cycleStartDates(periodState.entries);
            final moodEntries = _moodEntries;
            final sleepEntries = _sleepEntries;

            final moodInsight = moodEntries == null
                ? null
                : MoodInsights.preMenstrualMoodInsight(moodEntries: moodEntries, cycleStarts: starts);

            final avgSleep = (sleepEntries == null || sleepEntries.isEmpty)
                ? null
                : sleepEntries.map((e) => e.hours).reduce((a, b) => a + b) / sleepEntries.length;

            return ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                Text('Your week in review', style: theme.textTheme.displayLarge),
                const SizedBox(height: 4),
                Text('A gentle recap, not a report card.', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 20),
                BlocBuilder<GamificationCubit, GamificationState>(
                  builder: (context, gState) {
                    final profile = gState.profile;
                    return DashboardCard(
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department_outlined, color: theme.colorScheme.secondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${profile?.currentStreak ?? 0}-day streak',
                                  style: theme.textTheme.labelLarge,
                                ),
                                Text(
                                  'Longest streak: ${profile?.longestStreak ?? 0} days',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const HydrationWeeklyChart(),
                const SizedBox(height: 16),
                if (moodInsight != null) ...[
                  DashboardCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite_border, color: theme.colorScheme.secondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(moodInsight, style: theme.textTheme.bodyMedium)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (avgSleep != null) ...[
                  DashboardCard(
                    child: Row(
                      children: [
                        Icon(Icons.bedtime_outlined, color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Averaging ${avgSleep.toStringAsFixed(1)}h of sleep recently.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SymptomTrendsCard(entries: periodState.entries, cycleStarts: starts),
                const SizedBox(height: 96),
              ],
            );
          },
        ),
      ),
    );
  }
}
