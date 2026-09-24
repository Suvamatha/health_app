import 'package:get_it/get_it.dart';
import 'package:healthtracker/core/notifications/notification_service.dart';
import 'package:healthtracker/core/theme/theme_repository.dart';
import 'package:healthtracker/core/theme/theme_repository_impl.dart';
import 'package:healthtracker/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:healthtracker/features/hydration/data/repositories/hydration_repository_impl.dart';
import 'package:healthtracker/features/hydration/domain/repositories/hydration_repository.dart';
import 'package:healthtracker/features/journal/data/journal_repository_impl.dart';
import 'package:healthtracker/features/journal/domain/journal_repository.dart';
import 'package:healthtracker/features/mood/data/repositories/mood_repository_impl.dart';
import 'package:healthtracker/features/mood/domain/repositories/mood_repository.dart';
import 'package:healthtracker/features/period/data/period_repository_impl.dart';
import 'package:healthtracker/features/period/domain/repositories/period_repository.dart';
import 'package:healthtracker/features/reminders/data/reminder_repository_impl.dart';
import 'package:healthtracker/features/reminders/domain/reminder_repository.dart';
import 'package:healthtracker/features/sleep/data/sleep_repository_impl.dart';
import 'package:healthtracker/features/sleep/domain/sleep_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<HydrationRepository>(() => HydrationRepositoryImpl());
  getIt.registerLazySingleton<MoodRepository>(() => MoodRepositoryImpl());
  getIt.registerLazySingleton<PeriodRepository>(() => PeriodRepositoryImpl());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<GamificationRepositoryImpl>(() => GamificationRepositoryImpl());
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());
  getIt.registerLazySingleton<SleepRepository>(() => SleepRepositoryImpl());
  getIt.registerLazySingleton<JournalRepository>(() => JournalRepositoryImpl());
  getIt.registerLazySingleton<ReminderRepository>(() => ReminderRepositoryImpl());
}