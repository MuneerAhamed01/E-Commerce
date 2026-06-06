import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Business logic for email and social sign-in.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationClient authenticationClient})
    : _authenticationClient = authenticationClient,
      super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginGoogleSignInRequested>(_onGoogleSignInRequested);
    on<LoginAppleSignInRequested>(_onAppleSignInRequested);
  }

  final AuthenticationClient _authenticationClient;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: FormzSubmissionStatus.initial,
        failure: null,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: FormzSubmissionStatus.initial,
        failure: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final isValid = Formz.validate([email, password]);

    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: isValid,
        status: isValid
            ? FormzSubmissionStatus.inProgress
            : FormzSubmissionStatus.initial,
        failure: null,
      ),
    );

    if (!isValid) return;

    try {
      await _authenticationClient.signInWithEmailAndPassword(
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
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: const AuthFailure(
            code: AuthFailureCode.unknown,
            message: 'Something went wrong. Please try again.',
          ),
        ),
      );
    }
  }

  Future<void> _onGoogleSignInRequested(
    LoginGoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        failure: null,
      ),
    );
    try {
      await _authenticationClient.signInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AuthFailure catch (failure) {
      if (failure.code == AuthFailureCode.cancelled) {
        emit(state.copyWith(status: FormzSubmissionStatus.initial));
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
    LoginAppleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        failure: null,
      ),
    );
    try {
      await _authenticationClient.signInWithApple();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AuthFailure catch (failure) {
      if (failure.code == AuthFailureCode.cancelled) {
        emit(state.copyWith(status: FormzSubmissionStatus.initial));
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
