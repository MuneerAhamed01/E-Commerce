import 'package:app_ui/app_ui.dart';
import 'package:authentication_client/authentication_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:user_repository/user_repository.dart';

class TrendsApp extends StatelessWidget {
  const TrendsApp({
    required this.analyticsRepository,
    required this.authenticationClient,
    required this.userRepository,
    required this.persistentStorage,
    required this.appBloc,
    required this.router,
    super.key,
  });

  final AnalyticsRepository analyticsRepository;
  final AuthenticationClient authenticationClient;
  final UserRepository userRepository;
  final PersistentStorage persistentStorage;
  final AppBloc appBloc;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AnalyticsRepository>.value(
          value: analyticsRepository,
        ),
        RepositoryProvider<AuthenticationClient>.value(
          value: authenticationClient,
        ),
        RepositoryProvider<UserRepository>.value(value: userRepository),
        RepositoryProvider<PersistentStorage>.value(
          value: persistentStorage,
        ),
      ],
      child: BlocProvider<AppBloc>.value(
        value: appBloc,
        child: MaterialApp.router(
          title: 'Trends',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        ),
      ),
    );
  }
}
