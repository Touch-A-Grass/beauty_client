import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/screens/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => context.maybePop()),
              title: Text(state.venue?.name ?? 'Корзина'),
            ),
            body: CustomScrollView(slivers: []),
          ),
    );
  }
}
