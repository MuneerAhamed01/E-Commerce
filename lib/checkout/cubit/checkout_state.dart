part of 'checkout_cubit.dart';

enum AddressStatus { initial, loading, loaded, failure }
enum OrderPlacementStatus { idle, loading, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.addressStatus = AddressStatus.initial,
    this.orderStatus = OrderPlacementStatus.idle,
    this.addresses = const [],
    this.selectedAddress,
  });

  final AddressStatus addressStatus;
  final OrderPlacementStatus orderStatus;
  final List<Address> addresses;
  final Address? selectedAddress;

  CheckoutState copyWith({
    AddressStatus? addressStatus,
    OrderPlacementStatus? orderStatus,
    List<Address>? addresses,
    Address? selectedAddress,
  }) => CheckoutState(
    addressStatus: addressStatus ?? this.addressStatus,
    orderStatus: orderStatus ?? this.orderStatus,
    addresses: addresses ?? this.addresses,
    selectedAddress: selectedAddress ?? this.selectedAddress,
  );

  @override
  List<Object?> get props => [
    addressStatus,
    orderStatus,
    addresses,
    selectedAddress,
  ];
}
