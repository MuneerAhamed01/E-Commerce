part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.submissionMethod = AuthSubmissionMethod.none,
    this.isValid = false,
    this.failure,
  });

  final Email email;
  final Password password;
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

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    AuthSubmissionMethod? submissionMethod,
    bool? isValid,
    AuthFailure? failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
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
    status,
    submissionMethod,
    isValid,
    failure,
  ];
}
