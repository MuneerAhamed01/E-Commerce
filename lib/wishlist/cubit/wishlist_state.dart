part of 'wishlist_cubit.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.productIds = const [],
    this.products = const [],
  });

  final WishlistStatus status;
  final List<String> productIds;
  final List<Product> products;

  WishlistState copyWith({
    WishlistStatus? status,
    List<String>? productIds,
    List<Product>? products,
  }) => WishlistState(
    status: status ?? this.status,
    productIds: productIds ?? this.productIds,
    products: products ?? this.products,
  );

  @override
  List<Object?> get props => [status, productIds, products];
}
