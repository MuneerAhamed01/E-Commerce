import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Timestamp;
import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded;

  static OrderStatus fromString(String? value) =>
      OrderStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => OrderStatus.pending,
      );

  String get displayLabel => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.confirmed => 'Confirmed',
    OrderStatus.processing => 'Processing',
    OrderStatus.shipped => 'Shipped',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Cancelled',
    OrderStatus.refunded => 'Refunded',
  };
}

/// An item within a placed order.
class OrderItem extends Equatable {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.variantLabel,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    productId: map['productId'] as String,
    name: map['name'] as String? ?? '',
    price: (map['price'] as num).toDouble(),
    quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    imageUrl: map['imageUrl'] as String?,
    variantLabel: map['variantLabel'] as String?,
  );

  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? variantLabel;

  double get lineTotal => price * quantity;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
    'variantLabel': variantLabel,
  };

  @override
  List<Object?> get props => [productId, variantLabel, quantity, price];
}

/// A delivery address.
class Address extends Equatable {
  const Address({
    required this.id,
    required this.name,
    required this.line1,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    this.line2,
  });

  factory Address.fromMap(Map<String, dynamic> map) => Address(
    id: map['id'] as String? ?? '',
    name: map['name'] as String? ?? '',
    line1: map['line1'] as String? ?? '',
    line2: map['line2'] as String?,
    city: map['city'] as String? ?? '',
    state: map['state'] as String? ?? '',
    pincode: map['pincode'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
  );

  factory Address.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Address.fromMap({...doc.data()!, 'id': doc.id});

  final String id;
  final String name;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pincode;
  final String phone;

  String get displayLine1 => line1;
  String get displayLine2 => [if (line2 != null) line2!, city].join(', ');
  String get displayLine3 => '$state – $pincode';

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'line1': line1,
    'line2': line2,
    'city': city,
    'state': state,
    'pincode': pincode,
    'phone': phone,
  };

  @override
  List<Object?> get props => [id, name, line1, city, state, pincode, phone];
}

/// A placed order.
class Order extends Equatable {
  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.subtotal,
    required this.total,
    required this.status,
    this.couponCode,
    this.couponDiscount = 0,
    this.paymentId,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Order(
      id: doc.id,
      userId: data['userId'] as String,
      items: ((data['items'] as List?) ?? [])
          .map((i) => OrderItem.fromMap(i as Map<String, dynamic>))
          .toList(),
      address: Address.fromMap(data['address'] as Map<String, dynamic>),
      subtotal: (data['subtotal'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),
      couponCode: data['couponCode'] as String?,
      couponDiscount: (data['couponDiscount'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.fromString(data['status'] as String?),
      paymentId: data['paymentId'] as String?,
      paymentMethod: data['paymentMethod'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  final String id;
  final String userId;
  final List<OrderItem> items;
  final Address address;
  final double subtotal;
  final double couponDiscount;
  final double total;
  final String? couponCode;
  final OrderStatus status;
  final String? paymentId;
  final String? paymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  @override
  List<Object?> get props => [id, userId, status, total, createdAt];
}
