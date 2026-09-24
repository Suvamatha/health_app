import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../../../widgets/dashboard_card.dart';
import '../../domain/sleep_entry.dart';
import '../cubit/sleep_cubit.dart';
import '../cubit/sleep_state.dart';

class SleepCard extends StatefulWidget {
  const SleepCard({super.key});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  double _pendingHours = 7;

  static const List<IconData> _qualityIcons = [
    Icons.sentiment_very_dissatisfied_outlined,
    Icons.sentiment_neutral_outlined,
    Icons.sentiment_satisfied_outlined,
    Icons.sentiment_very_satisfied_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SleepCubit, SleepState>(
      builder: (context, state) {
        final hours = state.hoursLogged ?? _pendingHours;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bedtime_outlined, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Sleep', style: theme.textTheme.labelLarge),
                  const Spacer(),
                  Text(
                    '${hours.toStringAsFixed(1)}h',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Slider(
                value: hours.clamp(0, 12),
                min: 0,
                max: 12,
                divisions: 24,
                label: '${hours.toStringAsFixed(1)}h',
                onChanged: (value) => setState(() => _pendingHours = value),
                onChangeEnd: (value) {
                  final quality = state.quality ?? SleepQuality.fair;
                  context.read<SleepCubit>().logSleep(hours: value, quality: quality);
                  context.read<GamificationCubit>().recordCheckIn();
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(SleepQuality.values.length, (index) {
                  final quality = SleepQuality.values[index];
                  final isSelected = state.quality == quality;
                  return GestureDetector(
                    onTap: () {
                      context.read<SleepCubit>().logSleep(hours: hours, quality: quality);
                      context.read<GamificationCubit>().recordCheckIn();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _qualityIcons[index],
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quality.label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.35),
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
