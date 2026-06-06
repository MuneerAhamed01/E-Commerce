part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingDisplayNameChanged extends OnboardingEvent {
  const OnboardingDisplayNameChanged(this.displayName);

  final String displayName;

  @override
  List<Object?> get props => [displayName];
}

final class OnboardingPhoneChanged extends OnboardingEvent {
  const OnboardingPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

final class OnboardingMarketingOptInChanged extends OnboardingEvent {
  const OnboardingMarketingOptInChanged(this.marketingOptIn);

  final bool marketingOptIn;

  @override
  List<Object?> get props => [marketingOptIn];
}

final class OnboardingSubmitted extends OnboardingEvent {
  const OnboardingSubmitted();
}
