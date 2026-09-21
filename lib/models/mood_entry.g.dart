// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoodEntryImpl _$$MoodEntryImplFromJson(Map<String, dynamic> json) =>
    _$MoodEntryImpl(
      id: json['id'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      moodLevel: (json['moodLevel'] as num).toInt(),
    );

Map<String, dynamic> _$$MoodEntryImplToJson(_$MoodEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'moodLevel': instance.moodLevel,
    };
