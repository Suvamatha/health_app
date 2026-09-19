import 'package:flutter/material.dart';
import 'package:healthtracker/core/theme/app_spacing.dart';
import 'widgets/greeting_header.dart';
import 'widgets/cycle_card.dart';
import 'widgets/hydration_card.dart';
import 'widgets/mood_card.dart';
import 'widgets/streak_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children:const [
            GreetingHeader(name: 'Babe'),
            SizedBox(height: 24,),
            // Row(
            //   children: [
            //     Expanded(child: HydrationCard()),
            //     SizedBox(width: 12,),
            //     Expanded(child: MoodCard()),
            //   ],
            // ),
            Column(
              children: [
                HydrationCard(),
                SizedBox(height: 12,),
                MoodCard(),
              ],
            ),
            SizedBox(height: 12,),
            CycleCard(),
            SizedBox(height: 12,),
            StreakBanner(),
          ],
        ),
      ),
    );
  }
}