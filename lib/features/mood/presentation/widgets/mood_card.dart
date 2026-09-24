import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../../../widgets/dashboard_card.dart';
import '../cubit/mood_cubit.dart';
import '../cubit/mood_state.dart';

class MoodCard extends StatelessWidget {
  const MoodCard({super.key});

  static const List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied_outlined,
    Icons.sentiment_neutral_outlined,
    Icons.sentiment_satisfied_outlined,
    Icons.sentiment_very_satisfied_outlined,
  ];

  static const List<String> _moodLabels = ['Low', 'Okay', 'Good', 'Great'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_outline, color: theme.colorScheme.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text('Mood check-in', style: theme.textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_moodIcons.length, (index) {
                  final level = index + 1; // levels are 1-4, indices are 0-3
                  final isSelected = state.selectedMoodLevel == level;
                  return GestureDetector(
                    onTap: () {
                      context.read<MoodCubit>().selectMood(level);
                      context.read<GamificationCubit>().recordCheckIn();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.secondary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.secondary.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _moodIcons[index],
                            color: isSelected
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _moodLabels[index],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.secondary
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
