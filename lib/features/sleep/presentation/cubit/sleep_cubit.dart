import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/sleep_entry.dart';
import '../../domain/sleep_repository.dart';
import 'sleep_state.dart';

class SleepCubit extends Cubit<SleepState> {
  final SleepRepository _repository;

  SleepCubit(this._repository) : super(const SleepState());

  Future<void> loadTodayEntry() async {
    final entry = await _repository.getEntryForDate(DateTime.now());
    emit(state.copyWith(isLoading: false, hoursLogged: entry?.hours, quality: entry?.quality));
  }

  Future<void> logSleep({required double hours, required SleepQuality quality}) async {
    final entry = SleepEntry(
      id: const Uuid().v4(),
      loggedAt: DateTime.now(),
      hours: hours,
      quality: quality,
    );
    await _repository.saveEntry(entry);
    await loadTodayEntry();
  }

  Future<SleepEntry?> getEntryForDate(DateTime date) async {
    return _repository.getEntryForDate(date);
  }

  Future<List<SleepEntry>> getAllEntries() async {
    return _repository.getAllEntries();
  }
}
