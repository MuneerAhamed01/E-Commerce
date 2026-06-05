import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/app.dart';
import 'package:trends/core/firebase/firebase.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  Future<void> Function()? initializeFirebase,
  AnalyticsRepository? analyticsRepository,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  final firebaseInitializer =
      initializeFirebase ?? FirebaseInitializer.initialize;
  await firebaseInitializer();

  final analytics =
      analyticsRepository ?? FirebaseAnalyticsRepository();

  runApp(
    TrendsApp(
      analyticsRepository: analytics,
    ),
  );
}
