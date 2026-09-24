import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

/// Persisted hydration reminder settings: whether it's on, which frequency
/// mode is selected, and the once-a-day time (used only in that mode).
class HydrationReminderSettings {
  final bool enabled;
  final int hour;
  final int minute;
  final HydrationReminderFrequency frequency;

  const HydrationReminderSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
    required this.frequency,
  });

  HydrationReminderSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    HydrationReminderFrequency? frequency,
  }) {
    return HydrationReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      frequency: frequency ?? this.frequency,
    );
  }
}

class HydrationReminderPrefs {
  static const _enabledKey = 'hydration_reminder_enabled';
  static const _hourKey = 'hydration_reminder_hour';
  static const _minuteKey = 'hydration_reminder_minute';
  static const _frequencyKey = 'hydration_reminder_frequency';

  static Future<HydrationReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final frequencyName = prefs.getString(_frequencyKey);
    final frequency = HydrationReminderFrequency.values.firstWhere(
      (f) => f.name == frequencyName,
      orElse: () => HydrationReminderFrequency.onceDaily,
    );
    return HydrationReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey) ?? 10,
      minute: prefs.getInt(_minuteKey) ?? 0,
      frequency: frequency,
    );
  }

  static Future<void> save(HydrationReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, settings.enabled);
    await prefs.setInt(_hourKey, settings.hour);
    await prefs.setInt(_minuteKey, settings.minute);
    await prefs.setString(_frequencyKey, settings.frequency.name);
  }
}
