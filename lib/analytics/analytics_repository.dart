/// Commerce analytics events tracked across the app.
abstract class AnalyticsRepository {
  const AnalyticsRepository();

  Future<void> logViewProduct({
    required String productId,
    required String category,
  });

  Future<void> logAddToCart({
    required String productId,
    required int quantity,
    required double value,
  });

  Future<void> logRemoveFromCart({required String productId});

  Future<void> logBeginCheckout({
    required double value,
    required String currency,
  });

  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
  });

  Future<void> logSearch({required String searchTerm});
}
