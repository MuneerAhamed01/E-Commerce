import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/cart/bloc/cart_bloc.dart';
import 'package:trends/product_detail/cubit/product_detail_cubit.dart';
import 'package:trends/wishlist/cubit/wishlist_cubit.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailCubit(
        productRepository: context.read<ProductRepository>(),
      )..loadProduct(productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  final PageController _imagePageController = PageController();

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        if (state.status == ProductDetailStatus.loading) {
          return const Scaffold(
            body: Center(child: TrendsLoader()),
          );
        }

        if (state.status == ProductDetailStatus.notFound ||
            state.product == null) {
          return Scaffold(
            appBar: const TrendsAppBar(title: 'Product'),
            body: const TrendsEmptyState(
              title: 'Product not found',
              icon: Icons.inventory_2_outlined,
            ),
          );
        }

        if (state.status == ProductDetailStatus.failure) {
          return Scaffold(
            appBar: const TrendsAppBar(title: ''),
            body: TrendsErrorView(
              message: 'Could not load product.',
              onRetry: () => context.read<ProductDetailCubit>().loadProduct(
                state.product?.id ?? '',
              ),
            ),
          );
        }

        return _ProductDetailContent(
          state: state,
          imagePageController: _imagePageController,
        );
      },
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({
    required this.state,
    required this.imagePageController,
  });

  final ProductDetailState state;
  final PageController imagePageController;

  @override
  Widget build(BuildContext context) {
    final product = state.product!;
    final colorScheme = Theme.of(context).colorScheme;
    final userId = context.read<AppBloc>().state.user?.id;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _ImageGalleryAppBar(
            product: product,
            state: state,
            imagePageController: imagePageController,
            userId: userId,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Brand + name
                Text(
                  product.brandName,
                  style: TrendsTypography.labelCaps(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: TrendsSpacing.xs),
                Text(
                  product.name,
                  style: TrendsTypography.headlineMedium(
                    colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                // Price
                Row(
                  children: [
                    Text(
                      '₹${state.effectivePrice.toStringAsFixed(0)}',
                      style: TrendsTypography.headlineSmall(
                        colorScheme.primary,
                      ),
                    ),
                    if (product.isOnSale) ...[
                      const SizedBox(width: TrendsSpacing.sm),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style:
                            TrendsTypography.bodyMedium(
                          colorScheme.onSurfaceVariant,
                        ).copyWith(decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: TrendsSpacing.xs),
                      TrendsBadge(
                        label: '-${_discountPct(product)}%',
                        backgroundColor: Colors.green.shade50,
                        foregroundColor: Colors.green.shade800,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: TrendsSpacing.xs),
                // Rating
                if (product.reviewCount > 0)
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: TrendsColors.gold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating.toStringAsFixed(1)} '
                        '(${product.reviewCount} reviews)',
                        style: TrendsTypography.labelSmall(
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: TrendsSpacing.lg),
                // Variants
                if (product.variants.isNotEmpty) ...[
                  _VariantSelector(state: state),
                  const SizedBox(height: TrendsSpacing.lg),
                ],
                // Quantity
                _QuantitySelector(quantity: state.quantity),
                const SizedBox(height: TrendsSpacing.lg),
                // Description
                const Divider(),
                const SizedBox(height: TrendsSpacing.md),
                Text(
                  'About this item',
                  style: TrendsTypography.labelMedium(
                    colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                Text(
                  product.description,
                  style: TrendsTypography.bodyMedium(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
                // Reviews
                if (state.reviews.isNotEmpty) ...[
                  const SizedBox(height: TrendsSpacing.lg),
                  const Divider(),
                  _ReviewsSection(reviews: state.reviews),
                ],
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(
        state: state,
        userId: userId,
      ),
    );
  }

  int _discountPct(Product product) {
    if (!product.isOnSale) return 0;
    return (((product.price - product.salePrice!) / product.price) * 100)
        .round();
  }
}

class _ImageGalleryAppBar extends StatelessWidget {
  const _ImageGalleryAppBar({
    required this.product,
    required this.state,
    required this.imagePageController,
    this.userId,
  });

  final Product product;
  final ProductDetailState state;
  final PageController imagePageController;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final images = product.images;
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: TrendsColors.surfaceContainerLowest,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (userId != null)
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, wishState) {
              final isLiked = context
                  .read<WishlistCubit>()
                  .isWishlisted(product.id);
              return IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: () => context.read<WishlistCubit>().toggleWishlist(
                  userId: userId!,
                  product: product,
                ),
              );
            },
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: images.isEmpty
            ? const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: TrendsColors.onSurfaceVariant,
                ),
              )
            : Stack(
                children: [
                  PageView.builder(
                    controller: imagePageController,
                    itemCount: images.length,
                    onPageChanged: context
                        .read<ProductDetailCubit>()
                        .selectImage,
                    itemBuilder: (context, index) => CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const ColoredBox(
                        color: TrendsColors.surfaceContainer,
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: TrendsColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: TrendsSpacing.sm,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: state.selectedImageIndex == i ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: state.selectedImageIndex == i
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _VariantSelector extends StatelessWidget {
  const _VariantSelector({required this.state});
  final ProductDetailState state;

  @override
  Widget build(BuildContext context) {
    final product = state.product!;
    final colorScheme = Theme.of(context).colorScheme;

    final sizes = product.variants.map((v) => v.size).toSet().toList();
    final colors = product.variants.map((v) => v.color).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sizes.any((s) => s.isNotEmpty)) ...[
          Text('Size', style: TrendsTypography.labelMedium(colorScheme.onSurface)),
          const SizedBox(height: TrendsSpacing.sm),
          Wrap(
            spacing: TrendsSpacing.sm,
            children: sizes
                .where((s) => s.isNotEmpty)
                .map(
                  (size) {
                    final isSelected = state.selectedVariant?.size == size;
                    return GestureDetector(
                      onTap: () {
                        final idx = product.variants.indexWhere(
                          (v) => v.size == size,
                        );
                        if (idx != -1) {
                          context.read<ProductDetailCubit>().selectVariant(idx);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TrendsSpacing.md,
                          vertical: TrendsSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? TrendsColors.charcoal
                                : TrendsColors.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            TrendsSpacing.xs,
                          ),
                        ),
                        child: Text(
                          size,
                          style: TrendsTypography.labelSmall(
                            isSelected
                                ? TrendsColors.charcoal
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                )
                .toList(),
          ),
          const SizedBox(height: TrendsSpacing.md),
        ],
        if (colors.any((c) => c.isNotEmpty)) ...[
          Text(
            'Colour',
            style: TrendsTypography.labelMedium(colorScheme.onSurface),
          ),
          const SizedBox(height: TrendsSpacing.sm),
          Wrap(
            spacing: TrendsSpacing.sm,
            children: colors
                .where((c) => c.isNotEmpty)
                .map(
                  (color) {
                    final isSelected = state.selectedVariant?.color == color;
                    return FilterChip(
                      label: Text(color),
                      selected: isSelected,
                      onSelected: (_) {
                        final idx = product.variants.indexWhere(
                          (v) => v.color == color,
                        );
                        if (idx != -1) {
                          context.read<ProductDetailCubit>().selectVariant(idx);
                        }
                      },
                    );
                  },
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.quantity});
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          'Quantity',
          style: TrendsTypography.labelMedium(colorScheme.onSurface),
        ),
        const Spacer(),
        IconButton(
          onPressed: () =>
              context.read<ProductDetailCubit>().setQuantity(quantity - 1),
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            side: const BorderSide(color: TrendsColors.outlineVariant),
            shape: const CircleBorder(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TrendsSpacing.md,
          ),
          child: Text(
            '$quantity',
            style: TrendsTypography.headlineSmall(colorScheme.onSurface),
          ),
        ),
        IconButton(
          onPressed: () =>
              context.read<ProductDetailCubit>().setQuantity(quantity + 1),
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: TrendsColors.charcoal,
            foregroundColor: TrendsColors.white,
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews});
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TrendsSpacing.md),
        Text(
          'Reviews',
          style: TrendsTypography.headlineSmall(colorScheme.onSurface),
        ),
        const SizedBox(height: TrendsSpacing.md),
        ...reviews.map(
          (review) => Padding(
            padding: const EdgeInsets.only(bottom: TrendsSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      child: Text(
                        review.userName.isNotEmpty
                            ? review.userName[0].toUpperCase()
                            : 'U',
                        style: TrendsTypography.labelMedium(
                          colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: TrendsSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.userName,
                            style: TrendsTypography.labelMedium(
                              colorScheme.onSurface,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: i < review.rating.floor()
                                    ? TrendsColors.gold
                                    : TrendsColors.outlineVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TrendsSpacing.xs),
                Text(
                  review.title,
                  style: TrendsTypography.labelMedium(colorScheme.onSurface),
                ),
                const SizedBox(height: TrendsSpacing.xs / 2),
                Text(
                  review.body,
                  style:
                      TrendsTypography.bodyMedium(colorScheme.onSurfaceVariant),
                ),
                const Divider(height: TrendsSpacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({required this.state, this.userId});
  final ProductDetailState state;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final product = state.product!;
    final cartBloc = context.read<CartBloc>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
        child: TrendsButton(
          label: 'Add to cart — '
              '₹${(state.effectivePrice * state.quantity).toStringAsFixed(0)}',
          onPressed: userId == null
              ? null
              : () {
                  cartBloc.add(
                    CartItemAdded(
                      productId: product.id,
                      name: product.name,
                      price: state.effectivePrice,
                      imageUrl: product.primaryImage,
                      variantId: state.selectedVariant?.id,
                      variantLabel: state.selectedVariant != null
                          ? '${state.selectedVariant!.size} / ${state.selectedVariant!.color}'
                          : null,
                      quantity: state.quantity,
                    ),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        action: SnackBarAction(
                          label: 'View Cart',
                          onPressed: () => context.go('/cart'),
                        ),
                      ),
                    );
                },
        ),
      ),
    );
  }
}
