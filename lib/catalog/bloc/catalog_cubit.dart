import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const CatalogState());

  final ProductRepository _productRepository;

  Future<void> loadCategory({
    required String categoryId,
    String? sortBy,
  }) async {
    emit(
      state.copyWith(
        status: CatalogStatus.loading,
        categoryId: categoryId,
        sortBy: sortBy ?? state.sortBy,
        products: [],
      ),
    );
    try {
      final products = await _productRepository.getProductsByCategory(
        categoryId,
        sortBy: sortBy ?? state.sortBy,
      );
      emit(
        state.copyWith(
          status: CatalogStatus.success,
          products: products,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CatalogStatus.failure));
    }
  }

  Future<void> changeSort(String sortBy) async {
    if (state.categoryId == null) return;
    await loadCategory(categoryId: state.categoryId!, sortBy: sortBy);
  }
}
