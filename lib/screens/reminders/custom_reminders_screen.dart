import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/dashboard_card.dart';
import '../setting/widgets/reminders_section.dart';

/// A dedicated, easy-to-find home for user-created daily reminders.
class CustomRemindersScreen extends StatelessWidget {
  const CustomRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My reminders')),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            DashboardCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.alarm_on_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Create reminders for medication, self-care, or anything else. Each enabled reminder is delivered at its selected time.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await getIt<NotificationService>().scheduleCustomReminderTest();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Custom reminder test is scheduled for 5 seconds from now.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.schedule_outlined),
              label: const Text('Test scheduled custom reminder'),
            ),
            const SizedBox(height: 20),
            const RemindersSection(),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
