import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_state.freezed.dart';

@freezed 
class HydrationState with _$HydrationState {
  const factory HydrationState({
    @Default(true) bool isLoading,
    @Default(0) int glassesLoggedToday,
    @Default(8) int dailyGoal,
  }) = _HydrationState;
}