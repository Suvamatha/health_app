import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_radius.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffoldBackground: AppColors.surfaceLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryLight,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryContainerLight,
          onPrimaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondaryLight,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.secondaryContainerLight,
          onSecondaryContainer: AppColors.secondaryLight,
          tertiary: AppColors.accentLight,
          onTertiary: Colors.white,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.textPrimaryLight,
          surfaceContainerHighest: AppColors.surfaceContainerHighLight,
          surfaceContainer: AppColors.surfaceContainerLight,
          outline: AppColors.outlineLight,
          error: AppColors.errorLight,
          onError: Colors.white,
        ),
        textTheme: AppTypography.textTheme(
          AppColors.textPrimaryLight,
          AppColors.textSecondaryLight,
        ),
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffoldBackground: AppColors.surfaceDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryDark,
          onPrimary: AppColors.textPrimaryLight,
          primaryContainer: AppColors.primaryContainerDark,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondaryDark,
          onSecondary: AppColors.textPrimaryLight,
          secondaryContainer: AppColors.secondaryContainerDark,
          onSecondaryContainer: AppColors.secondaryDark,
          tertiary: AppColors.accentDark,
          onTertiary: AppColors.textPrimaryLight,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          surfaceContainerHighest: AppColors.surfaceContainerHighDark,
          surfaceContainer: AppColors.surfaceContainerDark,
          outline: AppColors.outlineDark,
          error: AppColors.errorDark,
          onError: AppColors.textPrimaryLight,
        ),
        textTheme: AppTypography.textTheme(
          AppColors.textPrimaryDark,
          AppColors.textSecondaryDark,
        ),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffoldBackground,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: colorScheme,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.bodySmall?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.45),
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface.withValues(alpha: 0.65),
          textStyle: textTheme.labelLarge,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? colorScheme.primary : colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: 0.35)
              : colorScheme.outline.withValues(alpha: 0.3);
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline, space: 1, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondary.withValues(alpha: 0.08),
        selectedColor: colorScheme.secondary,
        labelStyle: textTheme.bodyMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
    );
  }
}
