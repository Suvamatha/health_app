import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../core/notifications/hydration_reminder_prefs.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/dashboard_card.dart';

/// The dedicated home for every reminder in the app: the daily/interval
/// hydration nudge plus custom reminders, along with the two things that
/// actually determine whether a notification shows up on a real phone --
/// system permission status and battery-optimization exemption.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  HydrationReminderFrequency _frequency = HydrationReminderFrequency.onceDaily;

  bool? _systemNotificationsAllowed;
  bool? _batteryOptimizationIgnored;
  bool? _exactAlarmsAllowed;
  bool _isSendingTest = false;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    final saved = await HydrationReminderPrefs.load();
    final service = getIt<NotificationService>();
    final allowed = await service.areNotificationsEnabled();
    final batteryOk = await service.isIgnoringBatteryOptimizations();
    final exactOk = await service.canScheduleExactNotifications();
    if (!mounted) return;
    setState(() {
      _enabled = saved.enabled;
      _time = TimeOfDay(hour: saved.hour, minute: saved.minute);
      _frequency = saved.frequency;
      _systemNotificationsAllowed = allowed;
      _batteryOptimizationIgnored = batteryOk;
      _exactAlarmsAllowed = exactOk;
    });
  }

  Future<void> _persist() async {
    await HydrationReminderPrefs.save(
      HydrationReminderSettings(
        enabled: _enabled,
        hour: _time.hour,
        minute: _time.minute,
        frequency: _frequency,
      ),
    );
  }

  Future<void> _applySchedule() async {
    final service = getIt<NotificationService>();
    if (!_enabled) {
      await service.cancelAllHydrationReminders();
      return;
    }
    if (_frequency == HydrationReminderFrequency.onceDaily) {
      await service.scheduleDailyHydrationReminder(
        hour: _time.hour,
        minute: _time.minute,
      );
    } else {
      await service.scheduleIntervalHydrationReminders(_frequency);
    }
  }

  Future<void> _toggleEnabled(bool value) async {
    if (value) {
      final granted = await getIt<NotificationService>().requestPermission();
      final allowed = await getIt<NotificationService>()
          .areNotificationsEnabled();
      if (!mounted) return;
      setState(() => _systemNotificationsAllowed = allowed);
      if (!granted || !allowed) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notifications are blocked in system settings. Allow them first.',
            ),
          ),
        );
        return;
      }
    }
    setState(() => _enabled = value);
    await _applySchedule();
    await _persist();
  }

  Future<void> _changeFrequency(HydrationReminderFrequency frequency) async {
    setState(() => _frequency = frequency);
    if (_enabled) await _applySchedule();
    await _persist();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    setState(() => _time = picked);
    if (_enabled) await _applySchedule();
    await _persist();
  }

  Future<void> _sendTest() async {
    setState(() => _isSendingTest = true);
    try {
      await getIt<NotificationService>().showTestNotification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test sent — check your notification tray now.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSendingTest = false);
    }
  }

  Future<void> _fixBatteryOptimization() async {
    await getIt<NotificationService>().requestIgnoreBatteryOptimizations();
    final ok = await getIt<NotificationService>()
        .isIgnoringBatteryOptimizations();
    if (!mounted) return;
    setState(() => _batteryOptimizationIgnored = ok);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select "Unrestricted" or "Don\'t optimize" for Wellspring.',
          ),
        ),
      );
    }
  }

  Future<void> _fixExactAlarms() async {
    await getIt<NotificationService>().requestExactAlarmsPermission();
    final ok = await getIt<NotificationService>()
        .canScheduleExactNotifications();
    if (!mounted) return;
    setState(() => _exactAlarmsAllowed = ok);
  }

  Future<void> _openSystemSettings() async {
    await getIt<NotificationService>().openAppNotificationSettings();
  }

  String get _statusLabel {
    if (!_enabled) return 'Off';
    if (_frequency == HydrationReminderFrequency.onceDaily) {
      return 'On · once a day at ${_time.format(context)}';
    }
    return 'On · ${_frequency.label}, 8am–10pm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final systemBlocked = _systemNotificationsAllowed == false;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            if (systemBlocked)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DashboardCard(
                  backgroundColor: theme.colorScheme.errorContainer,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications are blocked',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your phone\'s system settings are blocking notifications for this app, so reminders can never show up no matter what is set below.',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: _openSystemSettings,
                              child: const Text('Open system settings'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Text('HYDRATION REMINDER', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            DashboardCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(
                            Icons.water_drop_outlined,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily hydration reminder',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _statusLabel,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Switch(value: _enabled, onChanged: _toggleEnabled),
                      ],
                    ),
                  ),
                  if (_enabled) ...[
                    Divider(height: 1, color: theme.colorScheme.outline),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'How often',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: HydrationReminderFrequency.values.map((
                          frequency,
                        ) {
                          final isSelected = _frequency == frequency;
                          return ChoiceChip(
                            label: Text(frequency.label),
                            selected: isSelected,
                            onSelected: (_) => _changeFrequency(frequency),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_frequency == HydrationReminderFrequency.onceDaily) ...[
                      Divider(height: 1, color: theme.colorScheme.outline),
                      ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                        leading: Icon(
                          Icons.access_time,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(
                          'Reminder time',
                          style: theme.textTheme.bodyLarge,
                        ),
                        trailing: Text(
                          _time.format(context),
                          style: theme.textTheme.labelLarge,
                        ),
                        onTap: _pickTime,
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Text(
                          'We spread these gently between 8am and 10pm so you\'re never woken up.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('TROUBLESHOOTING', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            DashboardCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    leading: Icon(
                      Icons.notifications_active_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      'Send a test notification',
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      'Confirms this device can show notifications right now.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: _isSendingTest
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                    onTap: _isSendingTest ? null : _sendTest,
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    leading: Icon(
                      Icons.battery_saver_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      'Allow background reminders',
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      _batteryOptimizationIgnored == true
                          ? 'Allowed — your phone won\'t pause reminders to save battery.'
                          : 'Some phones silently pause scheduled reminders to save battery. Turn this on so they keep arriving.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: _batteryOptimizationIgnored == true
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                    onTap: _fixBatteryOptimization,
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    leading: Icon(
                      Icons.alarm_on_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      'Exact reminder timing',
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      _exactAlarmsAllowed == true
                          ? 'Allowed — reminders will fire at the exact scheduled minute.'
                          : 'Tap to allow exact alarms so reminders don\'t get delayed by Android.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: _exactAlarmsAllowed == true
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                    onTap: _fixExactAlarms,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            DashboardCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
                leading: Icon(
                  Icons.alarm_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: Text('My reminders', style: theme.textTheme.bodyLarge),
                subtitle: Text(
                  'Create and edit medication or custom reminders.',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/reminders'),
              ),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
