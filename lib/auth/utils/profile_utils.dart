import 'package:user_repository/user_repository.dart';

/// Whether the user must complete onboarding before using the app.
bool isProfileIncomplete(User? user) {
  if (user == null) return false;
  final name = user.displayName?.trim();
  return name == null || name.isEmpty;
}
