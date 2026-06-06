import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/cart/bloc/cart_bloc.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    TrendsBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    TrendsBottomNavItem(icon: Icons.category_outlined, label: 'Categories'),
    TrendsBottomNavItem(icon: Icons.shopping_bag_outlined, label: 'Cart'),
    TrendsBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Orders'),
    TrendsBottomNavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          return TrendsBottomNav(
            currentIndex: navigationShell.currentIndex,
            items: _items,
            onTap: navigationShell.goBranch,
            cartBadgeCount: cartState.cart.itemCount,
          );
        },
      ),
    );
  }
}
