// lib/features/period/presentation/cycle_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../widgets/dashboard_card.dart';
import '../../../models/symptom.dart';
import '../domain/cycle_insights.dart';
import 'cubit/period_cubit.dart';
import 'cubit/period_state.dart';
import 'widgets/cycle_calendar.dart';
import 'widgets/symptom_chip.dart';
import 'widgets/symptom_trends_card.dart';

class CycleScreen extends StatefulWidget {
  const CycleScreen({super.key});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  late DateTime _displayedMonth;

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PeriodCubit, PeriodState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final loggedDays = state.entries
                .where((entry) =>
                    entry.date.year == _displayedMonth.year && entry.date.month == _displayedMonth.month)
                .map((entry) => entry.date.day)
                .toSet();

            final starts = CycleInsights.cycleStartDates(state.entries);
            final prediction = CycleInsights.predict(state.entries);

            DateTimeRange? predictedRange;
            if (prediction.predictedNextStart != null) {
              final spreadDays =
                  ((prediction.predictedHighDaysFromToday - prediction.predictedLowDaysFromToday) / 2)
                      .round()
                      .abs();
              predictedRange = DateTimeRange(
                start: prediction.predictedNextStart!.subtract(Duration(days: spreadDays)),
                end: prediction.predictedNextStart!.add(Duration(days: spreadDays)),
              );
            }

            final now = DateTime.now();
            final isCurrentMonth = now.year == _displayedMonth.year && now.month == _displayedMonth.month;

            return ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                Text('Cycle', style: theme.textTheme.displayLarge),
                const SizedBox(height: 4),
                Text('Gentle tracking, no pressure.', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 20),
                DashboardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => _shiftMonth(-1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Text(
                            '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                            style: theme.textTheme.labelLarge,
                          ),
                          IconButton(
                            onPressed: isCurrentMonth ? null : () => _shiftMonth(1),
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CycleCalendar(
                        displayedMonth: _displayedMonth,
                        loggedDays: loggedDays,
                        predictedRange: isCurrentMonth ? predictedRange : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<PeriodCubit>().logPeriodDay(now);
                      context.read<GamificationCubit>().recordCheckIn();
                    },
                    style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.secondary),
                    icon: const Icon(Icons.favorite, size: 18),
                    label: const Text('Log period day'),
                  ),
                ),
                const SizedBox(height: 28),
                Text('How are you feeling today?', style: theme.textTheme.labelLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(Symptom.values.length, (index) {
                    final symptom = Symptom.values[index];
                    return SymptomChip(
                      label: symptom.label,
                      isSelected: state.selectedSymptomIndexes.contains(index),
                      onTap: () => context.read<PeriodCubit>().toggleSymptom(index),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                SymptomTrendsCard(entries: state.entries, cycleStarts: starts),
                const SizedBox(height: 96),
              ],
            );
          },
        ),
      ),
    );
  }
}
