part of 'sign_up_bloc.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.submissionMethod = AuthSubmissionMethod.none,
    this.isValid = false,
    this.failure,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final AuthSubmissionMethod submissionMethod;
  final bool isValid;
  final AuthFailure? failure;

  bool get isEmailLoading =>
      status == FormzSubmissionStatus.inProgress &&
      submissionMethod == AuthSubmissionMethod.email;

  bool get isGoogleLoading =>
      status == FormzSubmissionStatus.inProgress &&
      submissionMethod == AuthSubmissionMethod.google;

  bool get isAppleLoading =>
      status == FormzSubmissionStatus.inProgress &&
      submissionMethod == AuthSubmissionMethod.apple;

  bool get isSubmitting => status == FormzSubmissionStatus.inProgress;

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzSubmissionStatus? status,
    AuthSubmissionMethod? submissionMethod,
    bool? isValid,
    AuthFailure? failure,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      submissionMethod: submissionMethod ?? this.submissionMethod,
      isValid: isValid ?? this.isValid,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    confirmedPassword,
    status,
    submissionMethod,
    isValid,
    failure,
  ];
}
