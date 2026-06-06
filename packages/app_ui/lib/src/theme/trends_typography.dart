import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens — Playfair Display (headlines) + Hanken Grotesk (UI).
abstract final class TrendsTypography {
  static TextStyle get playfair => GoogleFonts.playfairDisplay();
  static TextStyle get hanken => GoogleFonts.hankenGrotesk();

  static TextStyle displayLarge(Color color) => playfair.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -0.8,
    color: color,
  );

  static TextStyle headlineLarge(Color color) => playfair.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    color: color,
  );

  static TextStyle headlineMedium(Color color) => playfair.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    color: color,
  );

  static TextStyle headlineSmall(Color color) => playfair.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    color: color,
  );

  static TextStyle bodyLarge(Color color) => hanken.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: color,
  );

  static TextStyle bodyMedium(Color color) => hanken.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: color,
  );

  static TextStyle labelMedium(Color color) => hanken.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.7,
    color: color,
  );

  static TextStyle labelSmall(Color color) => hanken.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: color,
  );

  static TextStyle labelCaps(Color color) => labelMedium(color).copyWith(
    letterSpacing: 1.2,
  );

  static TextTheme textTheme(Color onSurface, Color onSurfaceVariant) =>
      TextTheme(
        displayLarge: displayLarge(onSurface),
        headlineLarge: headlineLarge(onSurface),
        headlineMedium: headlineMedium(onSurface),
        headlineSmall: headlineSmall(onSurface),
        bodyLarge: bodyLarge(onSurface),
        bodyMedium: bodyMedium(onSurface),
        labelLarge: labelMedium(onSurface),
        labelMedium: labelMedium(onSurface),
        labelSmall: labelSmall(onSurfaceVariant),
        titleLarge: headlineSmall(onSurface),
        titleMedium: labelMedium(onSurface),
        titleSmall: labelSmall(onSurfaceVariant),
      );
}
