part of 'catalog_cubit.dart';

enum CatalogStatus { initial, loading, success, failure }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.categoryId,
    this.products = const [],
    this.sortBy = 'featured',
  });

  final CatalogStatus status;
  final String? categoryId;
  final List<Product> products;
  final String sortBy;

  CatalogState copyWith({
    CatalogStatus? status,
    String? categoryId,
    List<Product>? products,
    String? sortBy,
  }) => CatalogState(
    status: status ?? this.status,
    categoryId: categoryId ?? this.categoryId,
    products: products ?? this.products,
    sortBy: sortBy ?? this.sortBy,
  );

  @override
  List<Object?> get props => [status, categoryId, products, sortBy];
}
