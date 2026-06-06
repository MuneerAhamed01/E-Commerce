import 'package:cart_repository/src/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

/// Thrown when any cart operation fails.
class CartRepositoryException implements Exception {
  const CartRepositoryException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => 'CartRepositoryException: $message';
}

/// Persists cart items per user in Firestore `carts/{uid}/items`.
class CartRepository {
  CartRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _itemsRef(String userId) =>
      _firestore.collection('carts').doc(userId).collection('items');

  // ── Read ──────────────────────────────────────────────────────────────────

  /// Streams the user's cart (real-time updates).
  Stream<Cart> watchCart(String userId) {
    return _itemsRef(userId).snapshots().map(
      (snap) => Cart(
        items: snap.docs.map(CartItem.fromFirestore).toList(),
      ),
    );
  }

  /// Single-fetch the cart (for checkout summary).
  Future<Cart> getCart(String userId) async {
    try {
      final snap = await _itemsRef(userId).get();
      return Cart(items: snap.docs.map(CartItem.fromFirestore).toList());
    } catch (e) {
      throw CartRepositoryException('Failed to load cart', cause: e);
    }
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  /// Adds or increments an item. Matches on productId + variantId.
  Future<void> addItem({
    required String userId,
    required String productId,
    required String name,
    required double price,
    String? imageUrl,
    String? variantId,
    String? variantLabel,
    int quantity = 1,
  }) async {
    try {
      final ref = _itemsRef(userId);
      // Check if item already exists.
      final existing = await ref
          .where('productId', isEqualTo: productId)
          .where('variantId', isEqualTo: variantId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        final doc = existing.docs.first;
        final currentQty = (doc.data()['quantity'] as num?)?.toInt() ?? 1;
        await doc.reference.update({
          'quantity': currentQty + quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        final itemId = _uuid.v4();
        await ref.doc(itemId).set({
          'productId': productId,
          'name': name,
          'price': price,
          'quantity': quantity,
          'imageUrl': imageUrl,
          'variantId': variantId,
          'variantLabel': variantLabel,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw CartRepositoryException('Failed to add item to cart', cause: e);
    }
  }

  Future<void> updateQuantity({
    required String userId,
    required String itemId,
    required int quantity,
  }) async {
    try {
      if (quantity <= 0) {
        await removeItem(userId: userId, itemId: itemId);
        return;
      }
      await _itemsRef(userId).doc(itemId).update({
        'quantity': quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw CartRepositoryException('Failed to update cart item', cause: e);
    }
  }

  Future<void> removeItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      await _itemsRef(userId).doc(itemId).delete();
    } catch (e) {
      throw CartRepositoryException('Failed to remove cart item', cause: e);
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      final snap = await _itemsRef(userId).get();
      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw CartRepositoryException('Failed to clear cart', cause: e);
    }
  }

  // ── Coupons ───────────────────────────────────────────────────────────────

  /// Validates a coupon and returns the discount amount. Returns 0 if invalid.
  Future<({double discount, String? error})> validateCoupon({
    required String code,
    required double subtotal,
  }) async {
    try {
      final doc = await _firestore
          .collection('coupons')
          .doc(code.toUpperCase())
          .get();

      if (!doc.exists) return (discount: 0.0, error: 'Coupon not found');

      final data = doc.data()!;
      final isActive = data['isActive'] as bool? ?? false;
      if (!isActive) return (discount: 0.0, error: 'Coupon is expired');

      final minOrder = (data['minOrderAmount'] as num?)?.toDouble() ?? 0;
      if (subtotal < minOrder) {
        return (
          discount: 0.0,
          error: 'Minimum order ₹${minOrder.toInt()} required',
        );
      }

      final type = data['type'] as String? ?? 'percentage';
      final value = (data['value'] as num?)?.toDouble() ?? 0;

      final discount = type == 'percentage'
          ? (subtotal * value / 100).clamp(0.0, subtotal)
          : value.clamp(0.0, subtotal);

      return (discount: discount, error: null);
    } catch (e) {
      throw CartRepositoryException('Failed to validate coupon', cause: e);
    }
  }
}
