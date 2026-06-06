import 'package:app_ui/app_ui.dart';
import 'package:authentication_client/authentication_client.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_repository/order_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/cart/bloc/cart_bloc.dart';
import 'package:trends/wishlist/cubit/wishlist_cubit.dart';
import 'package:user_repository/user_repository.dart';

class TrendsApp extends StatelessWidget {
  const TrendsApp({
    required this.analyticsRepository,
    required this.authenticationClient,
    required this.userRepository,
    required this.productRepository,
    required this.cartRepository,
    required this.orderRepository,
    required this.persistentStorage,
    required this.appBloc,
    required this.router,
    super.key,
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
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<CartRepository>.value(value: cartRepository),
        RepositoryProvider<OrderRepository>.value(value: orderRepository),
        RepositoryProvider<PersistentStorage>.value(
          value: persistentStorage,
        ),
        RepositoryProvider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>.value(value: appBloc),
          BlocProvider<CartBloc>(
            create: (context) {
              final userId =
                  appBloc.state.user?.id ?? '__anonymous__';
              final bloc = CartBloc(
                cartRepository: cartRepository,
                userId: userId,
              );
              if (appBloc.state.user != null) {
                bloc.add(const CartStarted());
              }
              return bloc;
            },
          ),
          BlocProvider<WishlistCubit>(
            create: (context) => WishlistCubit(
              firestore: FirebaseFirestore.instance,
              productRepository: productRepository,
            ),
          ),
        ],
        child: _AppAuthListener(router: router),
      ),
    );
  }
}

/// Listens for auth changes and restarts CartBloc with the new userId.
class _AppAuthListener extends StatelessWidget {
  const _AppAuthListener({required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (prev, curr) => prev.user?.id != curr.user?.id,
      listener: (context, state) {
        if (state.user != null) {
          context.read<CartBloc>().add(const CartStarted());
          context.read<WishlistCubit>().loadWishlist(state.user!.id);
        }
      },
      child: MaterialApp.router(
        title: 'Trends',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }
}
