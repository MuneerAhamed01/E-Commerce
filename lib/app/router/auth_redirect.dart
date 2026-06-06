import 'package:go_router/go_router.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/auth/utils/profile_utils.dart';

/// Computes the auth-aware redirect location for [routerState].
String? authRedirect(AppState appState, GoRouterState routerState) {
  return authRedirectForLocation(
    appState: appState,
    location: routerState.matchedLocation,
    uri: routerState.uri.toString(),
    redirectParam: routerState.uri.queryParameters['redirect'],
    queryParams: routerState.uri.queryParameters,
  );
}

/// Computes redirect from explicit route values (test-friendly).
String? authRedirectForLocation({
  required AppState appState,
  required String location,
  required String uri,
  String? redirectParam,
  Map<String, String> queryParams = const {},
}) {
  final isEditMode = queryParams['edit'] == 'true';
  final isAuthenticated = appState.status == AppStatus.authenticated;
  final isUnknown = appState.status == AppStatus.unknown;
  final isAuthRoute = location == AppRoutes.login ||
      location == AppRoutes.register ||
      location == AppRoutes.forgotPassword;
  final profileIncomplete = isProfileIncomplete(appState.user);

  if (isUnknown) return null;

  if (!isAuthenticated && location == AppRoutes.onboarding) {
    return AppRoutes.login;
  }

  if (isAuthenticated && profileIncomplete) {
    if (location != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }
    return null;
  }

  if (isAuthenticated &&
      !profileIncomplete &&
      location == AppRoutes.onboarding &&
      !isEditMode) {
    return AppRoutes.home;
  }

  if (!isAuthenticated) {
    if (location == AppRoutes.home || requiresAuth(location)) {
      final redirect = Uri.encodeComponent(uri);
      return '${AppRoutes.login}?redirect=$redirect';
    }
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
      location == AppRoutes.wishlist ||
      location == AppRoutes.cart ||
      location.startsWith(AppRoutes.orderDetail);
}
