import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:order_repository/src/order.dart';
import 'package:uuid/uuid.dart';

/// Thrown when any order operation fails.
class OrderRepositoryException implements Exception {
  const OrderRepositoryException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => 'OrderRepositoryException: $message';
}

/// Manages Firestore orders.
class OrderRepository {
  OrderRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  // ── Read ──────────────────────────────────────────────────────────────────

  Stream<List<Order>> watchOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map(Order.fromFirestore).toList(),
        );
  }

  Future<List<Order>> getOrders(String userId, {int limit = 20}) async {
    try {
      final snap = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map(Order.fromFirestore).toList();
    } catch (e) {
      throw OrderRepositoryException('Failed to load orders', cause: e);
    }
  }

  Future<Order?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (!doc.exists) return null;
      return Order.fromFirestore(doc);
    } catch (e) {
      throw OrderRepositoryException('Failed to load order', cause: e);
    }
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<Order> createOrder({
    required String userId,
    required List<OrderItem> items,
    required Address address,
    required double subtotal,
    required double total,
    String? couponCode,
    double couponDiscount = 0,
    String? paymentId,
    String? paymentMethod,
  }) async {
    try {
      final orderId = _uuid.v4();
      final now = FieldValue.serverTimestamp();

      final data = {
        'userId': userId,
        'items': items.map((i) => i.toMap()).toList(),
        'address': address.toMap(),
        'subtotal': subtotal,
        'couponCode': couponCode,
        'couponDiscount': couponDiscount,
        'total': total,
        'status': OrderStatus.confirmed.name,
        'paymentId': paymentId,
        'paymentMethod': paymentMethod,
        'createdAt': now,
        'updatedAt': now,
      };

      await _firestore.collection('orders').doc(orderId).set(data);

      // Increment user's orderCount.
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'orderCount': FieldValue.increment(1)});

      final created = await _firestore.collection('orders').doc(orderId).get();
      return Order.fromFirestore(created);
    } catch (e) {
      throw OrderRepositoryException('Failed to create order', cause: e);
    }
  }

  // ── Addresses ─────────────────────────────────────────────────────────────

  Future<List<Address>> getAddresses(String userId) async {
    try {
      final snap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();
      return snap.docs.map(Address.fromFirestore).toList();
    } catch (e) {
      throw OrderRepositoryException('Failed to load addresses', cause: e);
    }
  }

  Future<Address> saveAddress({
    required String userId,
    required Address address,
  }) async {
    try {
      final id = address.id.isEmpty ? _uuid.v4() : address.id;
      final ref = _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(id);
      await ref.set({...address.toMap(), 'id': id}, SetOptions(merge: true));
      final doc = await ref.get();
      return Address.fromFirestore(doc);
    } catch (e) {
      throw OrderRepositoryException('Failed to save address', cause: e);
    }
  }

  Future<void> deleteAddress({
    required String userId,
    required String addressId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      throw OrderRepositoryException('Failed to delete address', cause: e);
    }
  }
}
