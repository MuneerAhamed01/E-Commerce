part of 'product_detail_cubit.dart';

enum ProductDetailStatus { initial, loading, success, failure, notFound }

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.reviews = const [],
    this.selectedVariantIndex,
    this.selectedImageIndex = 0,
    this.quantity = 1,
  });

  final ProductDetailStatus status;
  final Product? product;
  final List<Review> reviews;
  final int? selectedVariantIndex;
  final int selectedImageIndex;
  final int quantity;

  ProductVariant? get selectedVariant {
    if (product == null ||
        product!.variants.isEmpty ||
        selectedVariantIndex == null) {
      return null;
    }
    return product!.variants[selectedVariantIndex!];
  }

  double get effectivePrice {
    final base = product?.effectivePrice ?? 0;
    final delta = selectedVariant?.priceDelta ?? 0;
    return base + delta;
  }

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    List<Review>? reviews,
    int? selectedVariantIndex,
    int? selectedImageIndex,
    int? quantity,
  }) => ProductDetailState(
    status: status ?? this.status,
    product: product ?? this.product,
    reviews: reviews ?? this.reviews,
    selectedVariantIndex: selectedVariantIndex ?? this.selectedVariantIndex,
    selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [
    status,
    product,
    reviews,
    selectedVariantIndex,
    selectedImageIndex,
    quantity,
  ];
}
