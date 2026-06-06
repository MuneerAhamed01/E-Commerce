import 'package:authentication_client/authentication_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trends/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:trends/forgot_password/view/forgot_password_view.dart';

/// Forgot password route entry.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  static const routeName = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(
        authenticationClient: context.read<AuthenticationClient>(),
      ),
      child: const ForgotPasswordView(),
    );
  }
}
