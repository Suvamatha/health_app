// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydration_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HydrationEntryImpl _$$HydrationEntryImplFromJson(Map<String, dynamic> json) =>
    _$HydrationEntryImpl(
      id: json['id'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      glassCount: (json['glassCount'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$HydrationEntryImplToJson(
  _$HydrationEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'loggedAt': instance.loggedAt.toIso8601String(),
  'glassCount': instance.glassCount,
};
