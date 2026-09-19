import 'package:flutter/material.dart';
import 'package:healthtracker/core/theme/app_spacing.dart';
import 'package:healthtracker/screens/history/widgets/data_strip.dart';
import '../../widgets/dashboard_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _recentDates;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    // Last 14 days, oldest first, so the strip reads left-to-right as
    // past → today (today ends up as the last, rightmost item).
    _recentDates = List.generate(
      14,
      (index) => today.subtract(Duration(days: 13 - index)),
    );
    _selectedDate = today;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            Text('History', style: theme.textTheme.displayLarge),
            const SizedBox(height: 20),
            DateStrip(
              dates: _recentDates,
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
            const SizedBox(height: 24),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            // Dummy summary — placeholder values, not tied to _selectedDate yet
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HistoryRow(icon: Icons.water_drop_outlined, label: 'Hydration', value: '6/8 glasses'),
                  const SizedBox(height: 12),
                  _HistoryRow(icon: Icons.favorite_outline, label: 'Mood', value: 'Good'),
                  const SizedBox(height: 12),
                  _HistoryRow(icon: Icons.calendar_today_outlined, label: 'Cycle', value: 'Day 14 — Ovulation'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single icon + label + value row inside the summary card.
/// Private to this file (underscore prefix) since it's not reused elsewhere.
class _HistoryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HistoryRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}