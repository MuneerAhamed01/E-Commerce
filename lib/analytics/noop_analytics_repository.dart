import 'package:trends/analytics/analytics_repository.dart';

/// No-op analytics implementation for tests and offline development.
class NoOpAnalyticsRepository extends AnalyticsRepository {
  const NoOpAnalyticsRepository();

  @override
  Future<void> logViewProduct({
    required String productId,
    required String category,
  }) async {}

  @override
  Future<void> logAddToCart({
    required String productId,
    required int quantity,
    required double value,
  }) async {}

  @override
  Future<void> logRemoveFromCart({required String productId}) async {}

  @override
  Future<void> logBeginCheckout({
    required double value,
    required String currency,
  }) async {}

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
  }) async {}

  @override
  Future<void> logSearch({required String searchTerm}) async {}
}
