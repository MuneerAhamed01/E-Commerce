import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:trends/cart/view/cart_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TrendsAppBar(title: 'My Cart'),
      body: CartView(),
    );
  }
}
