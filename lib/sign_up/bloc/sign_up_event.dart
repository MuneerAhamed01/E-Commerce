part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

final class SignUpDisplayNameChanged extends SignUpEvent {
  const SignUpDisplayNameChanged(this.displayName);

  final String displayName;

  @override
  List<Object?> get props => [displayName];
}

final class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

final class SignUpConfirmedPasswordChanged extends SignUpEvent {
  const SignUpConfirmedPasswordChanged(this.confirmedPassword);

  final String confirmedPassword;

  @override
  List<Object?> get props => [confirmedPassword];
}

final class SignUpMarketingOptInChanged extends SignUpEvent {
  const SignUpMarketingOptInChanged(this.marketingOptIn);

  final bool marketingOptIn;

  @override
  List<Object?> get props => [marketingOptIn];
}

final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}

final class SignUpGoogleSignInRequested extends SignUpEvent {
  const SignUpGoogleSignInRequested();
}

final class SignUpAppleSignInRequested extends SignUpEvent {
  const SignUpAppleSignInRequested();
}
