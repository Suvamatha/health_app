import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fraunces (serif, warm + editorial) carries display/headline moments;
/// Plus Jakarta Sans (clean, humanist) carries body and UI text. Pairing a
/// characterful serif with a quiet sans gives the app its premium feel.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primaryTextColor, Color secondaryTextColor) {
    return TextTheme(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        height: 1.2,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.fraunces(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        height: 1.4,
        letterSpacing: 0.2,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondaryTextColor,
        letterSpacing: 0.4,
      ),
    );
  }
}
