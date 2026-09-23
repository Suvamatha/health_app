import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/core/notifications/notification_service.dart';
import 'package:healthtracker/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:healthtracker/features/hydration/domain/repositories/hydration_repository.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_cubit.dart';
import 'package:healthtracker/features/mood/domain/repositories/mood_repository.dart';
import 'package:healthtracker/features/mood/presentation/cubit/mood_cubit.dart';
import 'core/router/app_router.dart';
import 'package:healthtracker/features/period/domain/repositories/period_repository.dart';
import 'package:healthtracker/screens/dashboard/dashboard_screen.dart';
import 'package:healthtracker/screens/history/history_screen.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'features/period/presentation/cycle_screen.dart';
import 'package:healthtracker/features/period/data/period_repository_impl.dart';
import 'package:healthtracker/features/period/presentation/cubit/period_cubit.dart';
import 'core/di/injection.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await getIt<NotificationService>().initialize();
  runApp(const WellnessApp());
}

class WellnessApp extends StatelessWidget {
  const WellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HydrationCubit(getIt<HydrationRepository>())..loadTodayEntries(),
        ),
        BlocProvider(
          create: (context) => MoodCubit(getIt<MoodRepository>())..loadTodayEntry(),
        ),
        BlocProvider(
          create: (context) => PeriodCubit(getIt<PeriodRepository>())..loadEntries(),
        ),
        BlocProvider(
          create: (context) => GamificationCubit(getIt<GamificationRepositoryImpl>())..loadProfile(),
        )
      ],
      child: MaterialApp.router(
        title: 'Wellness Appp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}