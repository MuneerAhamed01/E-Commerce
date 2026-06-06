import 'package:flutter/material.dart';

/// Aura Couture color tokens from Google Stitch Trends project.
abstract final class TrendsColors {
  // Brand
  static const charcoal = Color(0xFF121212);
  static const gold = Color(0xFFC5A267);
  static const white = Color(0xFFFFFFFF);

  // Surfaces
  static const background = Color(0xFFF9F9F9);
  static const surfaceDim = Color(0xFFDADADA);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F3F3);
  static const surfaceContainer = Color(0xFFEEEEEE);
  static const surfaceContainerHigh = Color(0xFFE8E8E8);
  static const surfaceVariant = Color(0xFFE2E2E2);

  // Content
  static const onSurface = Color(0xFF1A1C1C);
  static const onSurfaceVariant = Color(0xFF444748);
  static const onBackground = Color(0xFF1A1C1C);

  // Borders
  static const outline = Color(0xFF747878);
  static const outlineVariant = Color(0xFFC4C7C7);

  // Semantic
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Secondary palette (Material mapping)
  static const secondary = Color(0xFF5D5F5F);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDFE0E0);

  // Tertiary / premium highlights
  static const tertiaryFixed = Color(0xFFFFDEAA);
  static const tertiaryContainer = Color(0xFF271900);
  static const onTertiaryContainer = Color(0xFF9F7F47);

  // Shadow tint for ambient elevation
  static const shadowTint = Color(0x1A121212);
}
