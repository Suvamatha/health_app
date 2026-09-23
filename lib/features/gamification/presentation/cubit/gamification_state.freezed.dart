// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GamificationState {
  bool get isLoading => throw _privateConstructorUsedError;
  GamificationProfile? get profile => throw _privateConstructorUsedError;

  /// Create a copy of GamificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamificationStateCopyWith<GamificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamificationStateCopyWith<$Res> {
  factory $GamificationStateCopyWith(
    GamificationState value,
    $Res Function(GamificationState) then,
  ) = _$GamificationStateCopyWithImpl<$Res, GamificationState>;
  @useResult
  $Res call({bool isLoading, GamificationProfile? profile});

  $GamificationProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$GamificationStateCopyWithImpl<$Res, $Val extends GamificationState>
    implements $GamificationStateCopyWith<$Res> {
  _$GamificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? profile = freezed}) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as GamificationProfile?,
          )
          as $Val,
    );
  }

  /// Create a copy of GamificationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GamificationProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $GamificationProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GamificationStateImplCopyWith<$Res>
    implements $GamificationStateCopyWith<$Res> {
  factory _$$GamificationStateImplCopyWith(
    _$GamificationStateImpl value,
    $Res Function(_$GamificationStateImpl) then,
  ) = __$$GamificationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, GamificationProfile? profile});

  @override
  $GamificationProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$GamificationStateImplCopyWithImpl<$Res>
    extends _$GamificationStateCopyWithImpl<$Res, _$GamificationStateImpl>
    implements _$$GamificationStateImplCopyWith<$Res> {
  __$$GamificationStateImplCopyWithImpl(
    _$GamificationStateImpl _value,
    $Res Function(_$GamificationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? profile = freezed}) {
    return _then(
      _$GamificationStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as GamificationProfile?,
      ),
    );
  }
}

/// @nodoc

class _$GamificationStateImpl implements _GamificationState {
  _$GamificationStateImpl({this.isLoading = true, this.profile});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final GamificationProfile? profile;

  @override
  String toString() {
    return 'GamificationState(isLoading: $isLoading, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamificationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, profile);

  /// Create a copy of GamificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamificationStateImplCopyWith<_$GamificationStateImpl> get copyWith =>
      __$$GamificationStateImplCopyWithImpl<_$GamificationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GamificationState implements GamificationState {
  factory _GamificationState({
    final bool isLoading,
    final GamificationProfile? profile,
  }) = _$GamificationStateImpl;

  @override
  bool get isLoading;
  @override
  GamificationProfile? get profile;

  /// Create a copy of GamificationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamificationStateImplCopyWith<_$GamificationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
