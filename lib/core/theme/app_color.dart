import 'package:flutter/material.dart';

/// Teal and Coral palette.
///
/// Color-psychology intent: deep teal reads as calm, trustworthy, and
/// balanced, which suits a health-tracking core (it should feel clinical-
/// grade calm, not alarming). Warm coral layers in feminine warmth and
/// energy without leaning on an expected pink/lavender cliche. A muted
/// gold is reserved for earned, celebratory moments only (streaks, rank)
/// so it keeps its impact instead of becoming visual noise.
class AppColors {
  AppColors._(); // prevents instantiation - this is a static-only container

  // Primary - Teal (calm, trust, balance)
  static const Color primaryLight = Color(0xFF0E7C7B);
  static const Color primaryDark = Color(0xFF5FD3C4);
  static const Color primaryContainerLight = Color(0xFFD8F0EE);
  static const Color primaryContainerDark = Color(0xFF1D4B49);

  // Secondary - Coral (warmth, energy)
  static const Color secondaryLight = Color(0xFFEF6C57);
  static const Color secondaryDark = Color(0xFFFF9B85);
  static const Color secondaryContainerLight = Color(0xFFFDE3DC);
  static const Color secondaryContainerDark = Color(0xFF5B2A22);

  // Tertiary / Accent - Muted gold, reserved for earned moments
  static const Color accentLight = Color(0xFFC79A48);
  static const Color accentDark = Color(0xFFE3C077);

  // Surfaces
  static const Color surfaceLight = Color(0xFFF5FBFA);
  static const Color surfaceDark = Color(0xFF0E1615);
  static const Color surfaceContainerLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerDark = Color(0xFF17211F);
  static const Color surfaceContainerHighLight = Color(0xFFE9F4F2);
  static const Color surfaceContainerHighDark = Color(0xFF1E2B29);

  // Text
  static const Color textPrimaryLight = Color(0xFF12201F);
  static const Color textPrimaryDark = Color(0xFFEAF6F4);
  static const Color textSecondaryLight = Color(0xFF556967);
  static const Color textSecondaryDark = Color(0xFFA9C4C0);

  // Borders / dividers
  static const Color outlineLight = Color(0xFFD7E7E4);
  static const Color outlineDark = Color(0xFF283936);

  // Status
  static const Color errorLight = Color(0xFFD64545);
  static const Color errorDark = Color(0xFFFF8A80);

  // Gradients - used sparingly for hero surfaces, CTAs, and celebratory
  // moments; never behind plain body text.
  static const List<Color> heroGradientLight = [Color(0xFF0E7C7B), Color(0xFFEF6C57)];
  static const List<Color> heroGradientDark = [Color(0xFF123B3A), Color(0xFF5C2A20)];

  static const List<Color> goldGradient = [Color(0xFFE3C077), Color(0xFFC79A48)];
}
