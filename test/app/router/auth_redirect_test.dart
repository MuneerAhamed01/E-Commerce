import 'package:flutter_test/flutter_test.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/app/router/auth_redirect.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('authRedirectForLocation', () {
    test('returns null while status is unknown', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.unknown(),
        location: AppRoutes.profile,
        uri: AppRoutes.profile,
      );
      expect(redirect, isNull);
    });

    test('redirects unauthenticated users from profile to login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.unauthenticated(),
        location: AppRoutes.profile,
        uri: AppRoutes.profile,
      );
      expect(redirect, startsWith('${AppRoutes.login}?redirect='));
    });

    test('redirects authenticated users away from login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(User(id: 'uid-1')),
        location: AppRoutes.login,
        uri: AppRoutes.login,
      );
      expect(redirect, AppRoutes.home);
    });

    test('honors redirect query when authenticated on login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(User(id: 'uid-1')),
        location: AppRoutes.login,
        uri: AppRoutes.login,
        redirectParam: AppRoutes.profile,
      );
      expect(redirect, AppRoutes.profile);
    });
  });

  group('requiresAuth', () {
    test('profile requires auth', () {
      expect(requiresAuth(AppRoutes.profile), isTrue);
    });

    test('home does not require auth', () {
      expect(requiresAuth(AppRoutes.home), isFalse);
    });
  });
}
