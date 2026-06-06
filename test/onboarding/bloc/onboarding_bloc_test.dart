import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:trends/onboarding/bloc/onboarding_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('OnboardingBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = UserRepository(
        firestore: FakeFirebaseFirestore(),
        storage: InMemoryStorage(),
      );
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'emits success and updated user on valid submission',
      build: () => OnboardingBloc(
        userRepository: userRepository,
        userId: 'uid-1',
      ),
      setUp: () async {
        await userRepository.ensureUserDocument(
          userId: 'uid-1',
          email: 'user@example.com',
        );
      },
      act: (bloc) async {
        bloc
          ..add(const OnboardingDisplayNameChanged('Jane Doe'))
          ..add(const OnboardingPhoneChanged('+911234567890'))
          ..add(const OnboardingMarketingOptInChanged(true))
          ..add(const OnboardingSubmitted());
      },
      expect: () => [
        isA<OnboardingState>(),
        isA<OnboardingState>(),
        isA<OnboardingState>(),
        isA<OnboardingState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.inProgress,
        ),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', FormzSubmissionStatus.success)
            .having(
              (s) => s.completedUser?.displayName,
              'displayName',
              'Jane Doe',
            ),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'does not submit when display name is empty',
      build: () => OnboardingBloc(
        userRepository: userRepository,
        userId: 'uid-2',
      ),
      act: (bloc) => bloc.add(const OnboardingSubmitted()),
      expect: () => [
        isA<OnboardingState>().having(
          (s) => s.isValid,
          'isValid',
          isFalse,
        ),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'skips display name validation when profile already has a name',
      build: () => OnboardingBloc(
        userRepository: userRepository,
        userId: 'uid-3',
        initialDisplayName: 'Jane Doe',
      ),
      setUp: () async {
        await userRepository.ensureUserDocument(
          userId: 'uid-3',
          email: 'jane@example.com',
          displayName: 'Jane Doe',
        );
      },
      act: (bloc) async {
        bloc
          ..add(const OnboardingMarketingOptInChanged(true))
          ..add(const OnboardingSubmitted());
      },
      expect: () => [
        isA<OnboardingState>(),
        isA<OnboardingState>().having(
          (s) => s.status,
          'status',
          FormzSubmissionStatus.inProgress,
        ),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', FormzSubmissionStatus.success)
            .having(
              (s) => s.completedUser?.displayName,
              'displayName',
              'Jane Doe',
            ),
      ],
    );
  });
}
