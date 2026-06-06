import 'package:go_router/go_router.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';

/// Computes the auth-aware redirect location for [routerState].
String? authRedirect(AppState appState, GoRouterState routerState) {
  return authRedirectForLocation(
    appState: appState,
    location: routerState.matchedLocation,
    uri: routerState.uri.toString(),
    redirectParam: routerState.uri.queryParameters['redirect'],
  );
}

/// Computes redirect from explicit route values (test-friendly).
String? authRedirectForLocation({
  required AppState appState,
  required String location,
  required String uri,
  String? redirectParam,
}) {
  final isAuthenticated = appState.status == AppStatus.authenticated;
  final isUnknown = appState.status == AppStatus.unknown;
  final isAuthRoute =
      location == AppRoutes.login || location == AppRoutes.register;

  if (isUnknown) return null;

  if (!isAuthenticated && requiresAuth(location)) {
    final redirect = Uri.encodeComponent(uri);
    return '${AppRoutes.login}?redirect=$redirect';
  }

  if (isAuthenticated && isAuthRoute) {
    if (redirectParam != null && redirectParam.isNotEmpty) {
      return Uri.decodeComponent(redirectParam);
    }
    return AppRoutes.home;
  }

  return null;
}

/// Whether [location] requires an authenticated session.
bool requiresAuth(String location) {
  return location == AppRoutes.profile ||
      location == AppRoutes.checkout ||
      location == AppRoutes.orders ||
      location == AppRoutes.wishlist;
}
