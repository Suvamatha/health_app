// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GamificationProfile _$GamificationProfileFromJson(Map<String, dynamic> json) {
  return _GamificationProfile.fromJson(json);
}

/// @nodoc
mixin _$GamificationProfile {
  int get totalXp => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastCheckInDate => throw _privateConstructorUsedError;

  /// Serializes this GamificationProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamificationProfileCopyWith<GamificationProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamificationProfileCopyWith<$Res> {
  factory $GamificationProfileCopyWith(
    GamificationProfile value,
    $Res Function(GamificationProfile) then,
  ) = _$GamificationProfileCopyWithImpl<$Res, GamificationProfile>;
  @useResult
  $Res call({
    int totalXp,
    int currentStreak,
    int longestStreak,
    DateTime? lastCheckInDate,
  });
}

/// @nodoc
class _$GamificationProfileCopyWithImpl<$Res, $Val extends GamificationProfile>
    implements $GamificationProfileCopyWith<$Res> {
  _$GamificationProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalXp = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCheckInDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalXp: null == totalXp
                ? _value.totalXp
                : totalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCheckInDate: freezed == lastCheckInDate
                ? _value.lastCheckInDate
                : lastCheckInDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GamificationProfileImplCopyWith<$Res>
    implements $GamificationProfileCopyWith<$Res> {
  factory _$$GamificationProfileImplCopyWith(
    _$GamificationProfileImpl value,
    $Res Function(_$GamificationProfileImpl) then,
  ) = __$$GamificationProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalXp,
    int currentStreak,
    int longestStreak,
    DateTime? lastCheckInDate,
  });
}

/// @nodoc
class __$$GamificationProfileImplCopyWithImpl<$Res>
    extends _$GamificationProfileCopyWithImpl<$Res, _$GamificationProfileImpl>
    implements _$$GamificationProfileImplCopyWith<$Res> {
  __$$GamificationProfileImplCopyWithImpl(
    _$GamificationProfileImpl _value,
    $Res Function(_$GamificationProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalXp = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCheckInDate = freezed,
  }) {
    return _then(
      _$GamificationProfileImpl(
        totalXp: null == totalXp
            ? _value.totalXp
            : totalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCheckInDate: freezed == lastCheckInDate
            ? _value.lastCheckInDate
            : lastCheckInDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GamificationProfileImpl implements _GamificationProfile {
  const _$GamificationProfileImpl({
    this.totalXp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCheckInDate,
  });

  factory _$GamificationProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamificationProfileImplFromJson(json);

  @override
  @JsonKey()
  final int totalXp;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final DateTime? lastCheckInDate;

  @override
  String toString() {
    return 'GamificationProfile(totalXp: $totalXp, currentStreak: $currentStreak, longestStreak: $longestStreak, lastCheckInDate: $lastCheckInDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamificationProfileImpl &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCheckInDate, lastCheckInDate) ||
                other.lastCheckInDate == lastCheckInDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalXp,
    currentStreak,
    longestStreak,
    lastCheckInDate,
  );

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamificationProfileImplCopyWith<_$GamificationProfileImpl> get copyWith =>
      __$$GamificationProfileImplCopyWithImpl<_$GamificationProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GamificationProfileImplToJson(this);
  }
}

abstract class _GamificationProfile implements GamificationProfile {
  const factory _GamificationProfile({
    final int totalXp,
    final int currentStreak,
    final int longestStreak,
    final DateTime? lastCheckInDate,
  }) = _$GamificationProfileImpl;

  factory _GamificationProfile.fromJson(Map<String, dynamic> json) =
      _$GamificationProfileImpl.fromJson;

  @override
  int get totalXp;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastCheckInDate;

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamificationProfileImplCopyWith<_$GamificationProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
