import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/dashboard_card.dart';
import '../../domain/cycle_insights.dart';
import '../cubit/period_cubit.dart';
import '../cubit/period_state.dart';

class CycleCard extends StatelessWidget {
  const CycleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PeriodCubit, PeriodState>(
      builder: (context, state) {
        final prediction = CycleInsights.predict(state.entries);

        if (prediction.lastPeriodStart == null) {
          return DashboardCard(
            child: Row(
              children: [
                _DayBadge(theme: theme, label: '—'),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start tracking your cycle', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Log a period day on the Cycle tab to see predictions here.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return DashboardCard(
          child: Row(
            children: [
              _DayBadge(theme: theme, label: 'Day\n${prediction.currentCycleDay}'),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prediction.phase.label, style: theme.textTheme.labelLarge),
                    const SizedBox(height: 2),
                    Text(
                      prediction.phase.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _rangeLabel(prediction),
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _rangeLabel(CyclePrediction prediction) {
    final low = prediction.predictedLowDaysFromToday;
    final high = prediction.predictedHighDaysFromToday;
    final suffix = prediction.hasEnoughData ? '' : ' (estimate)';

    if (high <= 0) {
      return 'Next period may be starting now$suffix';
    }
    if (low <= 0) {
      return 'Expected any day now (within $high days)$suffix';
    }
    return 'Expected in $low-$high days$suffix';
  }
}

class _DayBadge extends StatelessWidget {
  final ThemeData theme;
  final String label;

  const _DayBadge({required this.theme, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.secondary.withValues(alpha: 0.7),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
