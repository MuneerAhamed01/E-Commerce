import 'package:app_ui/app_ui.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:trends/checkout/cubit/checkout_cubit.dart';
import 'package:trends/checkout/view/checkout_view.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static const routeName = '/checkout';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(
        orderRepository: context.read<OrderRepository>(),
        cartRepository: context.read<CartRepository>(),
      ),
      child: const Scaffold(
        appBar: TrendsAppBar(title: 'Checkout'),
        body: CheckoutView(),
      ),
    );
  }
}
