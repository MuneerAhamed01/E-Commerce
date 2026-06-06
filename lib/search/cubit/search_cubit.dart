import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const SearchState());

  final ProductRepository _productRepository;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }
    emit(state.copyWith(status: SearchStatus.loading, query: query));
    try {
      final results = await _productRepository.searchProducts(query);
      emit(
        state.copyWith(
          status: SearchStatus.success,
          results: results,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  void clear() => emit(const SearchState());
}
