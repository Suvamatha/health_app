import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/widgets/onboarding_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../features/period/presentation/cycle_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/insights/insights_screen.dart';
import '../../screens/setting/settings_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/appearance/appearance_screen.dart';
import '../../screens/privacy/privacy_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../navigation/scaffold_with_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/appearance',
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/dashboard', builder: (context, state)=> const DashboardScreen())
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/cycle', builder: (context, state) => const CycleScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/insights', builder: (context, state) => const InsightsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
          ],
        ),
      ]
    )
  ]
);
