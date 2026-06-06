import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A single item in the shopping cart.
class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.variantId,
    this.variantLabel,
  });

  factory CartItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CartItem(
      id: doc.id,
      productId: data['productId'] as String,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: data['imageUrl'] as String?,
      variantId: data['variantId'] as String?,
      variantLabel: data['variantLabel'] as String?,
    );
  }

  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? variantId;
  final String? variantLabel;

  double get lineTotal => price * quantity;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
    'variantId': variantId,
    'variantLabel': variantLabel,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  CartItem copyWith({int? quantity}) => CartItem(
    id: id,
    productId: productId,
    name: name,
    price: price,
    quantity: quantity ?? this.quantity,
    imageUrl: imageUrl,
    variantId: variantId,
    variantLabel: variantLabel,
  );

  @override
  List<Object?> get props => [
    id,
    productId,
    variantId,
    quantity,
    price,
  ];
}

/// The user's cart, with items and optional coupon state.
class Cart extends Equatable {
  const Cart({
    this.items = const [],
    this.couponCode,
    this.couponDiscount = 0,
  });

  final List<CartItem> items;
  final String? couponCode;
  final double couponDiscount;

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get total => (subtotal - couponDiscount).clamp(0.0, double.infinity);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items, couponCode, couponDiscount];
}
