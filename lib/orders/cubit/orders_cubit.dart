import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/order_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required OrderRepository orderRepository})
    : _orderRepository = orderRepository,
      super(const OrdersState());

  final OrderRepository _orderRepository;
  StreamSubscription<List<Order>>? _subscription;

  Future<void> loadOrders(String userId) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    await _subscription?.cancel();
    _subscription = _orderRepository.watchOrders(userId).listen(
      (orders) => emit(
        state.copyWith(status: OrdersStatus.success, orders: orders),
      ),
      onError: (_) => emit(state.copyWith(status: OrdersStatus.failure)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
