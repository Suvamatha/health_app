import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:healthtracker/features/period/domain/entities/period_entry.dart';

part 'period_state.freezed.dart';

@freezed
class PeriodState with _$PeriodState{
  const factory PeriodState ({
    @Default(true) bool isLoading,
    @Default([]) List<PeriodEntry> entries,
    @Default({}) Set<int> selectedSymptomIndexes,
  }) = _PeriodState;
}