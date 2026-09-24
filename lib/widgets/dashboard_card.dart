import 'package:flutter/material.dart';
import '../core/theme/app_radius.dart';

/// The single shared "elevated surface" for the app — every stat, prompt,
/// and summary lives inside one of these so the whole product reads as one
/// consistent system rather than a pile of ad-hoc containers.
class DashboardCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final Border? border;

  const DashboardCard({
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(20),
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: border,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : theme.colorScheme.primary)
                .withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
