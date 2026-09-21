import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_moodIcons.length, (index) {
                  final level = index + 1; // levels are 1-4, indices are 0-3
                  final isSelected = state.selectedMoodLevel == level;
                  return GestureDetector(
                    onTap: () => context.read<MoodCubit>().selectMood(level),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.secondary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _moodIcons[index],
                        color: isSelected
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
