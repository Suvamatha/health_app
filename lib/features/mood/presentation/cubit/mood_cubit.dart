import 'package:bloc/bloc.dart';
import 'mood_state.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';
import 'package:uuid/uuid.dart';

class MoodCubit extends Cubit<MoodState>{
  final MoodRepository _repository;

  MoodCubit(this._repository) : super(const MoodState());

  Future<void> loadTodayEntry () async {
    final entry = await _repository.getTodayEntry();
    emit(state.copyWith(
      isLoading:  false,
      selectedMoodLevel: entry?.moodLevel,
    ));
  }

  Future<void> selectMood (int level) async {
    final entry = MoodEntry(
      id: Uuid().v4(),
      loggedAt: DateTime.now(),
      moodLevel: level,
    );
    await _repository.saveTodayEntry(entry);
    await loadTodayEntry();
  }
}