import 'package:flutter/material.dart';

/// Dot progress indicator for onboarding — the active dot stretches into a
/// soft gradient pill so progress reads as motion, not just static dots.
class PageInicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageInicator({
    required this.count,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                  )
                : null,
            color: isActive ? null : theme.colorScheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
