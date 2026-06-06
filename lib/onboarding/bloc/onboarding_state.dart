part of 'onboarding_bloc.dart';

final class OnboardingState extends Equatable {
  const OnboardingState({
    this.displayName = const DisplayName.pure(),
    this.phone = '',
    this.marketingOptIn = false,
    this.needsDisplayName = true,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.completedUser,
  });

  final DisplayName displayName;
  final String phone;
  final bool marketingOptIn;
  final bool needsDisplayName;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final User? completedUser;

  OnboardingState copyWith({
    DisplayName? displayName,
    String? phone,
    bool? marketingOptIn,
    bool? needsDisplayName,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    User? completedUser,
  }) {
    return OnboardingState(
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      marketingOptIn: marketingOptIn ?? this.marketingOptIn,
      needsDisplayName: needsDisplayName ?? this.needsDisplayName,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
      completedUser: completedUser ?? this.completedUser,
    );
  }

  @override
  List<Object?> get props => [
    displayName,
    phone,
    marketingOptIn,
    needsDisplayName,
    status,
    isValid,
    errorMessage,
    completedUser,
  ];
}
