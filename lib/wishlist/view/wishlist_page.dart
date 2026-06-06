import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/wishlist/cubit/wishlist_cubit.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static const routeName = '/wishlist';

  @override
  Widget build(BuildContext context) {
    return const _WishlistView();
  }
}

class _WishlistView extends StatefulWidget {
  const _WishlistView();

  @override
  State<_WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<_WishlistView> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AppBloc>().state.user?.id;
    if (userId != null) {
      context.read<WishlistCubit>().loadWishlist(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TrendsAppBar(title: 'Wishlist'),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.status == WishlistStatus.loading) {
            return const Center(child: TrendsLoader());
          }
          if (state.products.isEmpty) {
            return TrendsEmptyState(
              title: 'Nothing saved yet',
              subtitle:
                  'Tap the heart on any product to save it here.',
              icon: Icons.favorite_border,
              action: TrendsButton(
                label: 'Browse products',
                expand: false,
                onPressed: () => context.go(AppRoutes.home),
              ),
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
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
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
