// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'period_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PeriodEntry _$PeriodEntryFromJson(Map<String, dynamic> json) {
  return _PeriodEntry.fromJson(json);
}

/// @nodoc
mixin _$PeriodEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get data => throw _privateConstructorUsedError;
  List<Symptom> get symptoms => throw _privateConstructorUsedError;

  /// Serializes this PeriodEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PeriodEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeriodEntryCopyWith<PeriodEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodEntryCopyWith<$Res> {
  factory $PeriodEntryCopyWith(
    PeriodEntry value,
    $Res Function(PeriodEntry) then,
  ) = _$PeriodEntryCopyWithImpl<$Res, PeriodEntry>;
  @useResult
  $Res call({String id, DateTime data, List<Symptom> symptoms});
}

/// @nodoc
class _$PeriodEntryCopyWithImpl<$Res, $Val extends PeriodEntry>
    implements $PeriodEntryCopyWith<$Res> {
  _$PeriodEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeriodEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? data = null, Object? symptoms = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<Symptom>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PeriodEntryImplCopyWith<$Res>
    implements $PeriodEntryCopyWith<$Res> {
  factory _$$PeriodEntryImplCopyWith(
    _$PeriodEntryImpl value,
    $Res Function(_$PeriodEntryImpl) then,
  ) = __$$PeriodEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime data, List<Symptom> symptoms});
}

/// @nodoc
class __$$PeriodEntryImplCopyWithImpl<$Res>
    extends _$PeriodEntryCopyWithImpl<$Res, _$PeriodEntryImpl>
    implements _$$PeriodEntryImplCopyWith<$Res> {
  __$$PeriodEntryImplCopyWithImpl(
    _$PeriodEntryImpl _value,
    $Res Function(_$PeriodEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PeriodEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? data = null, Object? symptoms = null}) {
    return _then(
      _$PeriodEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<Symptom>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PeriodEntryImpl implements _PeriodEntry {
  const _$PeriodEntryImpl({
    required this.id,
    required this.data,
    final List<Symptom> symptoms = const [],
  }) : _symptoms = symptoms;

  factory _$PeriodEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PeriodEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime data;
  final List<Symptom> _symptoms;
  @override
  @JsonKey()
  List<Symptom> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  @override
  String toString() {
    return 'PeriodEntry(id: $id, data: $data, symptoms: $symptoms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.data, data) || other.data == data) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    data,
    const DeepCollectionEquality().hash(_symptoms),
  );

  /// Create a copy of PeriodEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodEntryImplCopyWith<_$PeriodEntryImpl> get copyWith =>
      __$$PeriodEntryImplCopyWithImpl<_$PeriodEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PeriodEntryImplToJson(this);
  }
}

abstract class _PeriodEntry implements PeriodEntry {
  const factory _PeriodEntry({
    required final String id,
    required final DateTime data,
    final List<Symptom> symptoms,
  }) = _$PeriodEntryImpl;

  factory _PeriodEntry.fromJson(Map<String, dynamic> json) =
      _$PeriodEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get data;
  @override
  List<Symptom> get symptoms;

  /// Create a copy of PeriodEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeriodEntryImplCopyWith<_$PeriodEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
