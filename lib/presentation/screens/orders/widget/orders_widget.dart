import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/orders/bloc/orders_bloc.dart';
import 'package:beauty_client/presentation/screens/orders/widget/order_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(title: Text(S.of(context).orders)),
            body: Builder(
              builder: (context) {
                if (state.orders.data.isEmpty && state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.orders.data.isEmpty && !state.isLoading) {
                  return Center(child: Text(S.of(context).noOrders, style: Theme.of(context).textTheme.titleMedium));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  itemCount: state.orders.data.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder:
                      (context, index) => OrderListItem(
                        order: state.orders.data[index],
                        onTap: () {
                          context.pushRoute(OrderDetailsRoute(orderId: state.orders.data[index].id));
                        },
                      ),
                );
              },
            ),
          ),
    );
  }
}
