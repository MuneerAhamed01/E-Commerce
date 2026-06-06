import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/auth_redirect.dart';
import 'package:trends/cart/view/cart_page.dart';
import 'package:trends/catalog/view/catalog_page.dart';
import 'package:trends/categories/view/categories_page.dart';
import 'package:trends/checkout/view/checkout_page.dart';
import 'package:trends/forgot_password/view/forgot_password_page.dart';
import 'package:trends/home/view/home_page.dart';
import 'package:trends/login/view/login_page.dart';
import 'package:trends/onboarding/view/onboarding_page.dart';
import 'package:trends/orders/view/order_detail_page.dart';
import 'package:trends/orders/view/orders_page.dart';
import 'package:trends/product_detail/view/product_detail_page.dart';
import 'package:trends/profile/view/profile_page.dart';
import 'package:trends/search/view/search_page.dart';
import 'package:trends/shell/view/app_shell.dart';
import 'package:trends/sign_up/view/sign_up_page.dart';
import 'package:trends/wishlist/view/wishlist_page.dart';

/// Route path constants.
abstract final class AppRoutes {
  static const String home = '/';
  static const String login = LoginPage.routeName;
  static const String register = SignUpPage.routeName;
  static const String forgotPassword = ForgotPasswordPage.routeName;
  static const String onboarding = OnboardingPage.routeName;
  static const String profile = ProfilePage.routeName;
  static const String checkout = CheckoutPage.routeName;
  static const String orders = OrdersPage.routeName;
  static const String wishlist = WishlistPage.routeName;
  static const String cart = CartPage.routeName;
  static const String search = SearchPage.routeName;
  static const String catalog = '/catalog';
  static const String productDetail = '/product';
  static const String orderDetail = '/order';
  static const String categories = '/categories';
}

/// Creates the application router with auth-aware redirects.
GoRouter createAppRouter({required AppBloc appBloc}) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: _AppBlocListenable(appBloc),
    redirect: (context, state) => authRedirect(appBloc.state, state),
    routes: [
      // ── Auth routes (no shell) ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      // ── Overlay routes (no shell) ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '${AppRoutes.productDetail}/:productId',
        builder: (context, state) => ProductDetailPage(
          productId: state.pathParameters['productId']!,
        ),
      ),
      GoRoute(
        path: '${AppRoutes.orderDetail}/:orderId',
        builder: (context, state) => OrderDetailPage(
          orderId: state.pathParameters['orderId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.catalog,
        builder: (context, state) => CatalogPage(
          categoryId: state.uri.queryParameters['categoryId'] ?? '',
          title: state.uri.queryParameters['title'],
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchPage(),
      ),
      // ── Shell routes (bottom nav) ────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.categories,
                builder: (context, state) => const CategoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: AppRoutes.wishlist,
                builder: (context, state) => const WishlistPage(),
              ),
            ],
          ),
        ],
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
