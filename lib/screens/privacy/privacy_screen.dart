import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/export/data_export_service.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/mood/presentation/cubit/mood_cubit.dart';
import '../../features/period/presentation/cubit/period_cubit.dart';
import '../../features/sleep/presentation/cubit/sleep_cubit.dart';
import '../../widgets/dashboard_card.dart';

/// Data export, pulled out of the old Settings screen, paired with a plain
/// -language note about what stays private -- this app keeps everything
/// on-device, so "privacy" is a genuinely reassuring story to tell here.
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _isExporting = false;

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
        const SnackBar(content: Text('Copied a readable summary — paste it anywhere to share.')),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            DashboardCard(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your data stays on this device', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(
                          'Cycle, mood, sleep, and hydration logs are stored locally and are never uploaded to a server or shared with anyone unless you choose to export and send them yourself.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('YOUR DATA', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            DashboardCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(Icons.ios_share_outlined, size: 18, color: theme.colorScheme.primary),
                ),
                title: Text('Export cycle & mood history', style: theme.textTheme.bodyLarge),
                subtitle: Text(
                  'Copies a readable summary to your clipboard to share with a doctor.',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: _isExporting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                onTap: _isExporting ? null : _exportData,
              ),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
