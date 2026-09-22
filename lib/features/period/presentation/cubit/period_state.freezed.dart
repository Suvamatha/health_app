// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'period_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PeriodState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<PeriodEntry> get entries => throw _privateConstructorUsedError;
  Set<int> get selectedSymptomIndexes => throw _privateConstructorUsedError;

  /// Create a copy of PeriodState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeriodStateCopyWith<PeriodState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodStateCopyWith<$Res> {
  factory $PeriodStateCopyWith(
    PeriodState value,
    $Res Function(PeriodState) then,
  ) = _$PeriodStateCopyWithImpl<$Res, PeriodState>;
  @useResult
  $Res call({
    bool isLoading,
    List<PeriodEntry> entries,
    Set<int> selectedSymptomIndexes,
  });
}

/// @nodoc
class _$PeriodStateCopyWithImpl<$Res, $Val extends PeriodState>
    implements $PeriodStateCopyWith<$Res> {
  _$PeriodStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeriodState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? entries = null,
    Object? selectedSymptomIndexes = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<PeriodEntry>,
            selectedSymptomIndexes: null == selectedSymptomIndexes
                ? _value.selectedSymptomIndexes
                : selectedSymptomIndexes // ignore: cast_nullable_to_non_nullable
                      as Set<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PeriodStateImplCopyWith<$Res>
    implements $PeriodStateCopyWith<$Res> {
  factory _$$PeriodStateImplCopyWith(
    _$PeriodStateImpl value,
    $Res Function(_$PeriodStateImpl) then,
  ) = __$$PeriodStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<PeriodEntry> entries,
    Set<int> selectedSymptomIndexes,
  });
}

/// @nodoc
class __$$PeriodStateImplCopyWithImpl<$Res>
    extends _$PeriodStateCopyWithImpl<$Res, _$PeriodStateImpl>
    implements _$$PeriodStateImplCopyWith<$Res> {
  __$$PeriodStateImplCopyWithImpl(
    _$PeriodStateImpl _value,
    $Res Function(_$PeriodStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PeriodState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? entries = null,
    Object? selectedSymptomIndexes = null,
  }) {
    return _then(
      _$PeriodStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<PeriodEntry>,
        selectedSymptomIndexes: null == selectedSymptomIndexes
            ? _value._selectedSymptomIndexes
            : selectedSymptomIndexes // ignore: cast_nullable_to_non_nullable
                  as Set<int>,
      ),
    );
  }
}

/// @nodoc

class _$PeriodStateImpl implements _PeriodState {
  const _$PeriodStateImpl({
    this.isLoading = true,
    final List<PeriodEntry> entries = const [],
    final Set<int> selectedSymptomIndexes = const {},
  }) : _entries = entries,
       _selectedSymptomIndexes = selectedSymptomIndexes;

  @override
  @JsonKey()
  final bool isLoading;
  final List<PeriodEntry> _entries;
  @override
  @JsonKey()
  List<PeriodEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  final Set<int> _selectedSymptomIndexes;
  @override
  @JsonKey()
  Set<int> get selectedSymptomIndexes {
    if (_selectedSymptomIndexes is EqualUnmodifiableSetView)
      return _selectedSymptomIndexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedSymptomIndexes);
  }

  @override
  String toString() {
    return 'PeriodState(isLoading: $isLoading, entries: $entries, selectedSymptomIndexes: $selectedSymptomIndexes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            const DeepCollectionEquality().equals(
              other._selectedSymptomIndexes,
              _selectedSymptomIndexes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_entries),
    const DeepCollectionEquality().hash(_selectedSymptomIndexes),
  );

  /// Create a copy of PeriodState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodStateImplCopyWith<_$PeriodStateImpl> get copyWith =>
      __$$PeriodStateImplCopyWithImpl<_$PeriodStateImpl>(this, _$identity);
}

abstract class _PeriodState implements PeriodState {
  const factory _PeriodState({
    final bool isLoading,
    final List<PeriodEntry> entries,
    final Set<int> selectedSymptomIndexes,
  }) = _$PeriodStateImpl;

  @override
  bool get isLoading;
  @override
  List<PeriodEntry> get entries;
  @override
  Set<int> get selectedSymptomIndexes;

  /// Create a copy of PeriodState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeriodStateImplCopyWith<_$PeriodStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
