import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/app/router/app_router.dart';
import 'package:trends/core/errors/trends_error_handler.dart';
import 'package:trends/home/cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _bannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: context.read<HomeCubit>().refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _SearchBar(colorScheme: colorScheme),
              ),
              if (state.status == HomeStatus.loading)
                const SliverFillRemaining(
                  child: Center(child: TrendsLoader()),
                )
              else if (state.status == HomeStatus.failure)
                SliverFillRemaining(
                  child: TrendsErrorView(
                    message: 'Could not load the store. Pull to retry.',
                    onRetry: context.read<HomeCubit>().refresh,
                    onContactSupport: () =>
                        TrendsErrorHandler.showContactSupport(context),
                  ),
                )
              else ...[
                if (state.banners.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _BannerCarousel(
                      banners: state.banners,
                      currentIndex: _bannerIndex,
                      controller: _bannerController,
                      onPageChanged: (i) =>
                          setState(() => _bannerIndex = i),
                    ),
                  ),
                if (state.categories.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: TrendsSectionHeader(
                      title: 'Shop by category',
                      padding: EdgeInsets.fromLTRB(
                        TrendsSpacing.marginMobile,
                        TrendsSpacing.lg,
                        TrendsSpacing.marginMobile,
                        TrendsSpacing.sm,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _CategoryRow(categories: state.categories),
                  ),
                ],
                if (state.featuredProducts.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: TrendsSectionHeader(
                      title: 'Featured picks',
                      padding: EdgeInsets.fromLTRB(
                        TrendsSpacing.marginMobile,
                        TrendsSpacing.lg,
                        TrendsSpacing.marginMobile,
                        TrendsSpacing.sm,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TrendsSpacing.marginMobile,
                    ),
                    sliver: _ProductGrid(products: state.featuredProducts),
                  ),
                ],
                if (state.newArrivals.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: TrendsSectionHeader(
                      title: 'New arrivals',
                      padding: EdgeInsets.fromLTRB(
                        TrendsSpacing.marginMobile,
                        TrendsSpacing.lg,
                        TrendsSpacing.marginMobile,
                        TrendsSpacing.sm,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      TrendsSpacing.marginMobile,
                      0,
                      TrendsSpacing.marginMobile,
                      TrendsSpacing.xl,
                    ),
                    sliver: _ProductGrid(products: state.newArrivals),
                  ),
                ],
                if (state.status == HomeStatus.success &&
                    state.featuredProducts.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(TrendsSpacing.xl),
                      child: TrendsEmptyState(
                        title: 'Store coming soon',
                        subtitle: 'Products are being loaded.',
                        icon: Icons.store_outlined,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.search),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          TrendsSpacing.marginMobile,
          TrendsSpacing.md,
          TrendsSpacing.marginMobile,
          TrendsSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: TrendsSpacing.md,
          vertical: TrendsSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(TrendsSpacing.sm),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: TrendsSpacing.sm),
            Text(
              'Search shirts, sarees, kurtis…',
              style: TrendsTypography.bodyMedium(
                colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({
    required this.banners,
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
  });

  final List<PromoBanner> banners;
  final int currentIndex;
  final PageController controller;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller,
            itemCount: banners.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return GestureDetector(
                onTap: () {
                  if (banner.actionUrl != null) {
                    context.push(
                      '${AppRoutes.catalog}?categoryId=${banner.actionUrl}',
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TrendsSpacing.marginMobile,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(TrendsSpacing.sm),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: TrendsColors.surfaceContainer,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: TrendsColors.surfaceContainer,
                            child: const Icon(
                              Icons.image_outlined,
                              color: TrendsColors.onSurfaceVariant,
                              size: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(TrendsSpacing.md),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0xCC121212),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  banner.title,
                                  style:
                                      TrendsTypography.headlineSmall(
                                    Colors.white,
                                  ),
                                ),
                                if (banner.subtitle != null)
                                  Text(
                                    banner.subtitle!,
                                    style: TrendsTypography.bodyMedium(
                                      Colors.white70,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: TrendsSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(
                horizontal: TrendsSpacing.xs / 2,
              ),
              width: currentIndex == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: currentIndex == i
                    ? TrendsColors.charcoal
                    : TrendsColors.outlineVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.categories});
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: TrendsSpacing.marginMobile,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: TrendsSpacing.sm),
            child: GestureDetector(
              onTap: () => context.push(
                '${AppRoutes.catalog}?categoryId=${cat.id}&title=${Uri.encodeComponent(cat.title)}',
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TrendsColors.surfaceContainer,
                    ),
                    child: cat.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: cat.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.category_outlined,
                            size: 28,
                            color: TrendsColors.onSurfaceVariant,
                          ),
                  ),
                  const SizedBox(height: TrendsSpacing.xs),
                  SizedBox(
                    width: 64,
                    child: Text(
                      cat.title,
                      style: TrendsTypography.labelSmall(
                        TrendsColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: TrendsSpacing.gutterMobile,
        mainAxisSpacing: TrendsSpacing.gutterMobile,
        childAspectRatio: 0.6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return ProductCard(
            name: product.name,
            price: _formatPrice(product.price, product.currency),
            salePrice: product.isOnSale
                ? _formatPrice(product.effectivePrice, product.currency)
                : null,
            imageUrl: product.primaryImage,
            onTap: () => context.push(
              '${AppRoutes.productDetail}/${product.id}',
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }

  String _formatPrice(double price, String currency) {
    if (currency == 'INR') return '₹${price.toStringAsFixed(0)}';
    return price.toStringAsFixed(2);
  }
}
