import 'package:flutter_test/flutter_test.dart';
import 'package:trends/analytics/analytics.dart';

void main() {
  const repository = NoOpAnalyticsRepository();

  test('noop analytics methods complete without error', () async {
    await repository.logViewProduct(productId: 'p1', category: 'shirts');
    await repository.logAddToCart(productId: 'p1', quantity: 1, value: 99);
    await repository.logRemoveFromCart(productId: 'p1');
    await repository.logBeginCheckout(value: 99, currency: 'INR');
    await repository.logPurchase(
      transactionId: 't1',
      value: 99,
      currency: 'INR',
    );
    await repository.logSearch(searchTerm: 'linen');
  });
}
