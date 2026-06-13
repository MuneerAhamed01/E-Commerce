import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/catalog/bloc/catalog_cubit.dart';
import 'package:trends/core/errors/trends_error_handler.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({
    required this.categoryId,
    this.title,
    super.key,
  });

  final String categoryId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogCubit(
        productRepository: context.read<ProductRepository>(),
      )..loadCategory(categoryId: categoryId),
      child: CatalogView(categoryId: categoryId, title: title),
    );
  }
}

class CatalogView extends StatelessWidget {
  const CatalogView({
    required this.categoryId,
    this.title,
    super.key,
  });

  final String categoryId;
  final String? title;

  static const _sortOptions = {
    'featured': 'Featured',
    'price_asc': 'Price: Low to High',
    'price_desc': 'Price: High to Low',
    'rating': 'Top Rated',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrendsAppBar(
        title: title ?? 'Catalog',
        actions: [
          BlocBuilder<CatalogCubit, CatalogState>(
            builder: (context, state) => PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              tooltip: 'Sort',
              onSelected: context.read<CatalogCubit>().changeSort,
              itemBuilder: (_) => _sortOptions.entries
                  .map(
                    (e) => PopupMenuItem(
                      value: e.key,
                      child: Row(
                        children: [
                          if (state.sortBy == e.key)
                            const Icon(Icons.check, size: 18)
                          else
                            const SizedBox(width: 18),
                          const SizedBox(width: 8),
                          Text(e.value),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state.status == CatalogStatus.loading) {
            return const Center(child: TrendsLoader());
          }
          if (state.status == CatalogStatus.failure) {
            return TrendsErrorView(
              message: 'Could not load products.',
              onRetry: () => context.read<CatalogCubit>().loadCategory(
                categoryId: categoryId,
              ),
              onContactSupport: () =>
                  TrendsErrorHandler.showContactSupport(context),
            );
          }
          if (state.products.isEmpty) {
            return const TrendsEmptyState(
              title: 'No products yet',
              subtitle: 'Check back soon for new arrivals.',
              icon: Icons.inventory_2_outlined,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: TrendsSpacing.gutterMobile,
                mainAxisSpacing: TrendsSpacing.gutterMobile,
                childAspectRatio: 0.6,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(
                  name: product.name,
                  price: _formatPrice(product.price, product.currency),
                  salePrice: product.isOnSale
                      ? _formatPrice(
                          product.effectivePrice,
                          product.currency,
                        )
                      : null,
                  imageUrl: product.primaryImage,
                  onTap: () => context.push(
                    '${AppRoutes.productDetail}/${product.id}',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatPrice(double price, String currency) {
    if (currency == 'INR') return '₹${price.toStringAsFixed(0)}';
    return price.toStringAsFixed(2);
  }
}
