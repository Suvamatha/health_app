// lib/features/gamification/presentation/cubit/gamification_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/gamification_profile.dart';
import '../../domain/repositories/gamification_repostiory.dart';
import 'gamification_state.dart';

class GamificationCubit extends Cubit<GamificationState> {
  final GamificationRepostiory _repository;

  GamificationCubit(this._repository) : super( GamificationState());

  static const int _xpPerCheckIn = 10;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isYesterday(DateTime date, DateTime today) {
    final yesterday = today.subtract(const Duration(days: 1));
    return _isSameDay(date, yesterday);
  }

  Future<void> loadProfile() async {
    final profile = await _repository.getProfile();
    emit(state.copyWith(isLoading: false, profile: profile));
  }

  Future<void> recordCheckIn() async {
    final current = state.profile ?? const GamificationProfile();
    final now = DateTime.now();

    final alreadyCheckedInToday = current.lastCheckInDate != null &&
        _isSameDay(current.lastCheckInDate!, now);

    // Already checked in today: mood/sleep/hydration/period logging can
    // all call recordCheckIn(), and the same screen can be tapped many
    // times in a row (dragging the sleep slider, re-picking a mood).
    // Bail out immediately so XP and streak are only ever touched ONCE
    // per calendar day, no matter how many times this is called.
    if (alreadyCheckedInToday) return;

    final int newStreak;
    if (current.lastCheckInDate != null && _isYesterday(current.lastCheckInDate!, now)) {
      newStreak = current.currentStreak + 1; // continuing an unbroken streak
    } else {
      newStreak = 1; // streak broke (or this is the very first check-in ever) — restart at 1
    }

    final updated = current.copyWith(
      totalXp: current.totalXp + _xpPerCheckIn,
      currentStreak: newStreak,
      longestStreak: newStreak > current.longestStreak ? newStreak : current.longestStreak,
      lastCheckInDate: now,
    );

    await _repository.saveProfile(updated);
    emit(state.copyWith(profile: updated));
  }
}