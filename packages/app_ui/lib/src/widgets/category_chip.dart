import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Filter / category chip — pill shape, charcoal when selected.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(
        label,
        style: TrendsTypography.labelSmall(
          selected ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHighest,
      side: BorderSide(
        color: selected ? colorScheme.primary : colorScheme.outlineVariant,
      ),
    );
  }
}
