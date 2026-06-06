import 'package:flutter_test/flutter_test.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/app/router/auth_redirect.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  const completeUser = User(id: 'uid-1', displayName: 'Jane Doe');
  const incompleteUser = User(id: 'uid-2');

  group('authRedirectForLocation', () {
    test('returns null while status is unknown', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.unknown(),
        location: AppRoutes.profile,
        uri: AppRoutes.profile,
      );
      expect(redirect, isNull);
    });

    test('redirects unauthenticated users from home to login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.unauthenticated(),
        location: AppRoutes.home,
        uri: AppRoutes.home,
      );
      expect(redirect, startsWith('${AppRoutes.login}?redirect='));
    });

    test('redirects unauthenticated users from profile to login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.unauthenticated(),
        location: AppRoutes.profile,
        uri: AppRoutes.profile,
      );
      expect(redirect, startsWith('${AppRoutes.login}?redirect='));
    });

    test('redirects unauthenticated users from onboarding to login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.unauthenticated(),
        location: AppRoutes.onboarding,
        uri: AppRoutes.onboarding,
      );
      expect(redirect, AppRoutes.login);
    });

    test('redirects incomplete profile to onboarding', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(incompleteUser),
        location: AppRoutes.home,
        uri: AppRoutes.home,
      );
      expect(redirect, AppRoutes.onboarding);
    });

    test('allows onboarding when profile is incomplete', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(incompleteUser),
        location: AppRoutes.onboarding,
        uri: AppRoutes.onboarding,
      );
      expect(redirect, isNull);
    });

    test('redirects complete profile away from onboarding', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(completeUser),
        location: AppRoutes.onboarding,
        uri: AppRoutes.onboarding,
      );
      expect(redirect, AppRoutes.home);
    });

    test('allows profile edit via onboarding query param', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(completeUser),
        location: AppRoutes.onboarding,
        uri: '${AppRoutes.onboarding}?edit=true',
        queryParams: const {'edit': 'true'},
      );
      expect(redirect, isNull);
    });

    test('redirects authenticated users away from login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(completeUser),
        location: AppRoutes.login,
        uri: AppRoutes.login,
      );
      expect(redirect, AppRoutes.home);
    });

    test('honors redirect query when authenticated on login', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(completeUser),
        location: AppRoutes.login,
        uri: AppRoutes.login,
        redirectParam: AppRoutes.profile,
      );
      expect(redirect, AppRoutes.profile);
    });

    test('redirects authenticated users away from forgot password', () {
      final redirect = authRedirectForLocation(
        appState: const AppState.authenticated(completeUser),
        location: AppRoutes.forgotPassword,
        uri: AppRoutes.forgotPassword,
      );
      expect(redirect, AppRoutes.home);
    });
  });

  group('requiresAuth', () {
    test('profile requires auth', () {
      expect(requiresAuth(AppRoutes.profile), isTrue);
    });

    test('home does not require auth via requiresAuth', () {
      expect(requiresAuth(AppRoutes.home), isFalse);
    });
  });
}
