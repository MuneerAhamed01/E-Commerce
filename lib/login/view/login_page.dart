import 'package:authentication_client/authentication_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trends/login/bloc/login_bloc.dart';
import 'package:trends/login/view/login_view.dart';

/// Login route entry — provides [LoginBloc].
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authenticationClient: context.read<AuthenticationClient>(),
      ),
      child: const LoginView(),
    );
  }
}
