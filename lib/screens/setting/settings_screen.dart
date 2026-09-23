// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../core/notifications/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _remindersEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 10, minute: 0);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Daily hydration reminder'),
            subtitle: Text(_remindersEnabled ? 'On at ${_reminderTime.format(context)}' : 'Off'),
            value: _remindersEnabled,
            onChanged: _toggleReminders,
          ),
          if (_remindersEnabled)
            ListTile(
              title: const Text('Reminder time'),
              trailing: Text(_reminderTime.format(context)),
              onTap: _pickTime,
            ),
        ],
      ),
    );
  }
}