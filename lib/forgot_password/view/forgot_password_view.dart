import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/auth/utils/form_field_errors.dart';
import 'package:trends/auth/widgets/auth_scaffold.dart';
import 'package:trends/core/errors/trends_error_handler.dart';
import 'package:trends/forgot_password/bloc/forgot_password_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.resetEmailSent != current.resetEmailSent,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure &&
            state.failure != null) {
          TrendsErrorHandler.show(context, error: state.failure);
        }
      },
      child: AuthScaffold(
        title: 'Reset password',
        subtitle: 'Enter your email and we will send you a reset link.',
        showBackButton: true,
        child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            final colorScheme = Theme.of(context).colorScheme;
            final isSubmitting =
                state.status == FormzSubmissionStatus.inProgress;

            if (state.resetEmailSent) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: TrendsSpacing.lg),
                  Text(
                    'Check your inbox',
                    style: TrendsTypography.headlineSmall(
                      colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TrendsSpacing.sm),
                  Text(
                    'We sent a password reset link to ${state.email.value}.',
                    style: TrendsTypography.bodyMedium(
                      colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TrendsSpacing.xl),
                  TrendsButton(
                    label: 'Back to sign in',
                    onPressed: () => context.pop(),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TrendsTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: emailErrorText(state.email),
                  onChanged: (value) => context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordEmailChanged(value),
                  ),
                ),
                const SizedBox(height: TrendsSpacing.xl),
                TrendsButton(
                  label: 'Send reset link',
                  isLoading: isSubmitting,
                  onPressed: isSubmitting
                      ? null
                      : () => context.read<ForgotPasswordBloc>().add(
                          const ForgotPasswordSubmitted(),
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
