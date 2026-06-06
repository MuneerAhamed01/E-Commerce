import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Editorial section title with optional trailing action.
class TrendsSectionHeader extends StatelessWidget {
  const TrendsSectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.padding,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final row = Row(
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

    if (padding != null) {
      return Padding(padding: padding!, child: row);
    }
    return row;
  }
}
