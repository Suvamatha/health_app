import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/journal_entry.dart';
import '../../domain/journal_repository.dart';
import 'journal_state.dart';

/// Manages the journal entry for a single selected date at a time. The
/// History screen owns which date is selected and re-loads on change.
class JournalCubit extends Cubit<JournalState> {
  final JournalRepository _repository;
  DateTime _selectedDate = DateTime.now();

  JournalCubit(this._repository) : super(const JournalState());

  Future<void> loadEntryForDate(DateTime date) async {
    _selectedDate = date;
    emit(state.copyWith(isLoading: true));
    final entry = await _repository.getEntryForDate(date);
    emit(state.copyWith(isLoading: false, text: entry?.text ?? ''));
  }

  Future<void> saveEntry(String text) async {
    emit(state.copyWith(isSaving: true, text: text));
    if (text.trim().isEmpty) {
      await _repository.deleteEntryForDate(_selectedDate);
    } else {
      final existing = await _repository.getEntryForDate(_selectedDate);
      final entry = JournalEntry(
        id: existing?.id ?? const Uuid().v4(),
        date: _selectedDate,
        text: text,
        updatedAt: DateTime.now(),
      );
      await _repository.saveEntry(entry);
    }
    emit(state.copyWith(isSaving: false, text: text));
  }

  Future<List<JournalEntry>> getAllEntries() async {
    return _repository.getAllEntries();
  }
}
