import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/core/notifications/notification_service.dart';
import 'package:healthtracker/core/theme/theme_cubit.dart';
import 'package:healthtracker/core/theme/theme_repository.dart';
import 'package:healthtracker/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:healthtracker/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:healthtracker/features/hydration/domain/repositories/hydration_repository.dart';
import 'package:healthtracker/features/hydration/presentation/cubit/hydration_cubit.dart';
import 'package:healthtracker/features/journal/domain/journal_repository.dart';
import 'package:healthtracker/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:healthtracker/features/mood/domain/repositories/mood_repository.dart';
import 'package:healthtracker/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:healthtracker/features/reminders/domain/reminder_repository.dart';
import 'package:healthtracker/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:healthtracker/features/sleep/domain/sleep_repository.dart';
import 'package:healthtracker/features/sleep/presentation/cubit/sleep_cubit.dart';
import 'core/router/app_router.dart';
import 'package:healthtracker/features/period/domain/repositories/period_repository.dart';
import 'core/theme/app_theme.dart';
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
          create: (context) => ThemeCubit(getIt<ThemeRepository>())..loadThemeMode(),
        ),
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
        ),
        BlocProvider(
          create: (context) => SleepCubit(getIt<SleepRepository>())..loadTodayEntry(),
        ),
        BlocProvider(
          create: (context) => JournalCubit(getIt<JournalRepository>())..loadEntryForDate(DateTime.now()),
        ),
        BlocProvider(
          create: (context) =>
              RemindersCubit(getIt<ReminderRepository>(), getIt<NotificationService>())..loadReminders(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Wellspring',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
