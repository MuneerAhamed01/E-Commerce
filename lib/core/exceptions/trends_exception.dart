import 'package:equatable/equatable.dart';

/// Base exception for Trends domain and data layer errors.
sealed class TrendsException extends Equatable implements Exception {
  const TrendsException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() => 'TrendsException: $message';
}

/// Thrown when a Firebase or Firestore operation fails.
final class FirebaseDataException extends TrendsException {
  const FirebaseDataException(super.message, {super.cause});
}

/// Thrown when the user is not authenticated for a protected operation.
final class UnauthorizedException extends TrendsException {
  const UnauthorizedException([super.message = 'Authentication required.']);
}

/// Thrown when a requested resource does not exist.
final class NotFoundException extends TrendsException {
  const NotFoundException([super.message = 'Resource not found.']);
}
