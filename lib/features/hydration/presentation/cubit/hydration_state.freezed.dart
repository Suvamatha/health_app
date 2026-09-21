// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hydration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HydrationState {
  bool get isLoading => throw _privateConstructorUsedError;
  int get glassesLoggedToday => throw _privateConstructorUsedError;
  int get dailyGoal => throw _privateConstructorUsedError;

  /// Create a copy of HydrationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HydrationStateCopyWith<HydrationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HydrationStateCopyWith<$Res> {
  factory $HydrationStateCopyWith(
    HydrationState value,
    $Res Function(HydrationState) then,
  ) = _$HydrationStateCopyWithImpl<$Res, HydrationState>;
  @useResult
  $Res call({bool isLoading, int glassesLoggedToday, int dailyGoal});
}

/// @nodoc
class _$HydrationStateCopyWithImpl<$Res, $Val extends HydrationState>
    implements $HydrationStateCopyWith<$Res> {
  _$HydrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HydrationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? glassesLoggedToday = null,
    Object? dailyGoal = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            glassesLoggedToday: null == glassesLoggedToday
                ? _value.glassesLoggedToday
                : glassesLoggedToday // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyGoal: null == dailyGoal
                ? _value.dailyGoal
                : dailyGoal // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HydrationStateImplCopyWith<$Res>
    implements $HydrationStateCopyWith<$Res> {
  factory _$$HydrationStateImplCopyWith(
    _$HydrationStateImpl value,
    $Res Function(_$HydrationStateImpl) then,
  ) = __$$HydrationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, int glassesLoggedToday, int dailyGoal});
}

/// @nodoc
class __$$HydrationStateImplCopyWithImpl<$Res>
    extends _$HydrationStateCopyWithImpl<$Res, _$HydrationStateImpl>
    implements _$$HydrationStateImplCopyWith<$Res> {
  __$$HydrationStateImplCopyWithImpl(
    _$HydrationStateImpl _value,
    $Res Function(_$HydrationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HydrationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? glassesLoggedToday = null,
    Object? dailyGoal = null,
  }) {
    return _then(
      _$HydrationStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        glassesLoggedToday: null == glassesLoggedToday
            ? _value.glassesLoggedToday
            : glassesLoggedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyGoal: null == dailyGoal
            ? _value.dailyGoal
            : dailyGoal // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$HydrationStateImpl implements _HydrationState {
  const _$HydrationStateImpl({
    this.isLoading = true,
    this.glassesLoggedToday = 0,
    this.dailyGoal = 8,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int glassesLoggedToday;
  @override
  @JsonKey()
  final int dailyGoal;

  @override
  String toString() {
    return 'HydrationState(isLoading: $isLoading, glassesLoggedToday: $glassesLoggedToday, dailyGoal: $dailyGoal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HydrationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.glassesLoggedToday, glassesLoggedToday) ||
                other.glassesLoggedToday == glassesLoggedToday) &&
            (identical(other.dailyGoal, dailyGoal) ||
                other.dailyGoal == dailyGoal));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, glassesLoggedToday, dailyGoal);

  /// Create a copy of HydrationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HydrationStateImplCopyWith<_$HydrationStateImpl> get copyWith =>
      __$$HydrationStateImplCopyWithImpl<_$HydrationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _HydrationState implements HydrationState {
  const factory _HydrationState({
    final bool isLoading,
    final int glassesLoggedToday,
    final int dailyGoal,
  }) = _$HydrationStateImpl;

  @override
  bool get isLoading;
  @override
  int get glassesLoggedToday;
  @override
  int get dailyGoal;

  /// Create a copy of HydrationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HydrationStateImplCopyWith<_$HydrationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
