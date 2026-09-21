// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hydration_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HydrationEntry _$HydrationEntryFromJson(Map<String, dynamic> json) {
  return _HydrationEntry.fromJson(json);
}

/// @nodoc
mixin _$HydrationEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;
  int get glassCount => throw _privateConstructorUsedError;

  /// Serializes this HydrationEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HydrationEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HydrationEntryCopyWith<HydrationEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HydrationEntryCopyWith<$Res> {
  factory $HydrationEntryCopyWith(
    HydrationEntry value,
    $Res Function(HydrationEntry) then,
  ) = _$HydrationEntryCopyWithImpl<$Res, HydrationEntry>;
  @useResult
  $Res call({String id, DateTime loggedAt, int glassCount});
}

/// @nodoc
class _$HydrationEntryCopyWithImpl<$Res, $Val extends HydrationEntry>
    implements $HydrationEntryCopyWith<$Res> {
  _$HydrationEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HydrationEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loggedAt = null,
    Object? glassCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            loggedAt: null == loggedAt
                ? _value.loggedAt
                : loggedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            glassCount: null == glassCount
                ? _value.glassCount
                : glassCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HydrationEntryImplCopyWith<$Res>
    implements $HydrationEntryCopyWith<$Res> {
  factory _$$HydrationEntryImplCopyWith(
    _$HydrationEntryImpl value,
    $Res Function(_$HydrationEntryImpl) then,
  ) = __$$HydrationEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime loggedAt, int glassCount});
}

/// @nodoc
class __$$HydrationEntryImplCopyWithImpl<$Res>
    extends _$HydrationEntryCopyWithImpl<$Res, _$HydrationEntryImpl>
    implements _$$HydrationEntryImplCopyWith<$Res> {
  __$$HydrationEntryImplCopyWithImpl(
    _$HydrationEntryImpl _value,
    $Res Function(_$HydrationEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HydrationEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loggedAt = null,
    Object? glassCount = null,
  }) {
    return _then(
      _$HydrationEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        loggedAt: null == loggedAt
            ? _value.loggedAt
            : loggedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        glassCount: null == glassCount
            ? _value.glassCount
            : glassCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HydrationEntryImpl implements _HydrationEntry {
  const _$HydrationEntryImpl({
    required this.id,
    required this.loggedAt,
    this.glassCount = 1,
  });

  factory _$HydrationEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HydrationEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime loggedAt;
  @override
  @JsonKey()
  final int glassCount;

  @override
  String toString() {
    return 'HydrationEntry(id: $id, loggedAt: $loggedAt, glassCount: $glassCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HydrationEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.glassCount, glassCount) ||
                other.glassCount == glassCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, loggedAt, glassCount);

  /// Create a copy of HydrationEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HydrationEntryImplCopyWith<_$HydrationEntryImpl> get copyWith =>
      __$$HydrationEntryImplCopyWithImpl<_$HydrationEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HydrationEntryImplToJson(this);
  }
}

abstract class _HydrationEntry implements HydrationEntry {
  const factory _HydrationEntry({
    required final String id,
    required final DateTime loggedAt,
    final int glassCount,
  }) = _$HydrationEntryImpl;

  factory _HydrationEntry.fromJson(Map<String, dynamic> json) =
      _$HydrationEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get loggedAt;
  @override
  int get glassCount;

  /// Create a copy of HydrationEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HydrationEntryImplCopyWith<_$HydrationEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
