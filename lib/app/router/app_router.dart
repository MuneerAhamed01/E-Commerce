import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/auth_redirect.dart';
import 'package:trends/checkout/view/checkout_page.dart';
import 'package:trends/login/view/login_page.dart';
import 'package:trends/orders/view/orders_page.dart';
import 'package:trends/profile/view/profile_page.dart';
import 'package:trends/sign_up/view/sign_up_page.dart';
import 'package:trends/wishlist/view/wishlist_page.dart';

/// Route path constants.
abstract final class AppRoutes {
  static const home = '/';
  static const login = LoginPage.routeName;
  static const register = SignUpPage.routeName;
  static const profile = ProfilePage.routeName;
  static const checkout = CheckoutPage.routeName;
  static const orders = OrdersPage.routeName;
  static const wishlist = WishlistPage.routeName;
}

/// Creates the application router with auth-aware redirects.
GoRouter createAppRouter({
  required AppBloc appBloc,
  required Widget homePage,
}) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: _AppBlocListenable(appBloc),
    redirect: (context, state) => authRedirect(appBloc.state, state),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => homePage,
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: AppRoutes.orders,
        builder: (context, state) => const OrdersPage(),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) => const WishlistPage(),
      ),
    ],
  );
}

class _AppBlocListenable extends ChangeNotifier {
  _AppBlocListenable(this._appBloc) {
    _subscription = _appBloc.stream.listen((_) => notifyListeners());
  }

  final AppBloc _appBloc;
  late final StreamSubscription<AppState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
