import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Editorial section title with optional trailing action.
class TrendsSectionHeader extends StatelessWidget {
  const TrendsSectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionTap,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TrendsTypography.headlineSmall(colorScheme.onSurface),
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: TrendsTypography.labelMedium(colorScheme.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}
