part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.banners = const [],
    this.categories = const [],
    this.featuredProducts = const [],
    this.newArrivals = const [],
  });

  final HomeStatus status;
  final List<PromoBanner> banners;
  final List<Category> categories;
  final List<Product> featuredProducts;
  final List<Product> newArrivals;

  HomeState copyWith({
    HomeStatus? status,
    List<PromoBanner>? banners,
    List<Category>? categories,
    List<Product>? featuredProducts,
    List<Product>? newArrivals,
  }) => HomeState(
    status: status ?? this.status,
    banners: banners ?? this.banners,
    categories: categories ?? this.categories,
    featuredProducts: featuredProducts ?? this.featuredProducts,
    newArrivals: newArrivals ?? this.newArrivals,
  );

  @override
  List<Object?> get props => [
    status,
    banners,
    categories,
    featuredProducts,
    newArrivals,
  ];
}
