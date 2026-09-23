// lib/features/gamification/domain/entities/gamification_profile.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_profile.freezed.dart';
part 'gamification_profile.g.dart';

/// Tracks the user's overall engagement progress. Unlike HydrationEntry/
/// MoodEntry/PeriodEntry (one row per event), this is a SINGLE evolving
/// record — there's only ever one GamificationProfile, updated in place,
/// not a growing list of entries.
@freezed
class GamificationProfile with _$GamificationProfile {
  const factory GamificationProfile({
    @Default(0) int totalXp,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastCheckInDate,
  }) = _GamificationProfile;

  factory GamificationProfile.fromJson(Map<String, dynamic> json) =>
      _$GamificationProfileFromJson(json);
}