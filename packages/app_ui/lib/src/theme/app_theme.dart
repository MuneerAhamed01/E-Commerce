import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_theme_extension.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Material [ThemeData] built from Stitch Aura Couture tokens.
abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: TrendsColors.charcoal,
      onPrimary: TrendsColors.white,
      primaryContainer: TrendsColors.charcoal,
      onPrimaryContainer: TrendsColors.white,
      secondary: TrendsColors.secondary,
      onSecondary: TrendsColors.onSecondary,
      secondaryContainer: TrendsColors.secondaryContainer,
      onSecondaryContainer: TrendsColors.onSurfaceVariant,
      tertiary: TrendsColors.gold,
      onTertiary: TrendsColors.white,
      tertiaryContainer: TrendsColors.tertiaryContainer,
      onTertiaryContainer: TrendsColors.onTertiaryContainer,
      error: TrendsColors.error,
      onError: TrendsColors.onError,
      errorContainer: TrendsColors.errorContainer,
      onErrorContainer: TrendsColors.onErrorContainer,
      surface: TrendsColors.background,
      onSurface: TrendsColors.onSurface,
      onSurfaceVariant: TrendsColors.onSurfaceVariant,
      outline: TrendsColors.outline,
      outlineVariant: TrendsColors.outlineVariant,
      shadow: TrendsColors.shadowTint,
      surfaceTint: TrendsColors.charcoal,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: TrendsColors.background,
      textTheme: TrendsTypography.textTheme(
        TrendsColors.onSurface,
        TrendsColors.onSurfaceVariant,
      ),
      extensions: const [TrendsThemeExtension.light],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: TrendsColors.background,
        foregroundColor: TrendsColors.onSurface,
        titleTextStyle: TrendsTypography.headlineSmall(TrendsColors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: TrendsColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: TrendsRadius.cardBorder,
          side: const BorderSide(color: TrendsColors.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: TrendsColors.surfaceContainerLowest,
        selectedColor: TrendsColors.charcoal,
        labelStyle: TrendsTypography.labelSmall(TrendsColors.onSurface),
        secondaryLabelStyle: TrendsTypography.labelSmall(TrendsColors.white),
        side: const BorderSide(color: TrendsColors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: TrendsRadius.pillBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TrendsColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: TrendsRadius.standardBorder,
          borderSide: const BorderSide(color: TrendsColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: TrendsRadius.standardBorder,
          borderSide: const BorderSide(color: TrendsColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: TrendsRadius.standardBorder,
          borderSide: const BorderSide(
            color: TrendsColors.charcoal,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: TrendsRadius.standardBorder,
          borderSide: const BorderSide(color: TrendsColors.error),
        ),
        labelStyle: TrendsTypography.labelCaps(TrendsColors.onSurfaceVariant),
        hintStyle: TrendsTypography.bodyMedium(TrendsColors.onSurfaceVariant),
      ),
      dividerTheme: const DividerThemeData(
        color: TrendsColors.outlineVariant,
        thickness: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: TrendsColors.surfaceContainerLowest,
        selectedItemColor: TrendsColors.charcoal,
        unselectedItemColor: TrendsColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
