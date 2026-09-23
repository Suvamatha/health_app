// lib/screens/history/history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthtracker/screens/history/widgets/data_strip.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/dashboard_card.dart';
import '../../features/hydration/presentation/cubit/hydration_cubit.dart';
import '../../features/mood/presentation/cubit/mood_cubit.dart';
import '../../features/mood/domain/entities/mood_entry.dart';
import '../../features/period/presentation/cubit/period_cubit.dart';
import '../../features/period/presentation/cubit/period_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _recentDates;
  Future<int>? _hydrationFuture;
  Future<MoodEntry?>? _moodFuture;

  static const int _dailyGoal = 8; 

  static const List<String> _moodLabels = ['Low', 'Okay', 'Good', 'Great'];

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _recentDates = List.generate(14, (index) => today.subtract(Duration(days: 13 - index)));
    _selectedDate = today;
    _loadDataForSelectedDate();
  }

  void _loadDataForSelectedDate() {
    setState(() {
      _hydrationFuture = context.read<HydrationCubit>().getGlassesCountForDate(_selectedDate);
      _moodFuture = context.read<MoodCubit>().getMoodForDate(_selectedDate);
    });
  }

  void _onDateSelected(DateTime date) {
    _selectedDate = date;
    _loadDataForSelectedDate();
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
              onDateSelected: _onDateSelected,
            ),
            const SizedBox(height: 24),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<int>(
                    future: _hydrationFuture,
                    builder: (context, snapshot) {
                      final value = snapshot.hasData
                          ? '${snapshot.data}/$_dailyGoal glasses'
                          : '...';
                      return _HistoryRow(
                        icon: Icons.water_drop_outlined,
                        label: 'Hydration',
                        value: value,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<MoodEntry?>(
                    future: _moodFuture,
                    builder: (context, snapshot) {
                      String value = '...';
                      if (snapshot.connectionState == ConnectionState.done) {
                        final entry = snapshot.data;
                        value = entry == null
                            ? 'Not logged'
                            : _moodLabels[entry.moodLevel - 1];
                      }
                      return _HistoryRow(icon: Icons.favorite_outline, label: 'Mood', value: value);
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<PeriodCubit, PeriodState>(
                    builder: (context, state) {
                      final loggedToday = state.entries
                          .any((entry) => _isSameDay(entry.date, _selectedDate));
                      return _HistoryRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Cycle',
                        value: loggedToday ? 'Period day logged' : 'No entry',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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