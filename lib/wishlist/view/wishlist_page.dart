import 'package:flutter/material.dart';

/// Placeholder wishlist page.
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static const routeName = '/wishlist';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Wishlist')),
    );
  }
}
