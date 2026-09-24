import 'package:flutter/material.dart';
import '../../../../models/symptom.dart';
import '../../../../widgets/dashboard_card.dart';
import '../../domain/cycle_insights.dart';
import '../../domain/entities/period_entry.dart';

/// Surfaces which symptoms recur most, and roughly which cycle day they
/// tend to show up on, e.g. "Cramps -- usually day 1-2".
class SymptomTrendsCard extends StatelessWidget {
  final List<PeriodEntry> entries;
  final List<DateTime> cycleStarts;

  const SymptomTrendsCard({
    super.key,
    required this.entries,
    required this.cycleStarts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final frequency = CycleInsights.symptomFrequency(entries);

    if (frequency.isEmpty) {
      return DashboardCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(theme: theme),
            const SizedBox(height: 8),
            Text(
              'Log symptoms alongside your period to see patterns here over time.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    final cycleDaysBySymptom = CycleInsights.symptomCycleDays(entries, cycleStarts);
    final sorted = frequency.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = sorted.first.value;
    final top = sorted.take(5).toList();

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(theme: theme),
          const SizedBox(height: 16),
          ...top.map((item) {
            final symptom = item.key;
            final count = item.value;
            final days = cycleDaysBySymptom[symptom] ?? const <int>[];
            final ratio = count / maxCount;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        symptom.label,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _typicalDayLabel(days),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Container(
                              height: 8,
                              width: constraints.maxWidth,
                              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                            ),
                            Container(
                              height: 8,
                              width: constraints.maxWidth * ratio,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.secondary,
                                    theme.colorScheme.secondary.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _typicalDayLabel(List<int> days) {
    if (days.isEmpty) return '';
    final sorted = List<int>.from(days)..sort();
    final min = sorted.first;
    final max = sorted.last;
    if (min == max) return 'usually day $min';
    return 'usually day $min-$max';
  }
}

class _Header extends StatelessWidget {
  final ThemeData theme;
  const _Header({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.insights_outlined, color: theme.colorScheme.secondary, size: 20),
        const SizedBox(width: 8),
        Text('Symptom trends', style: theme.textTheme.labelLarge),
      ],
    );
  }
}
