import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_repository/src/catalog_models.dart';
import 'package:product_repository/src/product.dart';

/// Thrown when any product repository operation fails.
class ProductRepositoryException implements Exception {
  const ProductRepositoryException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => 'ProductRepositoryException: $message';
}

/// Reads catalog data from Firestore.
class ProductRepository {
  ProductRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  // ── Banners ───────────────────────────────────────────────────────────────

  Future<List<PromoBanner>> getBanners() async {
    try {
      final snap = await _firestore
          .collection('banners')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();
      return snap.docs.map(PromoBanner.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException('Failed to load banners', cause: e);
    }
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Future<List<Category>> getCategories() async {
    try {
      final snap = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();
      return snap.docs.map(Category.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException('Failed to load categories', cause: e);
    }
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      final doc = await _firestore.collection('categories').doc(id).get();
      if (!doc.exists) return null;
      return Category.fromFirestore(doc);
    } catch (e) {
      throw ProductRepositoryException('Failed to load category', cause: e);
    }
  }

  // ── Brands ────────────────────────────────────────────────────────────────

  Future<List<Brand>> getBrands() async {
    try {
      final snap = await _firestore
          .collection('brands')
          .where('isActive', isEqualTo: true)
          .get();
      return snap.docs.map(Brand.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException('Failed to load brands', cause: e);
    }
  }

  // ── Products ──────────────────────────────────────────────────────────────

  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();
      if (!doc.exists) return null;
      return Product.fromFirestore(doc);
    } catch (e) {
      throw ProductRepositoryException('Failed to load product', cause: e);
    }
  }

  Future<List<Product>> getFeaturedProducts({int limit = 8}) async {
    try {
      final snap = await _firestore
          .collection('products')
          .where('isPublished', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .limit(limit)
          .get();
      return snap.docs.map(Product.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException(
        'Failed to load featured products',
        cause: e,
      );
    }
  }

  Future<List<Product>> getNewArrivals({int limit = 8}) async {
    try {
      final snap = await _firestore
          .collection('products')
          .where('isPublished', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map(Product.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException(
        'Failed to load new arrivals',
        cause: e,
      );
    }
  }

  Future<List<Product>> getProductsByCategory(
    String categoryId, {
    int limit = 24,
    DocumentSnapshot? startAfter,
    String? sortBy,
  }) async {
    try {
      var query = _firestore
          .collection('products')
          .where('isPublished', isEqualTo: true)
          .where('categoryId', isEqualTo: categoryId);

      query = switch (sortBy) {
        'price_asc' => query.orderBy('price'),
        'price_desc' => query.orderBy('price', descending: true),
        'rating' => query.orderBy('rating', descending: true),
        _ => query.orderBy('isFeatured', descending: true),
      };

      query = query.limit(limit);
      if (startAfter != null) query = query.startAfterDocument(startAfter);

      final snap = await query.get();
      return snap.docs.map(Product.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException(
        'Failed to load category products',
        cause: e,
      );
    }
  }

  Future<List<Product>> searchProducts(String query, {int limit = 20}) async {
    try {
      // Firestore prefix search on name field (simple client-side approach).
      // For production use Algolia or Typesense.
      final lower = query.toLowerCase();
      final upper = '$lower\uf8ff';
      final snap = await _firestore
          .collection('products')
          .where('isPublished', isEqualTo: true)
          .where('name', isGreaterThanOrEqualTo: lower)
          .where('name', isLessThanOrEqualTo: upper)
          .limit(limit)
          .get();
      return snap.docs.map(Product.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException(
        'Failed to search products',
        cause: e,
      );
    }
  }

  // ── Reviews ───────────────────────────────────────────────────────────────

  Future<List<Review>> getProductReviews(
    String productId, {
    int limit = 10,
  }) async {
    try {
      final snap = await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map(Review.fromFirestore).toList();
    } catch (e) {
      throw ProductRepositoryException('Failed to load reviews', cause: e);
    }
  }
}
