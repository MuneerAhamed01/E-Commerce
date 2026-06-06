import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:flutter/material.dart';

/// Soft ambient shadows — Stitch: blur 20px+, 4–6% charcoal tint.
abstract final class TrendsShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: TrendsColors.shadowTint,
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: TrendsColors.shadowTint,
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
