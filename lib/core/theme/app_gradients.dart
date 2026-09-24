import 'package:flutter/material.dart';
import 'app_color.dart';

/// Centralized gradients so "premium" surfaces (hero headers, CTAs,
/// celebratory streak banner) stay visually consistent instead of each
/// widget inventing its own.
class AppGradients {
  AppGradients._();

  static LinearGradient hero(Brightness brightness) {
    final colors = brightness == Brightness.dark
        ? AppColors.heroGradientDark
        : AppColors.heroGradientLight;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  static const LinearGradient gold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.goldGradient,
  );
}
