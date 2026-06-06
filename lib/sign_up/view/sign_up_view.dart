import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/auth/utils/form_field_errors.dart';
import 'package:trends/auth/widgets/auth_scaffold.dart';
import 'package:trends/auth/widgets/password_text_field.dart';
import 'package:trends/auth/widgets/social_auth_section.dart';
import 'package:trends/sign_up/bloc/sign_up_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.failure!.message)),
            );
        }
      },
      child: AuthScaffold(
        title: 'Create account',
        subtitle: 'Join Trends for a minimalist luxury shopping experience.',
        showBackButton: true,
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            final colorScheme = Theme.of(context).colorScheme;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TrendsTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: emailErrorText(state.email),
                  onChanged: (value) => context.read<SignUpBloc>().add(
                    SignUpEmailChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.md),
                PasswordTextField(
                  label: 'Password',
                  hint: '••••••••',
                  errorText: passwordErrorText(state.password),
                  onChanged: (value) => context.read<SignUpBloc>().add(
                    SignUpPasswordChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.md),
                PasswordTextField(
                  label: 'Confirm password',
                  hint: '••••••••',
                  errorText: confirmedPasswordErrorText(
                    state.confirmedPassword,
                  ),
                  onChanged: (value) => context.read<SignUpBloc>().add(
                    SignUpConfirmedPasswordChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.lg),
                TrendsButton(
                  label: 'Create account',
                  isLoading: state.isEmailLoading,
                  onPressed: state.isSubmitting
                      ? null
                      : () => context.read<SignUpBloc>().add(
                          const SignUpSubmitted(),
                        ),
                ),
                const SizedBox(height: TrendsSpacing.xl),
                SocialAuthSection(
                  isGoogleLoading: state.isGoogleLoading,
                  isAppleLoading: state.isAppleLoading,
                  disableSocialButtons: state.isSubmitting,
                  onGooglePressed: () => context.read<SignUpBloc>().add(
                    const SignUpGoogleSignInRequested(),
                  ),
                  onApplePressed: () => context.read<SignUpBloc>().add(
                    const SignUpAppleSignInRequested(),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TrendsTypography.bodyMedium(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => context.go(AppRoutes.login),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
