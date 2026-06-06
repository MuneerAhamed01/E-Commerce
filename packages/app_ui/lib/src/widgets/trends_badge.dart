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
    super.key,
  });

  final String label;
  final TrendsBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
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
        color: background,
        borderRadius: TrendsRadius.pillBorder,
      ),
      child: Text(
        label,
        style: TrendsTypography.labelSmall(foreground),
      ),
    );
  }
}
