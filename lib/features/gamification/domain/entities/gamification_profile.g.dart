// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamificationProfileImpl _$$GamificationProfileImplFromJson(
  Map<String, dynamic> json,
) => _$GamificationProfileImpl(
  totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  lastCheckInDate: json['lastCheckInDate'] == null
      ? null
      : DateTime.parse(json['lastCheckInDate'] as String),
);

Map<String, dynamic> _$$GamificationProfileImplToJson(
  _$GamificationProfileImpl instance,
) => <String, dynamic>{
  'totalXp': instance.totalXp,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'lastCheckInDate': instance.lastCheckInDate?.toIso8601String(),
};
