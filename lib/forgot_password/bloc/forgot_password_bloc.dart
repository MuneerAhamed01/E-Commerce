import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

/// Business logic for password reset emails.
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required AuthenticationClient authenticationClient})
    : _authenticationClient = authenticationClient,
      super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final AuthenticationClient _authenticationClient;

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        email: Email.dirty(event.email),
        status: FormzSubmissionStatus.initial,
        failure: null,
        resetEmailSent: false,
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final isValid = Formz.validate([email]);

    emit(
      state.copyWith(
        email: email,
        isValid: isValid,
        status: isValid
            ? FormzSubmissionStatus.inProgress
            : FormzSubmissionStatus.initial,
        failure: null,
        resetEmailSent: false,
      ),
    );

    if (!isValid) return;

    try {
      await _authenticationClient.sendPasswordResetEmail(email: email.value);
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          resetEmailSent: true,
        ),
      );
    } on AuthFailure catch (failure) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: failure,
        ),
      );
    }
  }
}
