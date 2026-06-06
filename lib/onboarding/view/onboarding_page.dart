import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/onboarding/bloc/onboarding_bloc.dart';
import 'package:trends/onboarding/view/onboarding_view.dart';
import 'package:user_repository/user_repository.dart';

/// Onboarding route entry — profile completion after sign-up.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppBloc>().state;
    final user = appState.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      create: (context) => OnboardingBloc(
        userRepository: context.read<UserRepository>(),
        userId: user.id,
        initialDisplayName: user.displayName,
        initialMarketingOptIn: user.preferences.marketingOptIn,
      ),
      child: const OnboardingView(),
    );
  }
}
