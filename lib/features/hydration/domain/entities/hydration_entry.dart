import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_entry.freezed.dart';
part 'hydration_entry.g.dart';

@freezed
class HydrationEntry with _$HydrationEntry{
  const factory HydrationEntry ({
    required String id,
    required DateTime loggedAt,
    @Default(1) int glassCount,
  }) = _HydrationEntry;

  factory HydrationEntry.fromJson (Map<String, dynamic> json) =>  _$HydrationEntryFromJson(json);
}