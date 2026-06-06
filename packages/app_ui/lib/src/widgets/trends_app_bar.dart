import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Minimal luxury app bar — Stitch editorial style.
class TrendsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrendsAppBar({
    required this.title,
    this.actions = const [],
    this.leading,
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      leading: leading,
      title: Text(
        title,
        style: TrendsTypography.headlineSmall(colorScheme.onSurface),
      ),
      centerTitle: centerTitle,
      actions: [
        ...actions,
        const SizedBox(width: TrendsSpacing.sm),
      ],
    );
  }
}
