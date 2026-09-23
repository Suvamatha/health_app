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
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final progress = state.glassesLoggedToday / state.dailyGoal;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop_outlined, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Hydration', style: theme.textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0, 1),
                      strokeWidth: 6,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                    ),
                  ),
                  Text(
                    '${state.glassesLoggedToday}/${state.dailyGoal}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<HydrationCubit>().addGlass();
                    context.read<GamificationCubit>().recordCheckIn();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add glass'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}