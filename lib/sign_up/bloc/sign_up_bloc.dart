import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

/// Business logic for account registration.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthenticationClient authenticationClient})
    : _authenticationClient = authenticationClient,
      super(const SignUpState()) {
    on<SignUpDisplayNameChanged>(_onDisplayNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmedPasswordChanged>(_onConfirmedPasswordChanged);
    on<SignUpMarketingOptInChanged>(_onMarketingOptInChanged);
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpGoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignUpAppleSignInRequested>(_onAppleSignInRequested);
  }

  final AuthenticationClient _authenticationClient;

  void _onDisplayNameChanged(
    SignUpDisplayNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        displayName: DisplayName.dirty(event.displayName),
        status: FormzSubmissionStatus.initial,
        failure: null,
      ),
    );
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: Email.dirty(event.email),
        status: FormzSubmissionStatus.initial,
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
        failure: null,
      ),
    );
  }

  void _onMarketingOptInChanged(
    SignUpMarketingOptInChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(marketingOptIn: event.marketingOptIn));
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    final displayName = DisplayName.dirty(state.displayName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    final isValid = Formz.validate([
      displayName,
      email,
      password,
      confirmedPassword,
    ]);

    emit(
      state.copyWith(
        displayName: displayName,
        email: email,
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: isValid,
        status: isValid
            ? FormzSubmissionStatus.inProgress
            : FormzSubmissionStatus.initial,
        failure: null,
      ),
    );

    if (!isValid) return;

    try {
      await _authenticationClient.signUp(
        email: email.value,
        password: password.value,
        displayName: displayName.value.trim(),
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
    SignUpAppleSignInRequested event,
    Emitter<SignUpState> emit,
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
