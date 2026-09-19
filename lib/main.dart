import 'package:flutter/material.dart';
import 'package:healthtracker/screens/dashboard/dashboard_screen.dart';
import 'package:healthtracker/screens/history/history_screen.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/cycle/cycle_screen.dart';

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
      home: const DashboardScreen(),
    );
  }
}