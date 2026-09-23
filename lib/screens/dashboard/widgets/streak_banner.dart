import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/dashboard_card.dart';
import '../../../features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../../features/gamification/presentation/cubit/gamification_state.dart';
import '../../../features/gamification/domain/rank.dart';

/// Shows current streak + Rank, reading live from GamificationCubit.
/// Gold accent color still appears ONLY here, on the dashboard — same
/// "scarce accent = feels earned" reasoning from Phase 2's design system.
class StreakBanner extends StatelessWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<GamificationCubit, GamificationState>(
      builder: (context, state) {
        if (state.isLoading || state.profile == null) {
          return const SizedBox.shrink(); // nothing to show yet — no jarring "0 streak" flash
        }

        final profile = state.profile!;
        final rank = Rank.fromXp(profile.totalXp);

        return DashboardCard(
          backgroundColor: theme.colorScheme.tertiary.withValues(alpha: 0.12),
          child: Row(
            children: [
              Icon(Icons.local_fire_department_outlined, color: theme.colorScheme.tertiary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.currentStreak == 0
                          ? 'Start your streak today'
                          : '${profile.currentStreak}-day check-in streak',
                      style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.tertiary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${rank.label} · ${profile.totalXp} XP',
                      style: theme.textTheme.bodyMedium,
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
}