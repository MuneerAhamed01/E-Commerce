import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A single product variant (size + color combination).
class ProductVariant extends Equatable {
  const ProductVariant({
    required this.id,
    required this.size,
    required this.color,
    required this.sku,
    required this.stock,
    this.priceDelta = 0,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) => ProductVariant(
    id: map['id'] as String,
    size: map['size'] as String? ?? '',
    color: map['color'] as String? ?? '',
    sku: map['sku'] as String? ?? '',
    stock: (map['stock'] as num?)?.toInt() ?? 0,
    priceDelta: (map['priceDelta'] as num?)?.toDouble() ?? 0,
  );

  final String id;
  final String size;
  final String color;
  final String sku;
  final int stock;
  final double priceDelta;

  Map<String, dynamic> toMap() => {
    'id': id,
    'size': size,
    'color': color,
    'sku': sku,
    'stock': stock,
    'priceDelta': priceDelta,
  };

  @override
  List<Object?> get props => [id, size, color, sku, stock, priceDelta];
}

/// A product in the catalog.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.currency,
    required this.categoryId,
    required this.categoryName,
    required this.brandId,
    required this.brandName,
    this.salePrice,
    this.images = const [],
    this.variants = const [],
    this.stock = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.searchKeywords = const [],
    this.isFeatured = false,
    this.isPublished = true,
  });

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'] as String? ?? '',
      slug: data['slug'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      salePrice: (data['salePrice'] as num?)?.toDouble(),
      currency: data['currency'] as String? ?? 'INR',
      categoryId: data['categoryId'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? '',
      brandId: data['brandId'] as String? ?? '',
      brandName: data['brandName'] as String? ?? '',
      images: List<String>.from(data['images'] as List? ?? []),
      variants: ((data['variants'] as List?) ?? [])
          .map((v) => ProductVariant.fromMap(v as Map<String, dynamic>))
          .toList(),
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      searchKeywords:
          List<String>.from(data['searchKeywords'] as List? ?? []),
      isFeatured: data['isFeatured'] as bool? ?? false,
      isPublished: data['isPublished'] as bool? ?? true,
    );
  }

  final String id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final double? salePrice;
  final String currency;
  final String categoryId;
  final String categoryName;
  final String brandId;
  final String brandName;
  final List<String> images;
  final List<ProductVariant> variants;
  final int stock;
  final double rating;
  final int reviewCount;
  final List<String> searchKeywords;
  final bool isFeatured;
  final bool isPublished;

  String? get primaryImage => images.isNotEmpty ? images.first : null;

  double get effectivePrice => salePrice ?? price;

  bool get isOnSale => salePrice != null && salePrice! < price;

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    salePrice,
    categoryId,
    brandId,
    isFeatured,
  ];
}
