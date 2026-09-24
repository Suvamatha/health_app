import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_cubit.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_state.dart';
import '../../../widgets/dashboard_card.dart';

/// A 7-day hydration history so progress feels visible over time instead
/// of only showing today's ring.
class HydrationWeeklyChart extends StatefulWidget {
  const HydrationWeeklyChart({super.key});

  @override
  State<HydrationWeeklyChart> createState() => _HydrationWeeklyChartState();
}

class _HydrationWeeklyChartState extends State<HydrationWeeklyChart> {
  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  List<int>? _glassesByDay;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cubit = context.read<HydrationCubit>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Oldest to newest, ending today.
    final days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
    final counts = await Future.wait(days.map((d) => cubit.getGlassesCountForDate(d)));
    if (!mounted) return;
    setState(() => _glassesByDay = counts);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counts = _glassesByDay;

    return BlocBuilder<HydrationCubit, HydrationState>(
      builder: (context, state) {
        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop_outlined, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('This week', style: theme.textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 20),
              if (counts == null)
                const SizedBox(
                  height: 96,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                SizedBox(
                  height: 96,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (i) {
                      final count = counts[i];
                      final ratio = (count / state.dailyGoal).clamp(0.0, 1.0);
                      final reachedGoal = count >= state.dailyGoal;
                      final isToday = i == 6;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '$count',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FractionallySizedBox(
                                    heightFactor: ratio == 0 ? 0.03 : ratio,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: reachedGoal
                                              ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                                              : [
                                                  theme.colorScheme.primary.withValues(alpha: 0.55),
                                                  theme.colorScheme.primary.withValues(alpha: 0.35),
                                                ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _dayLabels[i],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                  color: isToday
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
