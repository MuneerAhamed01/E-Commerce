import 'package:trends/core/errors/trends_error_category.dart';

/// User-facing error content resolved before presentation.
class TrendsErrorPresentation {
  const TrendsErrorPresentation({
    required this.title,
    required this.message,
    this.category = TrendsErrorCategory.general,
    this.showContactSupport = false,
    this.primaryActionLabel = 'Got it',
    this.secondaryActionLabel,
  });

  final String title;
  final String message;
  final TrendsErrorCategory category;
  final bool showContactSupport;
  final String primaryActionLabel;
  final String? secondaryActionLabel;
}
