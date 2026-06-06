import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/src/user_preferences.dart';

/// Firestore user profile entity.
class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.displayName,
    this.phone,
    this.photoUrl,
    this.role = 'customer',
    this.orderCount = 0,
    this.defaultAddressId,
    this.fcmTokens = const [],
    this.preferences = const UserPreferences(),
    this.createdAt,
    this.updatedAt,
  });

  /// Firebase Auth UID.
  final String id;

  /// User email address.
  final String? email;

  /// Display name.
  final String? displayName;

  /// Phone number in E.164 format.
  final String? phone;

  /// Profile photo URL.
  final String? photoUrl;

  /// User role (`customer` or `admin`).
  final String role;

  /// Total completed orders.
  final int orderCount;

  /// Default shipping address id.
  final String? defaultAddressId;

  /// FCM device tokens.
  final List<String> fcmTokens;

  /// Notification and marketing preferences.
  final UserPreferences preferences;

  /// Document creation time.
  final DateTime? createdAt;

  /// Document last update time.
  final DateTime? updatedAt;

  static const collectionName = 'users';

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return User.fromJson({...data, 'id': doc.id});
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'customer',
      orderCount: json['orderCount'] as int? ?? 0,
      defaultAddressId: json['defaultAddressId'] as String?,
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferences: json['preferences'] is Map<String, dynamic>
          ? UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>,
            )
          : const UserPreferences(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'phone': phone,
    'photoUrl': photoUrl,
    'role': role,
    'orderCount': orderCount,
    'defaultAddressId': defaultAddressId,
    'fcmTokens': fcmTokens,
    'preferences': preferences.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  String toCacheJson() => jsonEncode(toJson());

  factory User.fromCacheJson(String source) =>
      User.fromJson(jsonDecode(source) as Map<String, dynamic>);

  static DateTime? _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    phone,
    photoUrl,
    role,
    orderCount,
    defaultAddressId,
    fcmTokens,
    preferences,
    createdAt,
    updatedAt,
  ];
}
