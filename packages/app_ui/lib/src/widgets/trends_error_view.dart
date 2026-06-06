import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:app_ui/src/widgets/trends_button.dart';
import 'package:flutter/material.dart';

/// Inline error state with optional retry action.
class TrendsErrorView extends StatelessWidget {
  const TrendsErrorView({
    required this.message,
    this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TrendsSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: colorScheme.error),
            const SizedBox(height: TrendsSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TrendsTypography.bodyMedium(colorScheme.onSurface),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: TrendsSpacing.lg),
              TrendsButton(
                label: 'Try again',
                onPressed: onRetry,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
