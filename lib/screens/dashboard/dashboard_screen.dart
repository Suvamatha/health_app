import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthtracker/features/hydration/widgets/hydration_card.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/mood/presentation/widgets/mood_card.dart';
import '../../features/period/presentation/widgets/cycle_card.dart';
import '../../features/sleep/presentation/widgets/sleep_card.dart';
import 'widgets/greeting_header.dart';
import 'widgets/streak_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            const GreetingHeader(),
            const SizedBox(height: 24),
            const StreakBanner(),
            const SizedBox(height: 16),
            const HydrationCard(),
            const SizedBox(height: 12),
            _CustomRemindersShortcut(onTap: () => context.push('/reminders')),
            const SizedBox(height: 12),
            const MoodCard(),
            const SizedBox(height: 12),
            const CycleCard(),
            const SizedBox(height: 12),
            const SleepCard(),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}

class _CustomRemindersShortcut extends StatelessWidget {
  final VoidCallback onTap;

  const _CustomRemindersShortcut({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.alarm_add_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        title: const Text('My reminders'),
        subtitle: const Text('Medication, self-care, and custom nudges'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
