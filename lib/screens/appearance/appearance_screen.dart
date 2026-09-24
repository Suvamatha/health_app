import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/theme_cubit.dart';
import '../../widgets/dashboard_card.dart';

/// Just the theme picker, pulled out of the old do-everything Settings
/// screen so it has its own clear, breathable home.
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

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

  String _modeSubtitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Match your device setting';
      case ThemeMode.light:
        return 'Bright & airy';
      case ThemeMode.dark:
        return 'Easy on the eyes at night';
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
      appBar: AppBar(title: const Text('Appearance')),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            Text('THEME', style: theme.textTheme.labelMedium),
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
                            subtitle: Text(_modeSubtitle(option), style: theme.textTheme.bodyMedium),
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
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
