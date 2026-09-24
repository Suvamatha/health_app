import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// How often the hydration reminder should repeat.
enum HydrationReminderFrequency {
  onceDaily,
  every30Min,
  everyHour,
  every2Hours,
  every3Hours,
}

extension HydrationReminderFrequencyX on HydrationReminderFrequency {
  String get label {
    switch (this) {
      case HydrationReminderFrequency.onceDaily:
        return 'Once a day';
      case HydrationReminderFrequency.every30Min:
        return 'Every 30 min';
      case HydrationReminderFrequency.everyHour:
        return 'Every hour';
      case HydrationReminderFrequency.every2Hours:
        return 'Every 2 hours';
      case HydrationReminderFrequency.every3Hours:
        return 'Every 3 hours';
    }
  }

  /// Minutes between reminders, or null for the once-a-day mode.
  int? get intervalMinutes {
    switch (this) {
      case HydrationReminderFrequency.onceDaily:
        return null;
      case HydrationReminderFrequency.every30Min:
        return 30;
      case HydrationReminderFrequency.everyHour:
        return 60;
      case HydrationReminderFrequency.every2Hours:
        return 120;
      case HydrationReminderFrequency.every3Hours:
        return 180;
    }
  }
}

/// Wraps flutter_local_notifications with the extra plumbing real devices
/// need: explicit high-importance channels, exact-alarm + battery-
/// optimization handling, and a test-fire button, because "permission
/// granted" alone does not guarantee delivery on many Android phones.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyHydrationId = 1;
  static const int _hydrationSlotIdStart = 100;
  static const int _hydrationSlotIdEnd = 179;

  // Waking window used to spread interval-based hydration reminders across
  // the day instead of pinging overnight.
  static const int windowStartHour = 8;
  static const int windowEndHour = 22;

  static const AndroidNotificationDetails _hydrationAndroidDetails =
      AndroidNotificationDetails(
    'hydration_channel',
    'Hydration Reminders',
    channelDescription: 'Gentle reminders to drink water',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const AndroidNotificationDetails _customAndroidDetails =
      AndroidNotificationDetails(
    'custom_reminders_channel',
    'Reminders',
    channelDescription: 'Your custom reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } catch (_) {
      // Fall back to whatever default timezone package already has.
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _plugin.initialize(settings);

    // Explicitly create both channels at MAX importance up front. If a
    // channel is ever lazily auto-created at a lower importance (which can
    // happen depending on OS/plugin version), Android locks that channel's
    // importance permanently on the device -- no future call can raise it,
    // which silently makes every future notification on that channel
    // invisible or silent. Creating it correctly here avoids that trap,
    // which is one of the most common real-world reasons a correctly
    // scheduled notification "never arrives" on Android.
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'hydration_channel',
        'Hydration Reminders',
        description: 'Gentle reminders to drink water',
        importance: Importance.max,
        playSound: true,
      ),
    );
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'custom_reminders_channel',
        'Reminders',
        description: 'Your custom reminders',
        importance: Importance.max,
        playSound: true,
      ),
    );

    await requestPermission();
  }

  Future<bool> requestPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return true;
    final notificationsGranted =
        await androidPlugin.requestNotificationsPermission() ?? true;
    final exactAlarmGranted =
        await androidPlugin.requestExactAlarmsPermission() ?? true;
    return notificationsGranted && exactAlarmGranted;
  }

  /// Checks whether notifications are currently allowed at the OS level, so
  /// the UI can show a clear "blocked in system settings" state instead of a
  /// toggle that looks "on" while nothing can ever be delivered.
  Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.areNotificationsEnabled() ?? true;
  }

  /// Opens the OS notification settings page for this app.
  Future<void> openAppNotificationSettings() async {
    await ph.openAppSettings();
  }

  /// Many Android phones (especially aggressive-battery-saver brands like
  /// Xiaomi, Vivo, Oppo, OnePlus, and some Samsung models) silently kill
  /// scheduled notifications and background alarms unless the app is
  /// exempted from battery optimization. This is one of the most common
  /// real-world reasons a correctly scheduled reminder simply never shows
  /// up, even with every permission granted. Not needed on iOS.
  Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    final status = await ph.Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    return await ph.Permission.ignoreBatteryOptimizations.status.isGranted;
  }

  /// Fires an immediate notification so the user can confirm this device
  /// can display notifications at all, isolating "permission/channel"
  /// problems from "scheduling/timing" problems.
  Future<void> showTestNotification() async {
    await _plugin.show(
      999,
      'Test notification',
      'If you can see this, notifications work on this device.',
      const NotificationDetails(
        android: _hydrationAndroidDetails,
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<AndroidScheduleMode> _scheduleMode() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final canScheduleExact =
        await androidPlugin?.canScheduleExactNotifications() ?? true;
    return canScheduleExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// Cancels every hydration notification (the legacy single daily slot and
  /// all interval slots) so switching frequency never leaves stale
  /// duplicate reminders behind.
  Future<void> cancelAllHydrationReminders() async {
    await _plugin.cancel(_dailyHydrationId);
    for (var id = _hydrationSlotIdStart; id <= _hydrationSlotIdEnd; id++) {
      await _plugin.cancel(id);
    }
  }

  Future<void> cancelHydrationReminder() => cancelAllHydrationReminders();

  Future<void> scheduleDailyHydrationReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelAllHydrationReminders();
    await _scheduleHydrationSlot(_dailyHydrationId, hour, minute);
  }

  /// Schedules repeating hydration reminders every [frequency]'s interval,
  /// spread across a sensible waking window (8am-10pm by default) instead
  /// of waking the user up at 3am. Each slot is its own daily-repeating
  /// notification (matchDateTimeComponents: time), which is far more
  /// reliable across Android/iOS than the plugin's periodic-show APIs.
  Future<void> scheduleIntervalHydrationReminders(
    HydrationReminderFrequency frequency,
  ) async {
    final intervalMinutes = frequency.intervalMinutes;
    await cancelAllHydrationReminders();
    if (intervalMinutes == null) return;

    var id = _hydrationSlotIdStart;
    final windowStart = windowStartHour * 60;
    final windowEnd = windowEndHour * 60;
    for (var minutesFromMidnight = windowStart;
        minutesFromMidnight <= windowEnd;
        minutesFromMidnight += intervalMinutes) {
      if (id > _hydrationSlotIdEnd) break; // safety cap
      final hour = minutesFromMidnight ~/ 60;
      final minute = minutesFromMidnight % 60;
      await _scheduleHydrationSlot(id, hour, minute);
      id++;
    }
  }

  Future<void> _scheduleHydrationSlot(int id, int hour, int minute) async {
    await _plugin.zonedSchedule(
      id,
      'Time for some water',
      'A little hydration check-in - no pressure, just a gentle nudge.',
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: _hydrationAndroidDetails,
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: await _scheduleMode(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: _customAndroidDetails,
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: await _scheduleMode(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder(int id) => _plugin.cancel(id);

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
