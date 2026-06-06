import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:authentication_client/authentication_client.dart';
import 'package:trends/sign_up/bloc/sign_up_bloc.dart';

void main() {
  group('SignUpBloc', () {
    late MockAuthenticationClient authClient;

    setUp(() {
      authClient = MockAuthenticationClient();
    });

    tearDown(() => authClient.close());

    blocTest<SignUpBloc, SignUpState>(
      'emits success on valid sign up',
      build: () => SignUpBloc(authenticationClient: authClient),
      act: (bloc) async {
        bloc
          ..add(const SignUpEmailChanged('jane@example.com'))
          ..add(const SignUpPasswordChanged('password123'))
          ..add(const SignUpConfirmedPasswordChanged('password123'))
          ..add(const SignUpSubmitted());
      },
      expect: () => [
        isA<SignUpState>(),
        isA<SignUpState>(),
        isA<SignUpState>(),
        isA<SignUpState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.inProgress,
        ),
        isA<SignUpState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.success,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'does not submit when form is invalid',
      build: () => SignUpBloc(authenticationClient: authClient),
      act: (bloc) => bloc.add(const SignUpSubmitted()),
      expect: () => [
        isA<SignUpState>().having((s) => s.isValid, 'isValid', isFalse),
      ],
    );
  });
}
