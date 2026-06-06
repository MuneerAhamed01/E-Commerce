import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required CartRepository cartRepository,
    required String userId,
  }) : _cartRepository = cartRepository,
       _userId = userId,
       super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityChanged>(_onQuantityChanged);
    on<CartCouponApplied>(_onCouponApplied);
    on<CartCouponRemoved>(_onCouponRemoved);
    on<CartCleared>(_onCartCleared);
    on<_CartUpdated>(_onCartUpdated);
  }

  final CartRepository _cartRepository;
  final String _userId;
  StreamSubscription<Cart>? _cartSubscription;

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    await _cartSubscription?.cancel();
    _cartSubscription = _cartRepository.watchCart(_userId).listen(
      (cart) => add(_CartUpdated(cart)),
      onError: (_) => emit(state.copyWith(status: CartStatus.failure)),
    );
  }

  void _onCartUpdated(_CartUpdated event, Emitter<CartState> emit) {
    emit(
      state.copyWith(
        status: CartStatus.success,
        cart: Cart(
          items: event.cart.items,
          couponCode: state.cart.couponCode,
          couponDiscount: state.cart.couponDiscount,
        ),
      ),
    );
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.addItem(
        userId: _userId,
        productId: event.productId,
        name: event.name,
        price: event.price,
        imageUrl: event.imageUrl,
        variantId: event.variantId,
        variantLabel: event.variantLabel,
        quantity: event.quantity,
      );
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.removeItem(
        userId: _userId,
        itemId: event.itemId,
      );
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  Future<void> _onQuantityChanged(
    CartItemQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.updateQuantity(
        userId: _userId,
        itemId: event.itemId,
        quantity: event.quantity,
      );
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  Future<void> _onCouponApplied(
    CartCouponApplied event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(couponStatus: CouponStatus.validating));
    try {
      final result = await _cartRepository.validateCoupon(
        code: event.code,
        subtotal: state.cart.subtotal,
      );
      if (result.error != null) {
        emit(
          state.copyWith(
            couponStatus: CouponStatus.invalid,
            couponError: result.error,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          couponStatus: CouponStatus.valid,
          cart: Cart(
            items: state.cart.items,
            couponCode: event.code.toUpperCase(),
            couponDiscount: result.discount,
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          couponStatus: CouponStatus.invalid,
          couponError: 'Could not validate coupon',
        ),
      );
    }
  }

  void _onCouponRemoved(CartCouponRemoved event, Emitter<CartState> emit) {
    emit(
      state.copyWith(
        couponStatus: CouponStatus.idle,
        cart: Cart(items: state.cart.items),
      ),
    );
  }

  Future<void> _onCartCleared(
    CartCleared event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.clearCart(_userId);
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
