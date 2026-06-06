import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

enum TrendsBadgeVariant { gold, charcoal, neutral }

/// Small status / count badge.
class TrendsBadge extends StatelessWidget {
  const TrendsBadge({
    required this.label,
    this.variant = TrendsBadgeVariant.gold,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  final String label;
  final TrendsBadgeVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final (defaultBg, defaultFg) = switch (variant) {
      TrendsBadgeVariant.gold => (TrendsColors.gold, TrendsColors.white),
      TrendsBadgeVariant.charcoal => (
        TrendsColors.charcoal,
        TrendsColors.white,
      ),
      TrendsBadgeVariant.neutral => (
        TrendsColors.surfaceContainer,
        TrendsColors.onSurfaceVariant,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: TrendsRadius.pillBorder,
      ),
      child: Text(
        label,
        style: TrendsTypography.labelSmall(foregroundColor ?? defaultFg),
      ),
    );
  }
}
