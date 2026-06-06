import 'package:bloc/bloc.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/order_repository.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required OrderRepository orderRepository,
    required CartRepository cartRepository,
  }) : _orderRepository = orderRepository,
       _cartRepository = cartRepository,
       super(const CheckoutState());

  final OrderRepository _orderRepository;
  final CartRepository _cartRepository;

  Future<void> loadAddresses(String userId) async {
    emit(state.copyWith(addressStatus: AddressStatus.loading));
    try {
      final addresses = await _orderRepository.getAddresses(userId);
      emit(
        state.copyWith(
          addressStatus: AddressStatus.loaded,
          addresses: addresses,
          selectedAddress: addresses.isNotEmpty ? addresses.first : null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(addressStatus: AddressStatus.failure));
    }
  }

  void selectAddress(Address address) {
    emit(state.copyWith(selectedAddress: address));
  }

  Future<void> saveAddress({
    required String userId,
    required Address address,
  }) async {
    try {
      final saved = await _orderRepository.saveAddress(
        userId: userId,
        address: address,
      );
      final updated = [...state.addresses, saved];
      emit(
        state.copyWith(
          addresses: updated,
          selectedAddress: saved,
          addressStatus: AddressStatus.loaded,
        ),
      );
    } catch (_) {
      emit(state.copyWith(addressStatus: AddressStatus.failure));
    }
  }

  Future<Order?> placeOrder({
    required String userId,
    required Cart cart,
    String? paymentId,
  }) async {
    if (state.selectedAddress == null) return null;
    emit(state.copyWith(orderStatus: OrderPlacementStatus.loading));
    try {
      final order = await _orderRepository.createOrder(
        userId: userId,
        items: cart.items
            .map(
              (i) => OrderItem(
                productId: i.productId,
                name: i.name,
                price: i.price,
                quantity: i.quantity,
                imageUrl: i.imageUrl,
                variantLabel: i.variantLabel,
              ),
            )
            .toList(),
        address: state.selectedAddress!,
        subtotal: cart.subtotal,
        total: cart.total,
        couponCode: cart.couponCode,
        couponDiscount: cart.couponDiscount,
        paymentId: paymentId,
        paymentMethod: paymentId != null ? 'razorpay' : 'cod',
      );
      await _cartRepository.clearCart(userId);
      emit(state.copyWith(orderStatus: OrderPlacementStatus.success));
      return order;
    } catch (_) {
      emit(state.copyWith(orderStatus: OrderPlacementStatus.failure));
      return null;
    }
  }

  void reset() => emit(const CheckoutState());
}
