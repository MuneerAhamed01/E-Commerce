import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:app_ui/src/theme/trends_radius.dart';
import 'package:app_ui/src/theme/trends_spacing.dart';
import 'package:app_ui/src/theme/trends_theme_extension.dart';
import 'package:app_ui/src/theme/trends_typography.dart';
import 'package:app_ui/src/widgets/category_chip.dart';
import 'package:app_ui/src/widgets/product_card.dart';
import 'package:app_ui/src/widgets/trends_app_bar.dart';
import 'package:app_ui/src/widgets/trends_badge.dart';
import 'package:app_ui/src/widgets/trends_bottom_nav.dart';
import 'package:app_ui/src/widgets/trends_button.dart';
import 'package:app_ui/src/widgets/trends_empty_state.dart';
import 'package:app_ui/src/widgets/trends_error_view.dart';
import 'package:app_ui/src/widgets/trends_loader.dart';
import 'package:app_ui/src/widgets/trends_search_field.dart';
import 'package:app_ui/src/widgets/trends_section_header.dart';
import 'package:app_ui/src/widgets/trends_text_field.dart';
import 'package:flutter/material.dart';

/// Design system gallery — previews all Aura Couture tokens and widgets.
class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  var _selectedChip = 0;
  var _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trends = context.trendsTheme;

    return Scaffold(
      appBar: const TrendsAppBar(title: 'Design System'),
      body: ListView(
        padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
        children: [
          _Section(
            title: 'Brand',
            child: Text(
              'Aura Couture — Minimalist luxury for Trends',
              style: TrendsTypography.bodyLarge(
                colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const _Section(
            title: 'Color palette',
            child: Wrap(
              spacing: TrendsSpacing.sm,
              runSpacing: TrendsSpacing.sm,
              children: [
                _ColorSwatch('Charcoal', TrendsColors.charcoal),
                _ColorSwatch('Gold', TrendsColors.gold),
                _ColorSwatch('Background', TrendsColors.background),
                _ColorSwatch('Surface', TrendsColors.surfaceContainerLowest),
                _ColorSwatch('On Surface', TrendsColors.onSurface),
                _ColorSwatch('Outline', TrendsColors.outlineVariant),
                _ColorSwatch('Error', TrendsColors.error),
              ],
            ),
          ),
          _Section(
            title: 'Typography',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Display',
                  style: TrendsTypography.displayLarge(colorScheme.onSurface),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                Text(
                  'Headline Large',
                  style: TrendsTypography.headlineLarge(colorScheme.onSurface),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                Text(
                  'Headline Medium',
                  style: TrendsTypography.headlineMedium(colorScheme.onSurface),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                Text(
                  'Body — editorial clarity for product descriptions.',
                  style: TrendsTypography.bodyMedium(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: TrendsSpacing.sm),
                Text(
                  'LABEL CAPS',
                  style: TrendsTypography.labelCaps(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Spacing & radius',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Margin ${trends.marginMobile}px · Gutter '
                  '${trends.gutterMobile}px',
                  style: TrendsTypography.labelSmall(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: TrendsSpacing.md),
                Row(
                  children: [
                    _RadiusSample('12', trends.radiusStandard),
                    const SizedBox(width: TrendsSpacing.md),
                    _RadiusSample('16', trends.radiusCard),
                    const SizedBox(width: TrendsSpacing.md),
                    _RadiusSample('24', trends.radiusHero),
                  ],
                ),
              ],
            ),
          ),
          _Section(
            title: 'Buttons',
            child: Column(
              children: [
                TrendsButton(label: 'Add to bag', onPressed: () {}),
                const SizedBox(height: TrendsSpacing.md),
                TrendsButton(
                  label: 'View collection',
                  variant: TrendsButtonVariant.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const _Section(
            title: 'Badges',
            child: Wrap(
              spacing: TrendsSpacing.sm,
              runSpacing: TrendsSpacing.sm,
              children: [
                TrendsBadge(label: 'New'),
                TrendsBadge(
                  label: 'Sale',
                  variant: TrendsBadgeVariant.charcoal,
                ),
                TrendsBadge(
                  label: 'Limited',
                  variant: TrendsBadgeVariant.neutral,
                ),
              ],
            ),
          ),
          _Section(
            title: 'Category chips',
            child: Wrap(
              spacing: TrendsSpacing.sm,
              children: [
                for (var i = 0; i < 4; i++)
                  CategoryChip(
                    label: ['All', 'Men', 'Women', 'Accessories'][i],
                    selected: _selectedChip == i,
                    onSelected: (_) => setState(() => _selectedChip = i),
                  ),
              ],
            ),
          ),
          const _Section(
            title: 'Search & inputs',
            child: Column(
              children: [
                TrendsSearchField(),
                SizedBox(height: TrendsSpacing.md),
                TrendsTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                ),
              ],
            ),
          ),
          _Section(
            title: 'Section header',
            child: TrendsSectionHeader(
              title: 'New arrivals',
              actionLabel: 'See all',
              onActionTap: () {},
            ),
          ),
          const _Section(
            title: 'Product card',
            child: Row(
              children: [
                Expanded(
                  child: ProductCard(
                    name: 'Classic Linen Shirt',
                    price: '₹2,499',
                    salePrice: '₹1,999',
                  ),
                ),
                SizedBox(width: TrendsSpacing.md),
                Expanded(
                  child: ProductCard(
                    name: 'Tailored Wool Blazer',
                    price: '₹8,499',
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Feedback states',
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                  child: TrendsLoader(message: 'Loading collection…'),
                ),
                const SizedBox(height: TrendsSpacing.md),
                SizedBox(
                  height: 120,
                  child: TrendsErrorView(
                    message: 'Could not load products.',
                    onRetry: () {},
                  ),
                ),
                const SizedBox(height: TrendsSpacing.md),
                SizedBox(
                  height: 160,
                  child: TrendsEmptyState(
                    title: 'Your bag is empty',
                    subtitle: 'Discover pieces curated for you.',
                    icon: Icons.shopping_bag_outlined,
                    action: TrendsButton(
                      label: 'Start shopping',
                      onPressed: () {},
                      expand: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Bottom navigation',
            child: TrendsBottomNav(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
              items: const [
                TrendsBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
                TrendsBottomNavItem(
                  icon: Icons.search,
                  label: 'Search',
                ),
                TrendsBottomNavItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Bag',
                ),
                TrendsBottomNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                ),
              ],
            ),
          ),
          const SizedBox(height: TrendsSpacing.section),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TrendsSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TrendsTypography.labelCaps(
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: TrendsSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: TrendsRadius.standardBorder,
            border: Border.all(color: TrendsColors.outlineVariant),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TrendsTypography.labelSmall(TrendsColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _RadiusSample extends StatelessWidget {
  const _RadiusSample(this.label, this.radius);

  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: TrendsColors.surfaceContainer,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: TrendsColors.outlineVariant),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${label}px',
          style: TrendsTypography.labelSmall(TrendsColors.onSurfaceVariant),
        ),
      ],
    );
  }
}
