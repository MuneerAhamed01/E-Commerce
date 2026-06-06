import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Shared auth screen shell — editorial headline + scrollable body.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: TrendsAppBar(
        title: 'Trends',
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: TrendsSpacing.marginMobile,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: TrendsSpacing.lg),
              Text(
                title,
                style: TrendsTypography.headlineLarge(colorScheme.onSurface),
              ),
              const SizedBox(height: TrendsSpacing.sm),
              Text(
                subtitle,
                style: TrendsTypography.bodyMedium(
                  colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: TrendsSpacing.xl),
              child,
              const SizedBox(height: TrendsSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
