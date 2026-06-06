import 'package:equatable/equatable.dart';

/// User notification and marketing preferences.
class UserPreferences extends Equatable {
  const UserPreferences({
    this.notificationsEnabled = true,
    this.marketingOptIn = false,
  });

  /// Whether push notifications are enabled.
  final bool notificationsEnabled;

  /// Whether marketing emails are opted in.
  final bool marketingOptIn;

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      marketingOptIn: json['marketingOptIn'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'notificationsEnabled': notificationsEnabled,
    'marketingOptIn': marketingOptIn,
  };

  @override
  List<Object?> get props => [notificationsEnabled, marketingOptIn];
}
