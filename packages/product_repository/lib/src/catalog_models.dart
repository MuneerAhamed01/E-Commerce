import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A product category.
class Category extends Equatable {
  const Category({
    required this.id,
    required this.title,
    required this.slug,
    this.imageUrl,
    this.parentId,
    this.sortOrder = 0,
    this.productCount = 0,
    this.isActive = true,
  });

  factory Category.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Category(
      id: doc.id,
      title: data['title'] as String? ?? '',
      slug: data['slug'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      parentId: data['parentId'] as String?,
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
      productCount: (data['productCount'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  final String id;
  final String title;
  final String slug;
  final String? imageUrl;
  final String? parentId;
  final int sortOrder;
  final int productCount;
  final bool isActive;

  @override
  List<Object?> get props => [id, title, slug, sortOrder];
}

/// A product brand.
class Brand extends Equatable {
  const Brand({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
    this.isActive = true,
  });

  factory Brand.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Brand(
      id: doc.id,
      name: data['name'] as String? ?? '',
      slug: data['slug'] as String? ?? '',
      logoUrl: data['logoUrl'] as String?,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  final String id;
  final String name;
  final String slug;
  final String? logoUrl;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, slug];
}

/// A promotional banner.
class PromoBanner extends Equatable {
  const PromoBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.actionLabel,
    this.actionUrl,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory PromoBanner.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PromoBanner(
      id: doc.id,
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      subtitle: data['subtitle'] as String?,
      actionLabel: data['actionLabel'] as String?,
      actionUrl: data['actionUrl'] as String?,
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? actionLabel;
  final String? actionUrl;
  final int sortOrder;
  final bool isActive;

  @override
  List<Object?> get props => [id, title, imageUrl, sortOrder];
}

/// A product review.
class Review extends Equatable {
  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.body,
    this.createdAt,
  });

  factory Review.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Review(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'Member',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String title;
  final String body;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, productId, userId, rating, createdAt];
}
