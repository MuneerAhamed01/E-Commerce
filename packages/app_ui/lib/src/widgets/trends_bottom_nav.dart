import 'package:app_ui/src/theme/trends_colors.dart';
import 'package:flutter/material.dart';

class TrendsBottomNavItem {
  const TrendsBottomNavItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

/// Bottom nav with charcoal dot active indicator — Stitch pattern.
class TrendsBottomNav extends StatelessWidget {
  const TrendsBottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final List<TrendsBottomNavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        for (var i = 0; i < items.length; i++)
          BottomNavigationBarItem(
            icon: _NavIcon(
              icon: items[i].icon,
              isSelected: currentIndex == i,
            ),
            label: items[i].label,
          ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.isSelected});

  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 22,
          color: isSelected
              ? TrendsColors.charcoal
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        if (isSelected) ...[
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: TrendsColors.charcoal,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}
