import 'package:flutter/material.dart';

/// Persists the user's preferred [ThemeMode] (system / light / dark).
abstract class ThemeRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}
