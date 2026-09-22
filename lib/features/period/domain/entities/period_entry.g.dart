// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PeriodEntryImpl _$$PeriodEntryImplFromJson(Map<String, dynamic> json) =>
    _$PeriodEntryImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      symptoms:
          (json['symptoms'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SymptomEnumMap, e))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PeriodEntryImplToJson(_$PeriodEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'symptoms': instance.symptoms.map((e) => _$SymptomEnumMap[e]!).toList(),
    };

const _$SymptomEnumMap = {
  Symptom.cramps: 'cramps',
  Symptom.headache: 'headache',
  Symptom.fatigue: 'fatigue',
  Symptom.bloating: 'bloating',
  Symptom.moodSwings: 'moodSwings',
  Symptom.backache: 'backache',
};
