import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_shadows.dart';
import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:flutter/material.dart';

/// Product card — 3:4 image, title and price below, soft shadow.
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.name,
    required this.price,
    this.salePrice,
    this.imageUrl,
    this.onTap,
    super.key,
  });

  final String name;
  final String price;
  final String? salePrice;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: TrendsRadius.cardBorder,
              boxShadow: TrendsShadows.card,
              color: TrendsColors.surfaceContainerLowest,
            ),
            child: ClipRRect(
              borderRadius: TrendsRadius.cardBorder,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                      )
                    : const _ImagePlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: TrendsSpacing.sm),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TrendsTypography.bodyMedium(TrendsColors.onSurface),
          ),
          const SizedBox(height: TrendsSpacing.xs),
          Row(
            children: [
              if (salePrice != null) ...[
                Text(
                  salePrice!,
                  style: TrendsTypography.labelMedium(TrendsColors.charcoal),
                ),
                const SizedBox(width: TrendsSpacing.sm),
                Text(
                  price,
                  style: TrendsTypography.labelSmall(
                    TrendsColors.onSurfaceVariant,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
              ] else
                Text(
                  price,
                  style: TrendsTypography.labelMedium(TrendsColors.charcoal),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: TrendsColors.surfaceContainer,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: TrendsColors.onSurfaceVariant,
          size: 32,
        ),
      ),
    );
  }
}
