part of 'forgot_password_bloc.dart';

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.resetEmailSent = false,
    this.failure,
  });

  final Email email;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool resetEmailSent;
  final AuthFailure? failure;

  ForgotPasswordState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? resetEmailSent,
    AuthFailure? failure,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      resetEmailSent: resetEmailSent ?? this.resetEmailSent,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    email,
    status,
    isValid,
    resetEmailSent,
    failure,
  ];
}
