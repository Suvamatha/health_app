// lib/features/hydration/presentation/widgets/hydration_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_cubit.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_state.dart';
import '../../../../widgets/dashboard_card.dart';

class HydrationCard extends StatelessWidget {
  const HydrationCard({super.key});

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
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                ).createShader(bounds),
                child: SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
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
              const SizedBox(width: 8),
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
