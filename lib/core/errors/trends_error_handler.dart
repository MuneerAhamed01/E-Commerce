import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trends/core/errors/trends_error_category.dart';
import 'package:trends/core/errors/trends_error_mapper.dart';
import 'package:trends/core/errors/trends_error_presentation.dart';
import 'package:trends/core/errors/trends_support_config.dart';

/// Central place for user-facing errors, previews, and success feedback.
abstract final class TrendsErrorHandler {
  static Future<void> show(
    BuildContext context, {
    Object? error,
    TrendsErrorCategory? category,
    String? title,
    String? message,
    bool? showContactSupport,
    String? featureName,
    VoidCallback? onRetry,
    VoidCallback? onPrimaryAction,
  }) {
    final presentation = TrendsErrorMapper.from(
      error: error,
      category: category,
      title: title,
      message: message,
      showContactSupport: showContactSupport,
      featureName: featureName,
    );

    return _showSheet(
      context,
      presentation: presentation,
      onRetry: onRetry,
      onPrimaryAction: onPrimaryAction,
    );
  }

  static Future<void> showFeatureUnavailable(
    BuildContext context, {
    required String featureName,
  }) {
    return show(
      context,
      category: TrendsErrorCategory.featureUnavailable,
      featureName: featureName,
    );
  }

  static Future<void> showPaymentUnavailable(BuildContext context) {
    return show(context, category: TrendsErrorCategory.payment);
  }

  static Future<void> showOrderFailure(
    BuildContext context, {
    String? message,
    VoidCallback? onRetry,
  }) {
    return _showSheet(
      context,
      presentation: TrendsErrorMapper.order(message: message),
      onRetry: onRetry,
    );
  }

  static Future<void> showContactSupport(BuildContext context) {
    return _showSheet(
      context,
      presentation: const TrendsErrorPresentation(
        title: TrendsSupportConfig.supportHeadline,
        message: TrendsSupportConfig.supportBody,
        category: TrendsErrorCategory.featureUnavailable,
        showContactSupport: true,
        primaryActionLabel: 'Got it',
        secondaryActionLabel: 'Email us',
      ),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.onInverseSurface,
              size: 20,
            ),
            const SizedBox(width: TrendsSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TrendsTypography.bodyMedium(
                  colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: colorScheme.primary,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  static void showBriefMessage(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  static Future<void> copySupportEmail(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: TrendsSupportConfig.supportEmail),
    );
    if (!context.mounted) return;
    showBriefMessage(
      context,
      'Email copied — ${TrendsSupportConfig.supportEmail}',
    );
  }

  static Future<void> _showSheet(
    BuildContext context, {
    required TrendsErrorPresentation presentation,
    VoidCallback? onRetry,
    VoidCallback? onPrimaryAction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return TrendsErrorSheet(
          title: presentation.title,
          message: presentation.message,
          tone: _toneFor(presentation.category),
          showContactSupport: presentation.showContactSupport,
          supportEmail: TrendsSupportConfig.supportEmail,
          supportHeadline: TrendsSupportConfig.supportHeadline,
          supportBody: TrendsSupportConfig.supportBody,
          primaryActionLabel: presentation.primaryActionLabel,
          secondaryActionLabel: presentation.secondaryActionLabel,
          onPrimaryPressed: () {
            Navigator.of(sheetContext).pop();
            if (presentation.primaryActionLabel == 'Try again') {
              onRetry?.call();
            }
            onPrimaryAction?.call();
          },
          onSecondaryPressed: presentation.secondaryActionLabel != null
              ? () {
                  Navigator.of(sheetContext).pop();
                  copySupportEmail(context);
                }
              : null,
          onContactPressed: presentation.showContactSupport
              ? () => copySupportEmail(sheetContext)
              : null,
        );
      },
    );
  }

  static TrendsFeedbackTone _toneFor(TrendsErrorCategory category) {
    return switch (category) {
      TrendsErrorCategory.network => TrendsFeedbackTone.warning,
      TrendsErrorCategory.payment => TrendsFeedbackTone.payment,
      TrendsErrorCategory.featureUnavailable => TrendsFeedbackTone.feature,
      _ => TrendsFeedbackTone.error,
    };
  }
}
