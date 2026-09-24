import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/hydration_entry.dart';
import '../../domain/repositories/hydration_repository.dart';
import 'hydration_state.dart';

class HydrationCubit extends Cubit<HydrationState> {
  final HydrationRepository _repository;

  HydrationCubit(this._repository) : super(const HydrationState());

  Future<void> loadTodayEntries() async {
    final entries = await _repository.getTodayEntries();
    final goal = await _repository.getDailyGoal();
    emit(state.copyWith(
      isLoading: false,
      glassesLoggedToday: entries.length,
      dailyGoal: goal,
    ));
  }

  Future<void> addGlass() async {
    final newEntry = HydrationEntry(
      id: const Uuid().v4(),
      loggedAt: DateTime.now(),
    );

    await _repository.addEntry(newEntry);
    await loadTodayEntries();
  }

  Future<int> getGlassesCountForDate(DateTime date) async {
    final entries = await _repository.getEntriesForDate(date);
    return entries.length;
  }

  Future<void> setDailyGoal(int goal) async {
    await _repository.setDailyGoal(goal);
    emit(state.copyWith(dailyGoal: goal));
  }
}