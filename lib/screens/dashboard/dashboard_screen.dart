import 'package:flutter/material.dart';
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
