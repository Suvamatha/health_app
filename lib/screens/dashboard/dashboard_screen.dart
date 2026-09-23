import 'package:flutter/material.dart';
import 'package:healthtracker/features/hydration/widgets/hydration_card.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/user_profile.dart';
import '../../features/mood/presentation/widgets/mood_card.dart';
import '../../features/period/presentation/widgets/cycle_card.dart';
import 'widgets/greeting_header.dart';
import 'widgets/streak_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _dummyProfile = UserProfile(
    name: 'Babe',
    dailyHydrationGoalGlasses: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            GreetingHeader(name: _dummyProfile.name),
            const SizedBox(height: 24),
            const Column(
              children: [
                HydrationCard(),
                SizedBox(height: 12),
                MoodCard(),
              ],
            ),
            const SizedBox(height: 12),
            const CycleCard(),
            const SizedBox(height: 12),
            const StreakBanner(),
          ],
        ),
      ),
    );
  }
}