import 'package:freezed_annotation/freezed_annotation.dart';

part 'mood_state.freezed.dart';

@freezed
class MoodState with _$MoodState{
  const factory MoodState({
    @Default(true) bool isLoading,
    int? selectedMoodLevel,
  }) = _MoodState;
}