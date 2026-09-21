// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      name: json['name'] as String,
      dailyHydrationGoalGlasses:
          (json['dailyHydrationGoalGlasses'] as num?)?.toInt() ?? 8,
      averageCycleLengthDays:
          (json['averageCycleLengthDays'] as num?)?.toInt() ?? 28,
      lastPeriodStartDate: json['lastPeriodStartDate'] == null
          ? null
          : DateTime.parse(json['lastPeriodStartDate'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dailyHydrationGoalGlasses': instance.dailyHydrationGoalGlasses,
      'averageCycleLengthDays': instance.averageCycleLengthDays,
      'lastPeriodStartDate': instance.lastPeriodStartDate?.toIso8601String(),
    };
