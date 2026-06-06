import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/app/router/app_router.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final cats = await context.read<ProductRepository>().getCategories();
      if (mounted) setState(() { _categories = cats; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TrendsAppBar(title: 'Categories'),
      body: _loading
          ? const Center(child: TrendsLoader())
          : _categories.isEmpty
              ? const TrendsEmptyState(
                  title: 'No categories',
                  icon: Icons.category_outlined,
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: TrendsSpacing.gutterMobile,
                    mainAxisSpacing: TrendsSpacing.gutterMobile,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return GestureDetector(
                      onTap: () => context.push(
                        '${AppRoutes.catalog}?categoryId=${cat.id}&title=${Uri.encodeComponent(cat.title)}',
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          TrendsSpacing.sm,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (cat.imageUrl != null)
                              CachedNetworkImage(
                                imageUrl: cat.imageUrl!,
                                fit: BoxFit.cover,
                              placeholder: (_, _x) => const ColoredBox(
                                  color: TrendsColors.surfaceContainer,
                                ),
                                errorWidget: (_, _x, _e) => const ColoredBox(
                                  color: TrendsColors.surfaceContainer,
                                ),
                              )
                            else
                              const ColoredBox(
                                color: TrendsColors.surfaceContainer,
                              ),
                            DecoratedBox(
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
                            ),
                            Positioned(
                              bottom: TrendsSpacing.sm,
                              left: TrendsSpacing.sm,
                              right: TrendsSpacing.sm,
                              child: Text(
                                cat.title,
                                style: TrendsTypography.labelMedium(
                                  Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
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
