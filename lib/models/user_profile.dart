import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed 
class UserProfile with _$UserProfile{
  const factory UserProfile({
    required String name,
    @Default(8) int dailyHydrationGoalGlasses,
    @Default(28) int averageCycleLengthDays,
    DateTime? lastPeriodStartDate,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
    _$UserProfileFromJson(json);
}