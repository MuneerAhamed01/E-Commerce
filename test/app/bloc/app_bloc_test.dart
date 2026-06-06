import 'package:authentication_client/authentication_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('AppBloc', () {
    late MockAuthenticationClient authClient;
    late UserRepository userRepository;

    setUp(() {
      authClient = MockAuthenticationClient();
      userRepository = UserRepository(
        firestore: FakeFirebaseFirestore(),
        storage: InMemoryStorage(),
      );
    });

    tearDown(() => authClient.close());

    blocTest<AppBloc, AppState>(
      'emits unauthenticated when no cached user and signed out',
      build: () => AppBloc(
        authenticationClient: authClient,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(const AppStarted()),
      expect: () => [const AppState.unauthenticated()],
    );

    blocTest<AppBloc, AppState>(
      'emits authenticated with cached user on start',
      build: () => AppBloc(
        authenticationClient: authClient,
        userRepository: userRepository,
      ),
      setUp: () async {
        await userRepository.ensureUserDocument(
          userId: 'uid-1',
          email: 'cached@example.com',
          displayName: 'Cached User',
        );
      },
      act: (bloc) => bloc.add(const AppStarted()),
      expect: () => [
        isA<AppState>().having(
          (s) => s.status,
          'status',
          AppStatus.authenticated,
        ),
      ],
    );

    blocTest<AppBloc, AppState>(
      'emits unauthenticated on sign out',
      build: () => AppBloc(
        authenticationClient: authClient,
        userRepository: userRepository,
      ),
      act: (bloc) async {
        bloc.add(const AppStarted());
        authClient.emitUser(
          const AuthUser(id: 'uid-1', email: 'user@example.com'),
        );
        await Future<void>.delayed(Duration.zero);
        authClient.emitUser(null);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => [
        isA<AppState>().having(
          (s) => s.status,
          'status',
          AppStatus.authenticated,
        ),
        const AppState.unauthenticated(),
      ],
    );
  });
}
