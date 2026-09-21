import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/core/theme/app_spacing.dart';
import 'package:healthtracker/features/hydration/widgets/hydration_card.dart';
import 'package:healthtracker/models/user_profile.dart';
import 'package:healthtracker/features/hydration/data/repositories/hydration_repository_impl.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_cubit.dart';
import 'package:healthtracker/features/mood/data/repositories/mood_repository_impl.dart';
import 'package:healthtracker/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:healthtracker/features/mood/presentation/widgets/mood_card.dart';
import 'widgets/greeting_header.dart';
import 'widgets/cycle_card.dart';
import 'widgets/streak_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _dummyProfile = UserProfile(
    name: 'Babe',
    dailyHydrationGoalGlasses: 8,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HydrationCubit(HydrationRepositoryImpl())..loadTodayEntries(),
        ),
        BlocProvider(
          create: (context) => MoodCubit(MoodRepositoryImpl())..loadTodayEntry(),
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }
}