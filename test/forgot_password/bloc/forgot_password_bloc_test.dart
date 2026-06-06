import 'package:authentication_client/authentication_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:trends/forgot_password/bloc/forgot_password_bloc.dart';

void main() {
  group('ForgotPasswordBloc', () {
    late MockAuthenticationClient authClient;

    setUp(() {
      authClient = MockAuthenticationClient();
    });

    tearDown(() => authClient.close());

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'sends reset email on valid submission',
      build: () => ForgotPasswordBloc(authenticationClient: authClient),
      act: (bloc) async {
        bloc
          ..add(const ForgotPasswordEmailChanged('user@example.com'))
          ..add(const ForgotPasswordSubmitted());
      },
      expect: () => [
        isA<ForgotPasswordState>(),
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.inProgress,
        ),
        isA<ForgotPasswordState>().having(
          (s) => s.resetEmailSent,
          'resetEmailSent',
          isTrue,
        ),
      ],
    );
  });
}
