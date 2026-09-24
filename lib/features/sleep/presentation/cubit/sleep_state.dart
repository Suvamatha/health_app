import '../../domain/sleep_entry.dart';

/// Hand-written cubit state (not @freezed) to keep this feature
/// independent of code generation.
class SleepState {
  final bool isLoading;
  final double? hoursLogged;
  final SleepQuality? quality;

  const SleepState({
    this.isLoading = true,
    this.hoursLogged,
    this.quality,
  });

  SleepState copyWith({
    bool? isLoading,
    double? hoursLogged,
    SleepQuality? quality,
  }) {
    return SleepState(
      isLoading: isLoading ?? this.isLoading,
      hoursLogged: hoursLogged ?? this.hoursLogged,
      quality: quality ?? this.quality,
    );
  }
}
