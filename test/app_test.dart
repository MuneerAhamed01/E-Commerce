import 'package:authentication_client/authentication_client.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_repository/order_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/view/trends_app.dart';
import 'package:trends/bootstrap.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  testWidgets('Trends app opens on login when unauthenticated', (tester) async {
    final authClient = MockAuthenticationClient();
    final storage = InMemoryStorage();
    final fakeFirestore = FakeFirebaseFirestore();
    addTearDown(authClient.close);

    final dependencies = await createAppDependencies(
      analyticsRepository: const NoOpAnalyticsRepository(),
      authenticationClient: authClient,
      persistentStorage: storage,
      userRepository: UserRepository(
        firestore: fakeFirestore,
        storage: storage,
      ),
      productRepository: ProductRepository(firestore: fakeFirestore),
      cartRepository: CartRepository(firestore: fakeFirestore),
      orderRepository: OrderRepository(firestore: fakeFirestore),
    );
    addTearDown(dependencies.appBloc.close);

    await tester.pumpWidget(
      TrendsApp(
        analyticsRepository: dependencies.analyticsRepository,
        authenticationClient: dependencies.authenticationClient,
        userRepository: dependencies.userRepository,
        productRepository: dependencies.productRepository,
        cartRepository: dependencies.cartRepository,
        orderRepository: dependencies.orderRepository,
        persistentStorage: dependencies.persistentStorage,
        appBloc: dependencies.appBloc,
        router: dependencies.router,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
