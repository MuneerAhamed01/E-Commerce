import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Minimalist input — uppercase label, 12px rounded container.
class TrendsTextField extends StatelessWidget {
  const TrendsTextField({
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: TrendsTypography.labelCaps(colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TrendsTypography.bodyMedium(colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
