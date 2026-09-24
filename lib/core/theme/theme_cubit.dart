import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_repository.dart';

/// Controls the app-wide [ThemeMode], persisted across launches.
class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeRepository _repository;

  ThemeCubit(this._repository) : super(ThemeMode.system);

  Future<void> loadThemeMode() async {
    final mode = await _repository.getThemeMode();
    emit(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repository.saveThemeMode(mode);
    emit(mode);
  }
}
