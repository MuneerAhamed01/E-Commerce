part of 'orders_cubit.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
  });

  final OrdersStatus status;
  final List<Order> orders;

  OrdersState copyWith({OrdersStatus? status, List<Order>? orders}) =>
      OrdersState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
      );

  @override
  List<Object?> get props => [status, orders];
}
