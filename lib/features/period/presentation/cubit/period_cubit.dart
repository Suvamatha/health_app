import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'period_state.dart';
import '../../domain/entities/period_entry.dart';
import '../../domain/repositories/period_repository.dart';
import '../../../../models/symptom.dart';

class PeriodCubit extends Cubit<PeriodState> {
  final PeriodRepository _repository;

  PeriodCubit(this._repository) : super(const PeriodState());

  Future<void> loadEntries() async {
    final entries = await _repository.getAllEntries();
    emit(state.copyWith(
      isLoading: false,
      entries: entries,
    ));
  }

  Future<void> logPeriodDay(DateTime date) async {
    final newEntry = PeriodEntry(
      id: const Uuid().v4(),
      date: date,
      symptoms: state.selectedSymptomIndexes.map((i) => Symptom.values[i]).toList(),
    );

    await _repository.addEntry(newEntry);
    await loadEntries();
  }

  Future<void> deleteEntry(String id) async {
    await _repository.removeEntry(id);
    await loadEntries();
  }

  void toggleSymptom(int index) {
    final current = Set<int>.from(state.selectedSymptomIndexes);
    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }
    emit(state.copyWith(selectedSymptomIndexes: current));
  }
}