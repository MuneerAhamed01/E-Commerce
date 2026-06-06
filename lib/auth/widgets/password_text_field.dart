import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Password input with a show/hide visibility toggle.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final String label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TrendsTextField(
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscureText,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
