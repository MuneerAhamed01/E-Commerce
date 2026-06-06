import 'package:flutter/material.dart';

/// Placeholder checkout page.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static const routeName = '/checkout';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Checkout')),
    );
  }
}
