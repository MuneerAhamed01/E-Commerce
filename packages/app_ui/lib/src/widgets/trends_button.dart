import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_theme_extension.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

enum TrendsButtonVariant { primary, secondary }

/// Gold CTA (primary) or charcoal outline (secondary) — Stitch Aura Couture.
class TrendsButton extends StatelessWidget {
  const TrendsButton({
    required this.label,
    required this.onPressed,
    this.variant = TrendsButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
    this.leading,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final TrendsButtonVariant variant;
  final bool isLoading;
  final bool expand;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final trends = context.trendsTheme;
    final isPrimary = variant == TrendsButtonVariant.primary;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isPrimary ? Colors.white : trends.charcoal,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: TrendsTypography.labelMedium(
                  isPrimary ? Colors.white : trends.charcoal,
                ),
              ),
            ],
          );

    final button = isPrimary
        ? FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: trends.accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: trends.accent.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: TrendsRadius.standardBorder,
              ),
              elevation: 0,
            ),
            child: child,
          )
        : OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: trends.charcoal,
              side: BorderSide(color: trends.charcoal),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: TrendsRadius.standardBorder,
              ),
            ),
            child: child,
          );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
