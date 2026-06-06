import 'dart:async';
import 'dart:developer';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:order_repository/order_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/app.dart';
import 'package:trends/core/firebase/firebase.dart';
import 'package:user_repository/user_repository.dart';

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

/// Dependencies required to run [TrendsApp].
class AppDependencies {
  const AppDependencies({
    required this.analyticsRepository,
    required this.authenticationClient,
    required this.userRepository,
    required this.productRepository,
    required this.cartRepository,
    required this.orderRepository,
    required this.persistentStorage,
    required this.appBloc,
    required this.router,
  });

  final AnalyticsRepository analyticsRepository;
  final AuthenticationClient authenticationClient;
  final UserRepository userRepository;
  final ProductRepository productRepository;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;
  final PersistentStorage persistentStorage;
  final AppBloc appBloc;
  final GoRouter router;
}

Future<AppDependencies> createAppDependencies({
  AnalyticsRepository? analyticsRepository,
  AuthenticationClient? authenticationClient,
  UserRepository? userRepository,
  ProductRepository? productRepository,
  CartRepository? cartRepository,
  OrderRepository? orderRepository,
  PersistentStorage? persistentStorage,
  AppBloc? appBloc,
}) async {
  final storage = persistentStorage ?? await SharedPreferencesStorage.create();
  final authClient = authenticationClient ?? FirebaseAuthenticationClient();
  final firestore = FirebaseFirestore.instance;
  final users =
      userRepository ??
      UserRepository(
        firestore: firestore,
        storage: storage,
      );
  final products = productRepository ?? ProductRepository(firestore: firestore);
  final cart = cartRepository ?? CartRepository(firestore: firestore);
  final orders = orderRepository ?? OrderRepository(firestore: firestore);
  final analytics = analyticsRepository ?? FirebaseAnalyticsRepository();
  final bloc =
      appBloc ??
            AppBloc(
              authenticationClient: authClient,
              userRepository: users,
            )
        ..add(const AppStarted());

  final router = createAppRouter(appBloc: bloc);

  return AppDependencies(
    analyticsRepository: analytics,
    authenticationClient: authClient,
    userRepository: users,
    productRepository: products,
    cartRepository: cart,
    orderRepository: orders,
    persistentStorage: storage,
    appBloc: bloc,
    router: router,
  );
}

Future<void> bootstrap({
  Future<void> Function()? initializeFirebase,
  AnalyticsRepository? analyticsRepository,
  AuthenticationClient? authenticationClient,
  UserRepository? userRepository,
  PersistentStorage? persistentStorage,
  AppBloc? appBloc,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  final firebaseInitializer =
      initializeFirebase ?? FirebaseInitializer.initialize;
  await firebaseInitializer();
  await connectFirebaseEmulatorsIfNeeded();

  final dependencies = await createAppDependencies(
    analyticsRepository: analyticsRepository,
    authenticationClient: authenticationClient,
    userRepository: userRepository,
    persistentStorage: persistentStorage,
    appBloc: appBloc,
  );

  runApp(
    TrendsApp(
      analyticsRepository: dependencies.analyticsRepository,
      authenticationClient: dependencies.authenticationClient,
      userRepository: dependencies.userRepository,
      productRepository: dependencies.productRepository,
      cartRepository: dependencies.cartRepository,
      orderRepository: dependencies.orderRepository,
      persistentStorage: dependencies.persistentStorage,
      appBloc: dependencies.appBloc,
      router: dependencies.router,
    ),
  );
}
