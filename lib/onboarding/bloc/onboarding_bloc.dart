import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

/// Business logic for post-sign-up profile completion.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required UserRepository userRepository,
    required String userId,
    String? initialDisplayName,
    bool initialMarketingOptIn = false,
  }) : _userRepository = userRepository,
       _userId = userId,
       super(
         OnboardingState(
           displayName: initialDisplayName != null &&
                   initialDisplayName.trim().isNotEmpty
               ? DisplayName.dirty(initialDisplayName)
               : const DisplayName.pure(),
           marketingOptIn: initialMarketingOptIn,
           needsDisplayName: initialDisplayName == null ||
               initialDisplayName.trim().isEmpty,
         ),
       ) {
    on<OnboardingDisplayNameChanged>(_onDisplayNameChanged);
    on<OnboardingPhoneChanged>(_onPhoneChanged);
    on<OnboardingMarketingOptInChanged>(_onMarketingOptInChanged);
    on<OnboardingSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;
  final String _userId;

  void _onDisplayNameChanged(
    OnboardingDisplayNameChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        displayName: DisplayName.dirty(event.displayName),
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onPhoneChanged(
    OnboardingPhoneChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        phone: event.phone,
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onMarketingOptInChanged(
    OnboardingMarketingOptInChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(marketingOptIn: event.marketingOptIn));
  }

  Future<void> _onSubmitted(
    OnboardingSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    final displayName = DisplayName.dirty(state.displayName.value);
    final isValid = state.needsDisplayName
        ? Formz.validate([displayName])
        : true;

    emit(
      state.copyWith(
        displayName: displayName,
        isValid: isValid,
        status: isValid
            ? FormzSubmissionStatus.inProgress
            : FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );

    if (!isValid) return;

    try {
      final user = await _userRepository.updateUser(
        userId: _userId,
        displayName: state.needsDisplayName
            ? displayName.value.trim()
            : null,
        phone: state.phone.trim().isEmpty ? null : state.phone.trim(),
        preferences: UserPreferences(
          marketingOptIn: state.marketingOptIn,
        ),
      );
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          completedUser: user,
        ),
      );
    } on UserRepositoryException catch (error) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Could not save your profile. Please try again.',
        ),
      );
    }
  }
}
