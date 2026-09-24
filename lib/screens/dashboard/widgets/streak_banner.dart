import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_radius.dart';
import '../../../features/gamification/presentation/cubit/gamification_cubit.dart';
import '../../../features/gamification/presentation/cubit/gamification_state.dart';
import '../../../features/gamification/domain/rank.dart';

/// Shows current streak + Rank, reading live from GamificationCubit.
/// Wrapped in a warm gold gradient — the ONE gradient moment on the
/// dashboard, so an earned streak still feels special rather than routine.
/// Same "scarce accent = feels earned" reasoning from Phase 2's design system.
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

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.tertiary.withValues(alpha: 0.85),
                theme.colorScheme.tertiary.withValues(alpha: 0.55),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.currentStreak == 0
                          ? 'Start your streak today'
                          : '${profile.currentStreak}-day check-in streak',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${rank.label} · ${profile.totalXp} XP',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
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
