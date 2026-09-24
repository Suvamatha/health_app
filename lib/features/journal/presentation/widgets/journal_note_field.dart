import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/dashboard_card.dart';
import '../cubit/journal_cubit.dart';
import '../cubit/journal_state.dart';

/// A free-text reflection box tied to whichever date the History screen
/// currently has selected. Saves automatically (debounced) as the user
/// types, so there's no separate "save" step to remember.
class JournalNoteField extends StatefulWidget {
  final DateTime date;

  const JournalNoteField({super.key, required this.date});

  @override
  State<JournalNoteField> createState() => _JournalNoteFieldState();
}

class _JournalNoteFieldState extends State<JournalNoteField> {
  late final TextEditingController _controller;
  Timer? _debounce;
  DateTime? _loadedForDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadForDate();
  }

  @override
  void didUpdateWidget(JournalNoteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(oldWidget.date, widget.date)) {
      _loadForDate();
    }
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _loadForDate() async {
    _loadedForDate = widget.date;
    await context.read<JournalCubit>().loadEntryForDate(widget.date);
    if (!mounted) return;
    final state = context.read<JournalCubit>().state;
    _controller.text = state.text;
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_loadedForDate != null && _isSameDay(_loadedForDate!, widget.date)) {
        context.read<JournalCubit>().saveEntry(value);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<JournalCubit, JournalState>(
      builder: (context, state) {
        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_note_outlined, color: theme.colorScheme.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text('Journal', style: theme.textTheme.labelLarge),
                  const Spacer(),
                  if (state.isSaving)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                maxLines: 4,
                minLines: 3,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'How was today? Jot down anything worth remembering...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  contentPadding: const EdgeInsets.all(14),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
