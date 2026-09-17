import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_typography.dart';

class AppTheme{
  AppTheme._() ;

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surfaceLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        surface: AppColors.surfaceLight,
        error: AppColors.errorLight,
      ),
      textTheme: AppTypography.textTheme(
        AppColors.textPrimaryLight,
        AppColors.textSecondaryLight,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        tertiary: AppColors.accentDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorDark,
      ),
      textTheme: AppTypography.textTheme(
        AppColors.textPrimaryDark,
        AppColors.textSecondaryDark,
      ),
      useMaterial3: true,
    );
  }

}