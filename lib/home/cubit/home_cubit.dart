import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const HomeState());

  final ProductRepository _productRepository;

  Future<void> loadHome() async {
    if (state.status == HomeStatus.loading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final results = await Future.wait([
        _productRepository.getBanners(),
        _productRepository.getCategories(),
        _productRepository.getFeaturedProducts(),
        _productRepository.getNewArrivals(),
      ]);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          banners: results[0] as List<PromoBanner>,
          categories: results[1] as List<Category>,
          featuredProducts: results[2] as List<Product>,
          newArrivals: results[3] as List<Product>,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: HomeStatus.initial));
    await loadHome();
  }
}
