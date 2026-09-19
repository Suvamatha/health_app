import 'package:flutter/material.dart';

class CycleCalendar extends StatelessWidget {
  final Set<int> loggedDays;

  final Set<int> predictedDays;

  const CycleCalendar({
    super.key,
    this.loggedDays = const {12, 13, 14, 15},
    this.predictedDays = const {26, 27, 28, 29},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const daysInMonth = 30;
    const crossAxisCount = 7;
    const spacing = 6.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final day = index + 1;
            final isLogged = loggedDays.contains(day);
            final isPredicted = predictedDays.contains(day);

            Color? bgColor;
            Color textColor = theme.colorScheme.onSurface;

            if (isLogged) {
              bgColor = theme.colorScheme.secondary;
              textColor = theme.colorScheme.surface;
            } else if (isPredicted) {
              bgColor = theme.colorScheme.secondary.withValues(alpha: 0.15);
              textColor = theme.colorScheme.secondary;
            }

            return AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                ),
              ),
            );
          },
        );
      },
    );
  }
}