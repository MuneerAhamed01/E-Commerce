part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  const CartStarted();
}

class CartItemAdded extends CartEvent {
  const CartItemAdded({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.variantId,
    this.variantLabel,
    this.quantity = 1,
  });

  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  final String? variantId;
  final String? variantLabel;
  final int quantity;

  @override
  List<Object?> get props => [productId, variantId, quantity];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.itemId);
  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class CartItemQuantityChanged extends CartEvent {
  const CartItemQuantityChanged({
    required this.itemId,
    required this.quantity,
  });

  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => [itemId, quantity];
}

class CartCouponApplied extends CartEvent {
  const CartCouponApplied(this.code);
  final String code;

  @override
  List<Object?> get props => [code];
}

class CartCouponRemoved extends CartEvent {
  const CartCouponRemoved();
}

class CartCleared extends CartEvent {
  const CartCleared();
}

class _CartUpdated extends CartEvent {
  const _CartUpdated(this.cart);
  final Cart cart;

  @override
  List<Object?> get props => [cart];
}
