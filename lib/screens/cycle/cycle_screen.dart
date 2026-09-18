import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import 'widgets/cycle_calendar.dart';
import 'widgets/symptom_chip.dart';

class CycleScreen extends StatefulWidget {
  const CycleScreen({super.key});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  final Set<String> _selectedSymptoms = {};

  static const List<String> _availableSymptoms = [
    'Cramps',
    'Headache',
    'Fatigue',
    'Bloating',
    'Mood swings',
    'Backache',
  ];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Cycle', style: theme.textTheme.displayLarge),
            const SizedBox(height: 20),
            DashboardCard(child: const CycleCalendar()),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {}, // wired to real logging in Phase 6
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Log period day'),
              ),
            ),
            const SizedBox(height: 24),
            Text('How are you feeling today?', style: theme.textTheme.labelLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSymptoms.map((symptom) {
                return SymptomChip(
                  label: symptom,
                  isSelected: _selectedSymptoms.contains(symptom),
                  onTap: () => _toggleSymptom(symptom),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}