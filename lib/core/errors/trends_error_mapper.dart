import 'package:authentication_client/authentication_client.dart';
import 'package:trends/core/errors/trends_error_category.dart';
import 'package:trends/core/errors/trends_error_presentation.dart';
import 'package:trends/core/errors/trends_support_config.dart';
import 'package:trends/core/exceptions/trends_exception.dart';
import 'package:user_repository/user_repository.dart';

/// Maps raw failures to polished, user-facing copy.
abstract final class TrendsErrorMapper {
  static TrendsErrorPresentation from({
    Object? error,
    TrendsErrorCategory? category,
    String? title,
    String? message,
    bool? showContactSupport,
    String? featureName,
  }) {
    if (category == TrendsErrorCategory.featureUnavailable ||
        featureName != null) {
      return featureUnavailable(featureName: featureName);
    }

    if (error is AuthFailure) {
      return _fromAuthFailure(error);
    }

    if (error is UserRepositoryException) {
      return const TrendsErrorPresentation(
        title: 'Profile unavailable',
        message:
            'We could not load your account right now. Please try again '
            'in a moment.',
        category: TrendsErrorCategory.general,
        showContactSupport: true,
        primaryActionLabel: 'Try again',
      );
    }

    if (error is UnauthorizedException) {
      return const TrendsErrorPresentation(
        title: 'Sign in required',
        message: 'Please sign in to continue with this action.',
        category: TrendsErrorCategory.auth,
      );
    }

    if (error is NotFoundException) {
      return const TrendsErrorPresentation(
        title: 'Not found',
        message: 'The item you requested is no longer available.',
        category: TrendsErrorCategory.general,
      );
    }

    if (error is FirebaseDataException) {
      return TrendsErrorPresentation(
        title: title ?? 'Something went wrong',
        message: message ??
            'We had trouble reaching our servers. Check your connection '
            'and try again.',
        category: TrendsErrorCategory.network,
        showContactSupport: showContactSupport ?? true,
        primaryActionLabel: 'Try again',
      );
    }

    if (error is TrendsException) {
      return TrendsErrorPresentation(
        title: title ?? 'Something went wrong',
        message: message ?? error.message,
        category: category ?? TrendsErrorCategory.general,
        showContactSupport: showContactSupport ?? true,
      );
    }

    return switch (category) {
      TrendsErrorCategory.payment => payment(),
      TrendsErrorCategory.order => order(message: message),
      TrendsErrorCategory.network => TrendsErrorPresentation(
        title: title ?? 'Connection issue',
        message: message ??
            'Please check your internet connection and try again.',
        category: TrendsErrorCategory.network,
        primaryActionLabel: 'Try again',
      ),
      TrendsErrorCategory.auth => TrendsErrorPresentation(
        title: title ?? 'Authentication failed',
        message: message ?? 'Please verify your details and try again.',
        category: TrendsErrorCategory.auth,
      ),
      _ => TrendsErrorPresentation(
        title: title ?? 'Something went wrong',
        message: message ??
            'An unexpected error occurred. Please try again.',
        category: category ?? TrendsErrorCategory.general,
        showContactSupport: showContactSupport ?? true,
        primaryActionLabel: 'Got it',
      ),
    };
  }

  static TrendsErrorPresentation featureUnavailable({String? featureName}) {
    final feature = featureName?.trim();
    final label = feature != null && feature.isNotEmpty ? feature : 'This feature';

    return TrendsErrorPresentation(
      title: TrendsSupportConfig.featureUnavailableTitle,
      message: '$label is part of the production roadmap. '
          '${TrendsSupportConfig.featureUnavailableBody}',
      category: TrendsErrorCategory.featureUnavailable,
      showContactSupport: true,
      primaryActionLabel: 'Got it',
      secondaryActionLabel: 'Contact us',
    );
  }

  static TrendsErrorPresentation payment() {
    return const TrendsErrorPresentation(
      title: 'Payment unavailable',
      message:
          'Online payments are not enabled in this demo build. '
          'Cash on delivery is available, or connect with us to enable '
          'Razorpay and other gateways.',
      category: TrendsErrorCategory.payment,
      showContactSupport: true,
      primaryActionLabel: 'Use cash on delivery',
      secondaryActionLabel: 'Contact us',
    );
  }

  static TrendsErrorPresentation order({String? message}) {
    return TrendsErrorPresentation(
      title: 'Order not placed',
      message: message ??
          'We could not complete your order. Please review your details '
          'and try again.',
      category: TrendsErrorCategory.order,
      showContactSupport: true,
      primaryActionLabel: 'Try again',
    );
  }

  static TrendsErrorPresentation _fromAuthFailure(AuthFailure failure) {
    if (failure.code == AuthFailureCode.cancelled) {
      return TrendsErrorPresentation(
        title: 'Sign-in cancelled',
        message: failure.message,
        category: TrendsErrorCategory.auth,
      );
    }

    final showSupport = failure.code == AuthFailureCode.unknown ||
        failure.code == AuthFailureCode.tooManyRequests;

    return TrendsErrorPresentation(
      title: 'Sign-in failed',
      message: failure.message,
      category: TrendsErrorCategory.auth,
      showContactSupport: showSupport,
      primaryActionLabel: 'Got it',
    );
  }
}
