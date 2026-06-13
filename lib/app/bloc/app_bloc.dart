import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

/// Global application auth and user profile state.
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationClient authenticationClient,
    required UserRepository userRepository,
  }) : _authenticationClient = authenticationClient,
       _userRepository = userRepository,
       super(const AppState.unknown()) {
    on<AppStarted>(_onStarted);
    on<AppUserChanged>(_onUserChanged);
    on<AppSignOutRequested>(_onSignOutRequested);
    on<AppProfileUpdated>(_onProfileUpdated);
  }

  final AuthenticationClient _authenticationClient;
  final UserRepository _userRepository;
  StreamSubscription<AuthUser?>? _userSubscription;

  Future<void> _onStarted(AppStarted event, Emitter<AppState> emit) async {
    final cachedUser = await _userRepository.getLastCachedUser();
    if (cachedUser != null) {
      emit(AppState.authenticated(cachedUser));
    }

    await _userSubscription?.cancel();
    _userSubscription = _authenticationClient.user.listen(
      (authUser) => add(AppUserChanged(authUser)),
    );

    final currentUser = _authenticationClient.currentUser;
    if (currentUser == null) {
      if (cachedUser == null) {
        emit(const AppState.unauthenticated());
      }
      return;
    }

    add(AppUserChanged(currentUser));
  }

  Future<void> _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) async {
    final authUser = event.authUser;
    if (authUser == null) {
      final lastUserId = state.user?.id;
      await _userRepository.clearCache(userId: lastUserId);
      emit(const AppState.unauthenticated());
      return;
    }

    try {
      final user = await _userRepository.loadOrCreateUser(
        userId: authUser.id,
        email: authUser.email,
        displayName: authUser.displayName,
        photoUrl: authUser.photoUrl,
      );
      emit(AppState.authenticated(user));
    } on UserRepositoryException catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onSignOutRequested(
    AppSignOutRequested event,
    Emitter<AppState> emit,
  ) async {
    await _authenticationClient.signOut();
  }

  void _onProfileUpdated(AppProfileUpdated event, Emitter<AppState> emit) {
    emit(AppState.authenticated(event.user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
