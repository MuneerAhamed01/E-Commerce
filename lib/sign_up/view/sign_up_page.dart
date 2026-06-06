import 'package:authentication_client/authentication_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trends/sign_up/bloc/sign_up_bloc.dart';
import 'package:trends/sign_up/view/sign_up_view.dart';

/// Sign-up route entry — provides [SignUpBloc].
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        authenticationClient: context.read<AuthenticationClient>(),
      ),
      child: const SignUpView(),
    );
  }
}
