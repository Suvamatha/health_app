import 'package:flutter/material.dart';

class CycleCalendar extends StatelessWidget {
  final DateTime displayedMonth;
  final Set<int> loggedDays;
  final DateTimeRange? predictedRange;

  const CycleCalendar({
    super.key,
    required this.displayedMonth,
    this.loggedDays = const {},
    this.predictedRange,
  });

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = DateUtils.getDaysInMonth(displayedMonth.year, displayedMonth.month);
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    // DateTime.weekday: Monday = 1 ... Sunday = 7. The grid starts on Monday.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final now = DateTime.now();
    final isCurrentMonth = now.year == displayedMonth.year && now.month == displayedMonth.month;

    bool isPredicted(DateTime day) {
      final range = predictedRange;
      if (range == null) return false;
      final start = DateTime(range.start.year, range.start.month, range.start.day);
      final end = DateTime(range.end.year, range.end.month, range.end.day);
      return !day.isBefore(start) && !day.isAfter(end);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: _weekdayLabels
              .map((label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();

            final day = index - leadingBlanks + 1;
            final date = DateTime(displayedMonth.year, displayedMonth.month, day);
            final isLogged = loggedDays.contains(day);
            final predicted = !isLogged && isPredicted(date);
            final isToday = isCurrentMonth && day == now.day;

            Color? bgColor;
            Gradient? gradient;
            Color textColor = theme.colorScheme.onSurface.withValues(alpha: 0.75);

            if (isLogged) {
              gradient = LinearGradient(
                colors: [theme.colorScheme.secondary, theme.colorScheme.secondary.withValues(alpha: 0.75)],
              );
              textColor = Colors.white;
            } else if (predicted) {
              bgColor = theme.colorScheme.secondary.withValues(alpha: 0.14);
              textColor = theme.colorScheme.secondary;
            }

            return AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  gradient: gradient,
                  shape: BoxShape.circle,
                  border: isToday && !isLogged
                      ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                      : null,
                ),
                child: Text(
                  '$day',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
