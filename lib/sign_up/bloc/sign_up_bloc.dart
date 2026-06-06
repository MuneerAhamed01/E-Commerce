import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:trends/auth/utils/auth_submission_method.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

/// Business logic for account registration.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthenticationClient authenticationClient})
    : _authenticationClient = authenticationClient,
      super(const SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmedPasswordChanged>(_onConfirmedPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpGoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignUpAppleSignInRequested>(_onAppleSignInRequested);
  }

  final AuthenticationClient _authenticationClient;

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: Email.dirty(event.email),
        status: FormzSubmissionStatus.initial,
        submissionMethod: AuthSubmissionMethod.none,
        failure: null,
      ),
    );
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: ConfirmedPassword.dirty(
          password: password.value,
          value: state.confirmedPassword.value,
        ),
        status: FormzSubmissionStatus.initial,
        submissionMethod: AuthSubmissionMethod.none,
        failure: null,
      ),
    );
  }

  void _onConfirmedPasswordChanged(
    SignUpConfirmedPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        confirmedPassword: ConfirmedPassword.dirty(
          password: state.password.value,
          value: event.confirmedPassword,
        ),
        status: FormzSubmissionStatus.initial,
        submissionMethod: AuthSubmissionMethod.none,
        failure: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    final isValid = Formz.validate([
      email,
      password,
      confirmedPassword,
    ]);

    emit(
      state.copyWith(
        email: email,
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: isValid,
        status: isValid
            ? FormzSubmissionStatus.inProgress
            : FormzSubmissionStatus.initial,
        submissionMethod:
            isValid ? AuthSubmissionMethod.email : AuthSubmissionMethod.none,
        failure: null,
      ),
    );

    if (!isValid) return;

    try {
      await _authenticationClient.signUp(
        email: email.value,
        password: password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AuthFailure catch (failure) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: failure,
        ),
      );
    }
  }

  Future<void> _onGoogleSignInRequested(
    SignUpGoogleSignInRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        submissionMethod: AuthSubmissionMethod.google,
        failure: null,
      ),
    );
    try {
      await _authenticationClient.signInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AuthFailure catch (failure) {
      if (failure.code == AuthFailureCode.cancelled) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.initial,
            submissionMethod: AuthSubmissionMethod.none,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: failure,
        ),
      );
    }
  }

  Future<void> _onAppleSignInRequested(
    SignUpAppleSignInRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        submissionMethod: AuthSubmissionMethod.apple,
        failure: null,
      ),
    );
    try {
      await _authenticationClient.signInWithApple();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AuthFailure catch (failure) {
      if (failure.code == AuthFailureCode.cancelled) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.initial,
            submissionMethod: AuthSubmissionMethod.none,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: failure,
        ),
      );
    }
  }
}
