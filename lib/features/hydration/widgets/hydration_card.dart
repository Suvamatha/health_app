// lib/features/hydration/presentation/widgets/hydration_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_cubit.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_state.dart';
import '../../../../widgets/dashboard_card.dart';

class HydrationCard extends StatelessWidget {
  const HydrationCard({super.key});

  Future<void> _editGoal(BuildContext context, int currentGoal) async {
    final cubit = context.read<HydrationCubit>();
    var draft = currentGoal;
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Daily hydration goal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How many glasses of water a day feels right for you?',
                    style: Theme.of(dialogContext).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: draft > 1
                            ? () => setDialogState(() => draft -= 1)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(
                          '$draft',
                          textAlign: TextAlign.center,
                          style: Theme.of(dialogContext).textTheme.displayMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: draft < 20
                            ? () => setDialogState(() => draft += 1)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  Text('glasses / day', style: Theme.of(dialogContext).textTheme.bodySmall),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(draft),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result != currentGoal) {
      await cubit.setDailyGoal(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HydrationCubit, HydrationState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const DashboardCard(
            child: SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final progress = (state.glassesLoggedToday / state.dailyGoal).clamp(0.0, 1.0);
        final isDone = state.glassesLoggedToday >= state.dailyGoal;

        return DashboardCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    ).createShader(bounds),
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6.5,
                        strokeCap: StrokeCap.round,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDone ? Icons.check_circle_outline : Icons.water_drop,
                        size: 16,
                        color: isDone ? theme.colorScheme.primary : theme.colorScheme.primary.withValues(alpha: 0.85),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${state.glassesLoggedToday}/${state.dailyGoal}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.water_drop_outlined, color: theme.colorScheme.primary, size: 18),
                        const SizedBox(width: 6),
                        Text('Hydration', style: theme.textTheme.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDone
                          ? 'Goal reached — nice!'
                          : '${state.glassesLoggedToday} of ${state.dailyGoal} glasses',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => _editGoal(context, state.dailyGoal),
                tooltip: 'Change daily goal',
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              _AddGlassButton(
                onTap: () {
                  context.read<HydrationCubit>().addGlass();
                  context.read<GamificationCubit>().recordCheckIn();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddGlassButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddGlassButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}