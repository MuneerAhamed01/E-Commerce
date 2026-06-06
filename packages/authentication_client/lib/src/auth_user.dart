import 'package:equatable/equatable.dart';

/// Authenticated user from the identity provider.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.providerId,
  });

  /// Unique user identifier (Firebase UID).
  final String id;

  /// User email address, if available.
  final String? email;

  /// User display name, if available.
  final String? displayName;

  /// Profile photo URL, if available.
  final String? photoUrl;

  /// Whether the email address has been verified.
  final bool emailVerified;

  /// Primary sign-in provider id (e.g. `password`, `google.com`).
  final String? providerId;

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    emailVerified,
    providerId,
  ];
}
