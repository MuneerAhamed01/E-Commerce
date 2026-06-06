import 'package:authentication_client/authentication_client.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/view/trends_app.dart';
import 'package:trends/bootstrap.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  testWidgets('Trends app renders design system showcase', (tester) async {
    final authClient = MockAuthenticationClient();
    final storage = InMemoryStorage();
    addTearDown(authClient.close);

    final dependencies = await createAppDependencies(
      analyticsRepository: const NoOpAnalyticsRepository(),
      authenticationClient: authClient,
      persistentStorage: storage,
      userRepository: UserRepository(
        firestore: FakeFirebaseFirestore(),
        storage: storage,
      ),
      homePage: const Scaffold(body: Center(child: Text('Design System'))),
    );
    addTearDown(dependencies.appBloc.close);

    await tester.pumpWidget(
      TrendsApp(
        analyticsRepository: dependencies.analyticsRepository,
        authenticationClient: dependencies.authenticationClient,
        userRepository: dependencies.userRepository,
        persistentStorage: dependencies.persistentStorage,
        appBloc: dependencies.appBloc,
        router: dependencies.router,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Design System'), findsOneWidget);
  });
}
