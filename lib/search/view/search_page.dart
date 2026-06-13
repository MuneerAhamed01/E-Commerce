import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/core/errors/trends_error_handler.dart';
import 'package:trends/search/cubit/search_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        productRepository: context.read(),
      ),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: TrendsSearchField(
          controller: _controller,
          hint: 'Search shirts, sarees, kurtis…',
          onChanged: (query) => context.read<SearchCubit>().search(query),
          onClear: () {
            _controller.clear();
            context.read<SearchCubit>().clear();
          },
        ),
        titleSpacing: 0,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.initial) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: TrendsColors.outlineVariant,
                  ),
                  SizedBox(height: TrendsSpacing.md),
                  Text(
                    'Search for products',
                    style: TextStyle(color: TrendsColors.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }
          if (state.status == SearchStatus.loading) {
            return const Center(child: TrendsLoader());
          }
          if (state.status == SearchStatus.failure) {
            return TrendsErrorView(
              message: 'Search failed. Try again.',
              onRetry: () => context.read<SearchCubit>().search(state.query),
              onContactSupport: () =>
                  TrendsErrorHandler.showContactSupport(context),
            );
          }
          if (state.results.isEmpty) {
            return TrendsEmptyState(
              title: 'No results for "${state.query}"',
              subtitle: 'Try a different search term.',
              icon: Icons.search_off_outlined,
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: TrendsSpacing.gutterMobile,
              mainAxisSpacing: TrendsSpacing.gutterMobile,
              childAspectRatio: 0.6,
            ),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final product = state.results[index];
              return ProductCard(
                name: product.name,
                price: '₹${product.price.toStringAsFixed(0)}',
                salePrice: product.isOnSale
                    ? '₹${product.effectivePrice.toStringAsFixed(0)}'
                    : null,
                imageUrl: product.primaryImage,
                onTap: () => context.push(
                  '${AppRoutes.productDetail}/${product.id}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
