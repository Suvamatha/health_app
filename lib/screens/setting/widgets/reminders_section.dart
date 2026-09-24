import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_radius.dart';
import '../../../widgets/dashboard_card.dart';
import '../../../features/reminders/domain/reminder.dart';
import '../../../features/reminders/presentation/cubit/reminders_cubit.dart';
import '../../../features/reminders/presentation/cubit/reminders_state.dart';

/// Lets users add gentle reminders beyond the built-in hydration one --
/// meds/vitamins, period prep, or mood check-ins -- each independently
/// schedulable and removable.
class RemindersSection extends StatelessWidget {
  const RemindersSection({super.key});

  Future<void> _showReminderSheet(
    BuildContext context, {
    Reminder? existing,
  }) async {
    final cubit = context.read<RemindersCubit>();
    final labelController = TextEditingController(text: existing?.label ?? '');
    ReminderType selectedType = existing?.type ?? ReminderType.medication;
    TimeOfDay selectedTime = existing == null
        ? TimeOfDay.now()
        : TimeOfDay(hour: existing.hour, minute: existing.minute);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (sheetContext, setSheetState) {
              final theme = Theme.of(sheetContext);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existing == null ? 'New reminder' : 'Edit reminder',
                    style: theme.textTheme.displayLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: labelController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Take vitamins',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ReminderType.values.map((type) {
                      final isSelected = selectedType == type;
                      return ChoiceChip(
                        label: Text(type.label),
                        selected: isSelected,
                        onSelected: (_) =>
                            setSheetState(() => selectedType = type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.access_time,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('Time (check AM/PM)'),
                    trailing: Text(
                      selectedTime.format(sheetContext),
                      style: theme.textTheme.labelLarge,
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: sheetContext,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setSheetState(() => selectedTime = picked);
                      }
                    },
                  ),
                  Text(
                    'Choose AM or PM in the time picker. A time that has already passed today will be scheduled for tomorrow.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final label = labelController.text.trim().isEmpty
                            ? selectedType.label
                            : labelController.text.trim();
                        try {
                          if (existing == null) {
                            await cubit.addReminder(
                              label: label,
                              type: selectedType,
                              hour: selectedTime.hour,
                              minute: selectedTime.minute,
                            );
                          } else {
                            await cubit.updateReminder(
                              existing.copyWith(
                                label: label,
                                type: selectedType,
                                hour: selectedTime.hour,
                                minute: selectedTime.minute,
                              ),
                            );
                          }
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Reminder scheduled for ${_nextOccurrenceLabel(context, selectedTime)}.',
                                ),
                              ),
                            );
                          }
                        } catch (_) {
                          if (!sheetContext.mounted) return;
                          ScaffoldMessenger.of(sheetContext).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Could not schedule this reminder. Enable notifications and try again.',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        existing == null ? 'Add reminder' : 'Save changes',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showAddReminderSheet(BuildContext context) =>
      _showReminderSheet(context);

  String _nextOccurrenceLabel(BuildContext context, TimeOfDay time) {
    final now = DateTime.now();
    final selectedToday = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (now.difference(selectedToday) < const Duration(minutes: 1) &&
        selectedToday.isBefore(now)) {
      return 'a few seconds from now';
    }
    final day = selectedToday.isAfter(now) ? 'today' : 'tomorrow';
    return '$day at ${time.format(context)}';
  }

  IconData _iconFor(ReminderType type) {
    switch (type) {
      case ReminderType.medication:
        return Icons.medication_outlined;
      case ReminderType.periodPrep:
        return Icons.calendar_today_outlined;
      case ReminderType.moodCheckIn:
        return Icons.favorite_outline;
      case ReminderType.custom:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<RemindersCubit, RemindersState>(
      builder: (context, state) {
        return DashboardCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Custom reminders',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddReminderSheet(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ),
              if (state.reminders.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Set gentle nudges for meds, vitamins, period prep, or mood check-ins.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ...state.reminders.map((reminder) {
                return Column(
                  children: [
                    Divider(height: 1, color: theme.colorScheme.outline),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                      child: Row(
                        children: [
                          Icon(
                            _iconFor(reminder.type),
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              onTap: () => _showReminderSheet(
                                context,
                                existing: reminder,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reminder.label,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      '${TimeOfDay(hour: reminder.hour, minute: reminder.minute).format(context)} · Tap to edit',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            value: reminder.isEnabled,
                            onChanged: (value) => context
                                .read<RemindersCubit>()
                                .toggleReminder(reminder.id, value),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                              size: 20,
                            ),
                            onPressed: () => context
                                .read<RemindersCubit>()
                                .deleteReminder(reminder.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
