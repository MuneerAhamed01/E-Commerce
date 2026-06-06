import 'package:authentication_client/authentication_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:trends/login/bloc/login_bloc.dart';

void main() {
  group('LoginBloc', () {
    late MockAuthenticationClient authClient;

    setUp(() {
      authClient = MockAuthenticationClient();
    });

    tearDown(() => authClient.close());

    blocTest<LoginBloc, LoginState>(
      'emits success on valid credentials',
      build: () => LoginBloc(authenticationClient: authClient),
      act: (bloc) async {
        bloc
          ..add(const LoginEmailChanged('user@example.com'))
          ..add(const LoginPasswordChanged('password123'))
          ..add(const LoginSubmitted());
      },
      expect: () => [
        isA<LoginState>(),
        isA<LoginState>(),
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.inProgress,
        ),
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure on wrong password',
      build: () => LoginBloc(authenticationClient: authClient),
      act: (bloc) async {
        bloc
          ..add(const LoginEmailChanged('user@example.com'))
          ..add(const LoginPasswordChanged('wrongpass'))
          ..add(const LoginSubmitted());
      },
      expect: () => [
        isA<LoginState>(),
        isA<LoginState>(),
        isA<LoginState>(),
        isA<LoginState>().having(
          (s) => s.failure?.code,
          'failure',
          AuthFailureCode.wrongPassword,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Google sign-in success',
      build: () => LoginBloc(authenticationClient: authClient),
      act: (bloc) => bloc.add(const LoginGoogleSignInRequested()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.inProgress,
        ),
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.success,
        ),
      ],
    );
  });
}
