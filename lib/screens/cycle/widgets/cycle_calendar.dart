import 'package:flutter/material.dart';

class CycleCalendar extends StatelessWidget {
  final Set<int> loggedDays;

  final Set<int> predictDays;

  const CycleCalendar({
    this.loggedDays = const {12, 13, 14, 15},
    this.predictDays = const {26, 27, 28, 29}
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const daysInMonth = 38;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;
        final isLogged = loggedDays.contains(day);
        final isPredicted = predictDays.contains(day);

        Color? bgColor;
        Color textColor = theme.colorScheme.onSurface;

        if(isLogged) {
          bgColor = theme.colorScheme.secondary;
          textColor = theme.colorScheme.surface;
        } else if (isPredicted) {
          bgColor = theme.colorScheme.secondary.withValues(alpha: 0.15);
          textColor = theme.colorScheme.secondary;
        }
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$day',
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        );
      },
    );
  }
}