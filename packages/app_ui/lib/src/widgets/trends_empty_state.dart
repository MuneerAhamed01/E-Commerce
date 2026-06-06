import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Empty state for lists, cart, wishlist, etc.
class TrendsEmptyState extends StatelessWidget {
  const TrendsEmptyState({
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TrendsSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: TrendsSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TrendsTypography.headlineSmall(colorScheme.onSurface),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: TrendsSpacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TrendsTypography.bodyMedium(
                  colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: TrendsSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
