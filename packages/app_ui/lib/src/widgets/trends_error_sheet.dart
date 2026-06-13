import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:app_ui/src/widgets/trends_button.dart';
import 'package:flutter/material.dart';

/// Visual tone for feedback sheets.
enum TrendsFeedbackTone {
  error,
  warning,
  feature,
  payment,
}

/// Polished bottom sheet for errors, preview features, and support prompts.
class TrendsErrorSheet extends StatelessWidget {
  const TrendsErrorSheet({
    required this.title,
    required this.message,
    required this.onPrimaryPressed,
    this.tone = TrendsFeedbackTone.error,
    this.showContactSupport = false,
    this.supportEmail = 'hello@trends.commerce',
    this.supportHeadline = 'Connect with us',
    this.supportBody =
        'For production features, integrations, and custom work, '
        'reach out and we will help you launch.',
    this.primaryActionLabel = 'Got it',
    this.secondaryActionLabel,
    this.onSecondaryPressed,
    this.onContactPressed,
    super.key,
  });

  final String title;
  final String message;
  final TrendsFeedbackTone tone;
  final bool showContactSupport;
  final String supportEmail;
  final String supportHeadline;
  final String supportBody;
  final String primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final VoidCallback? onContactPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final (icon, iconColor, iconBackground) = _toneVisuals(colorScheme);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        TrendsSpacing.md,
        0,
        TrendsSpacing.md,
        TrendsSpacing.md + bottomInset,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(TrendsRadius.card),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TrendsSpacing.lg,
            TrendsSpacing.sm,
            TrendsSpacing.lg,
            TrendsSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: TrendsSpacing.lg),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: TrendsSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TrendsTypography.headlineSmall(colorScheme.onSurface),
              ),
              const SizedBox(height: TrendsSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TrendsTypography.bodyMedium(
                  colorScheme.onSurfaceVariant,
                ),
              ),
              if (showContactSupport) ...[
                const SizedBox(height: TrendsSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TrendsSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(TrendsRadius.standard),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.support_agent_outlined,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: TrendsSpacing.sm),
                          Expanded(
                            child: Text(
                              supportHeadline,
                              style: TrendsTypography.labelMedium(
                                colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TrendsSpacing.xs),
                      Text(
                        supportBody,
                        style: TrendsTypography.labelSmall(
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: TrendsSpacing.sm),
                      InkWell(
                        onTap: onContactPressed,
                        borderRadius: BorderRadius.circular(TrendsRadius.sm),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: TrendsSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.mail_outline,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: TrendsSpacing.xs),
                              Text(
                                supportEmail,
                                style: TrendsTypography.labelMedium(
                                  colorScheme.primary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Copy',
                                style: TrendsTypography.labelSmall(
                                  colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: TrendsSpacing.lg),
              TrendsButton(
                label: primaryActionLabel,
                onPressed: onPrimaryPressed,
              ),
              if (secondaryActionLabel != null &&
                  onSecondaryPressed != null) ...[
                const SizedBox(height: TrendsSpacing.sm),
                TrendsButton(
                  label: secondaryActionLabel!,
                  variant: TrendsButtonVariant.secondary,
                  onPressed: onSecondaryPressed,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  (IconData, Color, Color) _toneVisuals(ColorScheme colorScheme) {
    return switch (tone) {
      TrendsFeedbackTone.error => (
        Icons.error_outline,
        colorScheme.error,
        colorScheme.errorContainer.withValues(alpha: 0.35),
      ),
      TrendsFeedbackTone.warning => (
        Icons.wifi_off_rounded,
        colorScheme.tertiary,
        colorScheme.tertiaryContainer.withValues(alpha: 0.35),
      ),
      TrendsFeedbackTone.feature => (
        Icons.auto_awesome_outlined,
        colorScheme.primary,
        colorScheme.primaryContainer.withValues(alpha: 0.35),
      ),
      TrendsFeedbackTone.payment => (
        Icons.payments_outlined,
        colorScheme.primary,
        colorScheme.primaryContainer.withValues(alpha: 0.35),
      ),
    };
  }
}
