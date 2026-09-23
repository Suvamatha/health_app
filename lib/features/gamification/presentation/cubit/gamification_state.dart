import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/gamification_profile.dart';

part 'gamification_state.freezed.dart';

@freezed 
class GamificationState with _$GamificationState{
  factory GamificationState({
    @Default(true) bool isLoading,
    GamificationProfile? profile,
  })= _GamificationState;
}