part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, failure }

enum CouponStatus { idle, validating, valid, invalid }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(),
    this.couponStatus = CouponStatus.idle,
    this.couponError,
  });

  final CartStatus status;
  final Cart cart;
  final CouponStatus couponStatus;
  final String? couponError;

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    CouponStatus? couponStatus,
    String? couponError,
  }) => CartState(
    status: status ?? this.status,
    cart: cart ?? this.cart,
    couponStatus: couponStatus ?? this.couponStatus,
    couponError: couponError ?? this.couponError,
  );

  @override
  List<Object?> get props => [status, cart, couponStatus, couponError];
}
