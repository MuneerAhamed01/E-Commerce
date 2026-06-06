part of 'app_bloc.dart';

/// Application authentication status.
enum AppStatus {
  /// Initial state before auth is resolved.
  unknown,

  /// User is signed in with a loaded profile.
  authenticated,

  /// User is signed out.
  unauthenticated,
}

/// Global application state.
final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user,
  });

  const AppState.unknown() : this._(status: AppStatus.unknown);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.authenticated(User user)
    : this._(status: AppStatus.authenticated, user: user);

  final AppStatus status;
  final User? user;

  @override
  List<Object?> get props => [status, user];
}
