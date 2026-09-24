// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/dashboard_card.dart';

/// A short directory into the more focused screens (Appearance,
/// Notifications, Privacy & Security) that used to all be crammed onto
/// this one dense page. Kept as its own route since the dashboard's gear
/// icon still points here, but the same three destinations are also
/// reachable from the Profile screen.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            DashboardCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                    subtitle: 'Light, dark, or system theme',
                    onTap: () => context.push('/appearance'),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  _SettingsRow(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Hydration & custom reminders',
                    onTap: () => context.push('/notifications'),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  _SettingsRow(
                    icon: Icons.lock_outline,
                    title: 'Privacy & Security',
                    subtitle: 'Export your data & what stays private',
                    onTap: () => context.push('/privacy'),
                  ),
                ],
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
                trailing: Text('v1.3.0', style: theme.textTheme.bodyMedium),
              ),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
      onTap: onTap,
    );
  }
}
