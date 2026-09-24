import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/core/notifications/hydration_reminder_prefs.dart';
import '../../core/di/injection.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/export/data_export_service.dart';
import '../../features/mood/presentation/cubit/mood_cubit.dart';
import '../../features/period/presentation/cubit/period_cubit.dart';
import '../../features/sleep/presentation/cubit/sleep_cubit.dart';
import '../../widgets/dashboard_card.dart';
import 'widgets/reminders_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
void initState() {
  super.initState();
  _loadSavedReminderPrefs();
}

Future<void> _loadSavedReminderPrefs() async {
  final saved = await HydrationReminderPrefs.load();
  if (!mounted) return;
  setState(() {
    _remindersEnabled = saved.enabled;
    _reminderTime = TimeOfDay(hour: saved.hour, minute: saved.minute);
  });
}

  bool _remindersEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isExporting = false;

  Future<void> _toggleReminders(bool enabled) async {
    final service = getIt<NotificationService>();

    if (enabled) {
      final granted = await service.requestPermission();
      if (!granted) return; // permission denied — don't flip the switch on
      await service.scheduleDailyHydrationReminder(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
      );
    } else {
      await service.cancelHydrationReminder();
    }

    setState(() => _remindersEnabled = enabled);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _reminderTime);
    if (picked != null) {
      setState(() => _reminderTime = picked);
      if (_remindersEnabled) {
        await getIt<NotificationService>().scheduleDailyHydrationReminder(
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }

  Future<void> _exportData() async {
    setState(() => _isExporting = true);
    try {
      final periodEntries = context.read<PeriodCubit>().state.entries;
      final moodEntries = await context.read<MoodCubit>().getAllEntries();
      final sleepEntries = await context.read<SleepCubit>().getAllEntries();

      await DataExportService().copyReportToClipboard(
        periodEntries: periodEntries,
        moodEntries: moodEntries,
        sleepEntries: sleepEntries,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied your history as CSV — paste it anywhere to share.')),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  String _modeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  IconData _modeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            Text('APPEARANCE', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return DashboardCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: ThemeMode.values.map((option) {
                      final isSelected = mode == option;
                      return Column(
                        children: [
                          if (option != ThemeMode.values.first)
                            Divider(height: 1, color: theme.colorScheme.outline),
                          ListTile(
                            contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            leading: Icon(
                              _modeIcon(option),
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            title: Text(_modeLabel(option), style: theme.textTheme.bodyLarge),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                                : null,
                            onTap: () => context.read<ThemeCubit>().setThemeMode(option),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Text('NOTIFICATIONS', style: theme.textTheme.labelMedium),
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
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(Icons.water_drop_outlined, size: 18, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Daily hydration reminder', style: theme.textTheme.bodyLarge),
                              const SizedBox(height: 2),
                              Text(
                                _remindersEnabled ? 'On at ${_reminderTime.format(context)}' : 'Off',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Switch(value: _remindersEnabled, onChanged: _toggleReminders),
                      ],
                    ),
                  ),
                  if (_remindersEnabled) ...[
                    Divider(height: 1, color: theme.colorScheme.outline),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      leading: Icon(Icons.access_time, color: theme.colorScheme.primary),
                      title: Text('Reminder time', style: theme.textTheme.bodyLarge),
                      trailing: Text(_reminderTime.format(context), style: theme.textTheme.labelLarge),
                      onTap: _pickTime,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            const RemindersSection(),
            const SizedBox(height: 28),
            Text('DATA', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            DashboardCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                leading: Icon(Icons.ios_share_outlined, color: theme.colorScheme.primary),
                title: Text('Export cycle & mood history', style: theme.textTheme.bodyLarge),
                subtitle: Text('Copies a CSV to your clipboard to share with a doctor.', style: theme.textTheme.bodyMedium),
                trailing: _isExporting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                onTap: _isExporting ? null : _exportData,
              ),
            ),
            const SizedBox(height: 28),
            Text('ABOUT', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            DashboardCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                leading: Icon(Icons.spa_outlined, color: theme.colorScheme.primary),
                title: Text('Wellspring', style: theme.textTheme.bodyLarge),
                trailing: Text('v1.1.0', style: theme.textTheme.bodyMedium),
              ),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
