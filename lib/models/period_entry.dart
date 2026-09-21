import 'package:freezed_annotation/freezed_annotation.dart';
import 'symptom.dart';

part 'period_entry.freezed.dart';
part 'period_entry.g.dart';

@freezed 
class PeriodEntry with _$PeriodEntry {
  const factory PeriodEntry ({
    required String id,
    required DateTime data,
    @Default([]) List <Symptom> symptoms,
  }) = _PeriodEntry;

  factory PeriodEntry.fromJson(Map<String, dynamic> json) => _$PeriodEntryFromJson(json);
}