part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched on app start to hydrate session and subscribe to auth changes.
final class AppStarted extends AppEvent {
  const AppStarted();
}

/// Dispatched when Firebase auth state changes.
final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.authUser);

  final AuthUser? authUser;

  @override
  List<Object?> get props => [authUser];
}

/// Dispatched when the user requests sign out.
final class AppSignOutRequested extends AppEvent {
  const AppSignOutRequested();
}
