part of 'sign_up_bloc.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.displayName = const DisplayName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.marketingOptIn = false,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.failure,
  });

  final DisplayName displayName;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final bool marketingOptIn;
  final FormzSubmissionStatus status;
  final bool isValid;
  final AuthFailure? failure;

  SignUpState copyWith({
    DisplayName? displayName,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? marketingOptIn,
    FormzSubmissionStatus? status,
    bool? isValid,
    AuthFailure? failure,
  }) {
    return SignUpState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      marketingOptIn: marketingOptIn ?? this.marketingOptIn,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    displayName,
    email,
    password,
    confirmedPassword,
    marketingOptIn,
    status,
    isValid,
    failure,
  ];
}
