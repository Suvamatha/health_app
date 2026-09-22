// lib/features/period/presentation/cycle_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../widgets/dashboard_card.dart';
import '../../../models/symptom.dart';
import 'cubit/period_cubit.dart';
import 'cubit/period_state.dart';
import 'widgets/cycle_calendar.dart';
import 'widgets/symptom_chip.dart';

class CycleScreen extends StatelessWidget {
  const CycleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PeriodCubit, PeriodState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final now = DateTime.now();
            final loggedDays = state.entries
                .where((entry) =>
                    entry.date.year == now.year && entry.date.month == now.month)
                .map((entry) => entry.date.day)
                .toSet();

            return ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                Text('Cycle', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 20),
                DashboardCard(
                  child: CycleCalendar(loggedDays: loggedDays, predictedDays: const {}),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.read<PeriodCubit>().logPeriodDay(now),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Log period day'),
                  ),
                ),
                const SizedBox(height: 24),
                Text('How are you feeling today?', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(Symptom.values.length, (index) {
                    final symptom = Symptom.values[index];
                    return SymptomChip(
                      label: symptom.label,
                      isSelected: state.selectedSymptomIndexes.contains(index),
                      onTap: () => context.read<PeriodCubit>().toggleSymptom(index),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}