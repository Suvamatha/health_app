import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/screens/dashboard/dashboard_screen.dart';
import 'package:healthtracker/screens/history/history_screen.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'features/period/presentation/cycle_screen.dart';
import 'package:healthtracker/features/period/data/period_repository_impl.dart';
import 'package:healthtracker/features/period/presentation/cubit/period_cubit.dart';

void main() {
  runApp(const WellnessApp());
}

class WellnessApp extends StatelessWidget {
  const WellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false ,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (context) => PeriodCubit(PeriodRepositoryImpl())..loadEntries(),
        child: const CycleScreen(),
      ),
    );
  }
}