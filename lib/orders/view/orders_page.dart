import 'package:flutter/material.dart';

/// Placeholder orders page.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Orders')),
    );
  }
}
