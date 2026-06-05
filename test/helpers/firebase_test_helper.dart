import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Firebase app options for unit and widget tests.
class TestFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: '1:696831045521:android:test',
    messagingSenderId: '696831045521',
    projectId: 'trends-commerce-dev',
    storageBucket: 'trends-commerce-dev.firebasestorage.app',
  );
}

/// Initializes a mock Firebase app for tests that require Firebase Core.
Future<void> setupFirebaseForTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: TestFirebaseOptions.currentPlatform);
}
