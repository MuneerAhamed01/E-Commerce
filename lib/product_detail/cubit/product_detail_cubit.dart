import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductDetailState());

  final ProductRepository _productRepository;

  Future<void> loadProduct(String productId) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    try {
      final results = await Future.wait([
        _productRepository.getProduct(productId),
        _productRepository.getProductReviews(productId),
      ]);
      final product = results[0] as Product?;
      if (product == null) {
        emit(state.copyWith(status: ProductDetailStatus.notFound));
        return;
      }
      emit(
        state.copyWith(
          status: ProductDetailStatus.success,
          product: product,
          reviews: (results[1] as List<dynamic>).cast<Review>(),
          selectedVariantIndex: product.variants.isNotEmpty ? 0 : null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProductDetailStatus.failure));
    }
  }

  void selectVariant(int index) {
    emit(state.copyWith(selectedVariantIndex: index));
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }

  void setQuantity(int quantity) {
    if (quantity < 1) return;
    emit(state.copyWith(quantity: quantity));
  }
}
