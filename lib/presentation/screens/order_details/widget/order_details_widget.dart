import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/models/order_status.dart';
import 'package:beauty_client/presentation/screens/order_details/bloc/order_details_bloc.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:beauty_client/presentation/util/phone_formatter.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

part 'order_info.dart';
part 'order_master_info.dart';
part 'order_time_info.dart';
part 'order_venue_info.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({super.key});

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocSingleChangeListener<OrderDetailsBloc, OrderDetailsState>(
      map: (state) => state.loadingOrderError,
      listener: (context, state) => context.showErrorSnackBar(state.loadingOrderError!),
      child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder:
            (context, state) => Scaffold(
              appBar: AppBar(title: Text(S.of(context).orderDetailsTitle)),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child:
                    state.order == null
                        ? const Center(child: CircularProgressIndicator())
                        : Builder(
                          builder: (context) {
                            final order = state.order!;
                            return Stack(
                              children: [
                                CustomScrollView(
                                  slivers: [
                                    SliverPadding(
                                      padding: EdgeInsets.all(16),
                                      sliver: SliverMainAxisGroup(
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: Column(
                                              spacing: 32,
                                              children: [
                                                _OrderInfo(order: order),
                                                _OrderMasterInfo(order: order),
                                                _OrderTimeInfo(order: order),
                                                _OrderVenueInfo(order: order),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (state.canDiscardOrder)
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SafeArea(
                                            top: false,
                                            child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 48,
                                                child: OutlinedButton(
                                                  onPressed:
                                                      state.discardingState is InitialOrderDiscardingState
                                                          ? () async {
                                                            final result = await showDialog<bool>(
                                                              context: context,
                                                              builder:
                                                                  (context) => AlertDialog(
                                                                    title: Text(S.of(context).orderCancelAlertTitle),
                                                                    content: Text(
                                                                      S.of(context).orderCancelAlertMessage,
                                                                    ),
                                                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () => Navigator.pop(context, false),
                                                                        child: Text(
                                                                          S.of(context).orderCancelAlertCancel,
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, true),
                                                                        child: Text(
                                                                          S.of(context).orderCancelAlertConfirm,
                                                                          style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.error,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            );
                                                            if (context.mounted && result == true) {
                                                              context.read<OrderDetailsBloc>().add(
                                                                const OrderDetailsEvent.discardRequested(),
                                                              );
                                                            }
                                                          }
                                                          : null,
                                                  child: switch (state.discardingState) {
                                                    InitialOrderDiscardingState() => Text(
                                                      S.of(context).orderCancelButton,
                                                    ),
                                                    LoadingOrderDiscardingState() => const Center(
                                                      child: SizedBox.square(
                                                        dimension: 24,
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                    ErrorOrderDiscardingState s => Text(s.error.message),
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (state.isLoadingOrder)
                                  Positioned(
                                    bottom: MediaQuery.of(context).padding.bottom,
                                    left: 0,
                                    right: 0,
                                    child: LinearProgressIndicator(),
                                  ),
                              ],
                            );
                          },
                        ),
              ),
            ),
      ),
    );
  }
}
