import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';
import 'package:trends/home/cubit/home_cubit.dart';
import 'package:trends/home/view/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        productRepository: context.read<ProductRepository>(),
      ),
      child: const HomeView(),
    );
  }
}
