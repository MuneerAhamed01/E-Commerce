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
import 'package:trends/core/errors/trends_error_handler.dart';
import 'package:trends/login/bloc/login_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure &&
            state.failure != null) {
          TrendsErrorHandler.show(context, error: state.failure);
        }
      },
      child: AuthScaffold(
        title: 'Sign in',
        subtitle: 'Sign in to continue your curated shopping experience.',
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TrendsTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: emailErrorText(state.email),
                  onChanged: (value) => context.read<LoginBloc>().add(
                    LoginEmailChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.md),
                PasswordTextField(
                  label: 'Password',
                  hint: '••••••••',
                  errorText: passwordErrorText(state.password),
                  onChanged: (value) => context.read<LoginBloc>().add(
                    LoginPasswordChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot password?',
                      style: TrendsTypography.labelMedium(
                        Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.lg),
                TrendsButton(
                  label: 'Sign in',
                  isLoading: state.isEmailLoading,
                  onPressed: state.isSubmitting
                      ? null
                      : () => context.read<LoginBloc>().add(
                          const LoginSubmitted(),
                        ),
                ),
                const SizedBox(height: TrendsSpacing.xl),
                SocialAuthSection(
                  isGoogleLoading: state.isGoogleLoading,
                  isAppleLoading: state.isAppleLoading,
                  disableSocialButtons: state.isSubmitting,
                  onGooglePressed: () => context.read<LoginBloc>().add(
                    const LoginGoogleSignInRequested(),
                  ),
                  onApplePressed: () => context.read<LoginBloc>().add(
                    const LoginAppleSignInRequested(),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to Trends? ',
                      style: TrendsTypography.bodyMedium(
                        Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => context.push(AppRoutes.register),
                      child: const Text('Create account'),
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
