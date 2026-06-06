import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Search bar for catalog / Algolia search screens.
class TrendsSearchField extends StatelessWidget {
  const TrendsSearchField({
    this.controller,
    this.hint = 'Search products',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    super.key,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: TrendsTypography.bodyMedium(TrendsColors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.search,
          color: TrendsColors.onSurfaceVariant,
        ),
        suffixIcon: onClear != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: TrendsColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
          borderSide: const BorderSide(color: TrendsColors.charcoal),
        ),
      ),
    );
  }
}
