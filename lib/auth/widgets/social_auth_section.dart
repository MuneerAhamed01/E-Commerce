import 'dart:io' show Platform;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trends/auth/widgets/google_logo.dart';

/// Google (and Apple on iOS) social sign-in buttons — Aura Couture style.
class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({
    required this.onGooglePressed,
    this.onApplePressed,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.disableSocialButtons = false,
    super.key,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback? onApplePressed;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final bool disableSocialButtons;

  bool get _showApple {
    if (onApplePressed == null) return false;
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TrendsSpacing.md),
              child: Text(
                'OR',
                style: TrendsTypography.labelCaps(colorScheme.onSurfaceVariant),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: TrendsSpacing.lg),
        TrendsButton(
          label: 'Continue with Google',
          variant: TrendsButtonVariant.secondary,
          isLoading: isGoogleLoading,
          leading: isGoogleLoading ? null : const GoogleLogo(),
          onPressed: disableSocialButtons && !isGoogleLoading
              ? null
              : isGoogleLoading
              ? null
              : onGooglePressed,
        ),
        if (_showApple) ...[
          const SizedBox(height: TrendsSpacing.md),
          TrendsButton(
            label: 'Continue with Apple',
            variant: TrendsButtonVariant.secondary,
            isLoading: isAppleLoading,
            onPressed: disableSocialButtons && !isAppleLoading
                ? null
                : isAppleLoading
                ? null
                : onApplePressed,
          ),
        ],
      ],
    );
  }
}
