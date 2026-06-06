import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_shadows.dart';
import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:flutter/material.dart';

/// App-specific theme extension for tokens not covered by [ColorScheme].
@immutable
class TrendsThemeExtension extends ThemeExtension<TrendsThemeExtension> {
  const TrendsThemeExtension({
    required this.accent,
    required this.charcoal,
    required this.cardShadow,
    required this.elevatedShadow,
    required this.radiusStandard,
    required this.radiusCard,
    required this.radiusHero,
    required this.marginMobile,
    required this.gutterMobile,
  });

  final Color accent;
  final Color charcoal;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> elevatedShadow;
  final double radiusStandard;
  final double radiusCard;
  final double radiusHero;
  final double marginMobile;
  final double gutterMobile;

  static const light = TrendsThemeExtension(
    accent: TrendsColors.gold,
    charcoal: TrendsColors.charcoal,
    cardShadow: TrendsShadows.card,
    elevatedShadow: TrendsShadows.elevated,
    radiusStandard: TrendsRadius.standard,
    radiusCard: TrendsRadius.card,
    radiusHero: TrendsRadius.hero,
    marginMobile: TrendsSpacing.marginMobile,
    gutterMobile: TrendsSpacing.gutterMobile,
  );

  @override
  TrendsThemeExtension copyWith({
    Color? accent,
    Color? charcoal,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? elevatedShadow,
    double? radiusStandard,
    double? radiusCard,
    double? radiusHero,
    double? marginMobile,
    double? gutterMobile,
  }) {
    return TrendsThemeExtension(
      accent: accent ?? this.accent,
      charcoal: charcoal ?? this.charcoal,
      cardShadow: cardShadow ?? this.cardShadow,
      elevatedShadow: elevatedShadow ?? this.elevatedShadow,
      radiusStandard: radiusStandard ?? this.radiusStandard,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusHero: radiusHero ?? this.radiusHero,
      marginMobile: marginMobile ?? this.marginMobile,
      gutterMobile: gutterMobile ?? this.gutterMobile,
    );
  }

  @override
  TrendsThemeExtension lerp(
    covariant TrendsThemeExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return TrendsThemeExtension(
      accent: Color.lerp(accent, other.accent, t)!,
      charcoal: Color.lerp(charcoal, other.charcoal, t)!,
      cardShadow: cardShadow,
      elevatedShadow: elevatedShadow,
      radiusStandard: radiusStandard,
      radiusCard: radiusCard,
      radiusHero: radiusHero,
      marginMobile: marginMobile,
      gutterMobile: gutterMobile,
    );
  }
}

extension TrendsThemeContext on BuildContext {
  TrendsThemeExtension get trendsTheme =>
      Theme.of(this).extension<TrendsThemeExtension>()!;
}
