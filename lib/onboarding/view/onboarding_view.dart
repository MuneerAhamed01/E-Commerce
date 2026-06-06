import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/auth/utils/form_field_errors.dart';
import 'package:trends/auth/widgets/auth_scaffold.dart';
import 'package:trends/onboarding/bloc/onboarding_bloc.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
        }
        if (state.status == FormzSubmissionStatus.success &&
            state.completedUser != null) {
          context.read<AppBloc>().add(
            AppProfileUpdated(state.completedUser!),
          );
          final isEditMode =
              GoRouterState.of(context).uri.queryParameters['edit'] == 'true';
          context.go(isEditMode ? AppRoutes.profile : AppRoutes.home);
        }
      },
      child: AuthScaffold(
        title: 'Complete your profile',
        subtitle: 'Tell us a little about yourself to personalize your experience.',
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            final colorScheme = Theme.of(context).colorScheme;
            final isSubmitting =
                state.status == FormzSubmissionStatus.inProgress;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.needsDisplayName) ...[
                  TrendsTextField(
                    label: 'Full name',
                    hint: 'Jane Doe',
                    errorText: displayNameErrorText(state.displayName),
                    onChanged: (value) => context.read<OnboardingBloc>().add(
                      OnboardingDisplayNameChanged(value),
                    ),
                  ),
                  const SizedBox(height: TrendsSpacing.md),
                ],
                TrendsTextField(
                  label: 'Phone (optional)',
                  hint: '+91 98765 43210',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => context.read<OnboardingBloc>().add(
                    OnboardingPhoneChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.md),
                CheckboxListTile(
                  value: state.marketingOptIn,
                  onChanged: isSubmitting
                      ? null
                      : (value) => context.read<OnboardingBloc>().add(
                          OnboardingMarketingOptInChanged(value ?? false),
                        ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Send me curated offers and new arrivals',
                    style: TrendsTypography.bodyMedium(
                      colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.xl),
                TrendsButton(
                  label: 'Continue',
                  isLoading: isSubmitting,
                  onPressed: isSubmitting
                      ? null
                      : () => context.read<OnboardingBloc>().add(
                          const OnboardingSubmitted(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
