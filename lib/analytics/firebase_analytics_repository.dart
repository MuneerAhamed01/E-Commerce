import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:trends/analytics/analytics_repository.dart';

/// Firebase Analytics implementation of [AnalyticsRepository].
class FirebaseAnalyticsRepository extends AnalyticsRepository {
  FirebaseAnalyticsRepository({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logViewProduct({
    required String productId,
    required String category,
  }) {
    return _analytics.logEvent(
      name: 'view_product',
      parameters: {'product_id': productId, 'category': category},
    );
  }

  @override
  Future<void> logAddToCart({
    required String productId,
    required int quantity,
    required double value,
  }) {
    return _analytics.logEvent(
      name: 'add_to_cart',
      parameters: {
        'product_id': productId,
        'quantity': quantity,
        'value': value,
      },
    );
  }

  @override
  Future<void> logRemoveFromCart({required String productId}) {
    return _analytics.logEvent(
      name: 'remove_from_cart',
      parameters: {'product_id': productId},
    );
  }

  @override
  Future<void> logBeginCheckout({
    required double value,
    required String currency,
  }) {
    return _analytics.logEvent(
      name: 'begin_checkout',
      parameters: {'value': value, 'currency': currency},
    );
  }

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
  }) {
    return _analytics.logEvent(
      name: 'purchase',
      parameters: {
        'transaction_id': transactionId,
        'value': value,
        'currency': currency,
      },
    );
  }

  @override
  Future<void> logSearch({required String searchTerm}) {
    return _analytics.logEvent(
      name: 'search',
      parameters: {'search_term': searchTerm},
    );
  }
}
