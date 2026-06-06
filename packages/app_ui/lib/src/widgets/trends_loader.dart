import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_theme_extension.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Centered loading indicator with optional message.
class TrendsLoader extends StatelessWidget {
  const TrendsLoader({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trends = context.trendsTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: trends.accent,
            strokeWidth: 2,
          ),
          if (message != null) ...[
            const SizedBox(height: TrendsSpacing.md),
            Text(
              message!,
              style: TrendsTypography.bodyMedium(colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
