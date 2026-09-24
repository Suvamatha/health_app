import 'package:flutter/material.dart';

class DateStrip extends StatefulWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateStrip({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Dates are ordered oldest -> newest (today is the last / rightmost
    // item). Jump to the end on first frame so today is visible without
    // the user needing to scroll right first; they can then scroll left
    // to look back at earlier days.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void _scrollToEnd() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = widget.dates;
    final selectedDate = widget.selectedDate;

    return SizedBox(
      height: 76,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                      )
                    : null,
                color: isSelected ? null : theme.colorScheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayLabels[date.weekday - 1],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.85)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
