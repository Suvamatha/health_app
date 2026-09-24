import 'package:shared_preferences/shared_preferences.dart';

class HydrationReminderPrefs {
  static const _enabledKey = 'hydration_reminder_enabled';
  static const _hourKey = 'hydration_reminder_hour';
  static const _minuteKey = 'hydration_reminder_minute';

  static Future<HydrationReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return HydrationReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey) ?? 10,
      minute: prefs.getInt(_minuteKey) ?? 0,
    );
  }

  static Future<void> save({required bool enabled, required int hour, required int minute}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
  }
}

class HydrationReminderSettings {
  final bool enabled;
  final int hour;
  final int minute;
  const HydrationReminderSettings({required this.enabled, required this.hour, required this.minute});
}