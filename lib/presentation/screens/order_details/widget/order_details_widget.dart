import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/order_review.dart';
import 'package:beauty_client/features/chat/presentation/components/chat_button.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_back_button.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/components/message_listener.dart';
import 'package:beauty_client/presentation/components/rating_view.dart';
import 'package:beauty_client/presentation/components/service_info_widget.dart';
import 'package:beauty_client/presentation/components/staff_info_widget.dart';
import 'package:beauty_client/presentation/models/order_status.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/order_details/bloc/order_details_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:beauty_client/presentation/util/phone_formatter.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'order_info.dart';
part 'order_info_item.dart';
part 'order_master_info.dart';
part 'order_rating_view.dart';
part 'order_time_info.dart';
part 'order_venue_info.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({super.key});

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MessageListener(
      onMessage: (_) => context.read<OrderDetailsBloc>().add(OrderDetailsEvent.orderRequested()),
      child: BlocSingleChangeListener<OrderDetailsBloc, OrderDetailsState>(
        map: (state) => state.loadingOrderError,
        listener: (context, state) => context.showErrorSnackBar(state.loadingOrderError!),
        child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
          builder:
              (context, state) => Scaffold(
                appBar: AppBar(
                  title: Text(S.of(context).orderDetailsTitle),
                  leading: AppBackButton(),
                  actions: [
                    if (state.order != null)
                      ChatButton(
                        unreadCount: state.order?.unreadMessageCount ?? 0,
                        onPressed: () {
                          context.pushRoute(OrderChatRoute(orderId: state.order!.id));
                        },
                      ),
                  ],
                ),
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
                                    controller: scrollController,
                                    slivers: [
                                      SliverSafeArea(
                                        top: false,
                                        sliver: SliverPadding(
                                          padding: EdgeInsets.all(16),
                                          sliver: SliverMainAxisGroup(
                                            slivers: [
                                              SliverToBoxAdapter(child: _OrderVenueInfo(order: order)),
                                              SliverPadding(
                                                padding: const EdgeInsets.only(top: 32),
                                                sliver: SliverToBoxAdapter(
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.surfaceContainer,
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    child: DividerTheme(
                                                      data: Theme.of(
                                                        context,
                                                      ).dividerTheme.copyWith(endIndent: 0, indent: 0, space: 32),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          _OrderInfoItem(
                                                            Text(S.of(context).cartService),
                                                            Text(order.service.name),
                                                          ),
                                                          Divider(),
                                                          _OrderInfoItem(
                                                            Text(S.of(context).cartMaster),
                                                            Text(order.staff.name),
                                                          ),
                                                          Divider(),
                                                          if (order.status == OrderStatus.discarded &&
                                                              order.comment.isNotEmpty) ...[
                                                            _OrderInfoItem(
                                                              Text(S.of(context).orderCancelReasonTitle),
                                                              Expanded(
                                                                child: Text(order.comment, textAlign: TextAlign.end),
                                                              ),
                                                            ),
                                                            Divider(),
                                                          ],
                                                          _OrderTimeInfo(order: order),
                                                          if (order.service.duration != null) ...[
                                                            Divider(),
                                                            _OrderInfoItem(
                                                              Text(S.of(context).serviceDuration),
                                                              Text('~ ${order.service.duration!.inMinutes} мин.'),
                                                            ),
                                                          ],
                                                          if (order.service.price != null) ...[
                                                            Divider(),
                                                            _OrderInfoItem(
                                                              Text(
                                                                S.of(context).orderPrice,
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                order.service.price!.toPriceFormat(),
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ],
                                                          Divider(),
                                                          _OrderInfoItem(
                                                            Text(
                                                              S.of(context).orderStatus,
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(
                                                              order.status.statusName(context),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: order.status.color(),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (order.canBeRated)
                                                SliverPadding(
                                                  padding: const EdgeInsets.only(top: 16),
                                                  sliver: SliverToBoxAdapter(
                                                    child: _OrderNewRatingView(
                                                      (review) => context.read<OrderDetailsBloc>().add(
                                                        OrderDetailsEvent.rateOrderRequested(review),
                                                      ),
                                                      state.ratingState is LoadingOrderRatingState,
                                                    ),
                                                  ),
                                                )
                                              else if (order.review != null)
                                                SliverPadding(
                                                  padding: const EdgeInsets.only(top: 16),
                                                  sliver: SliverToBoxAdapter(child: _OrderRatingView(order.review!)),
                                                ),
                                              SliverPadding(
                                                padding: const EdgeInsets.only(top: 32, left: 48, right: 48),
                                                sliver: SliverToBoxAdapter(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: IconButton(
                                                      iconSize: 32,
                                                      style: ButtonStyle(
                                                        shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                        ),
                                                        backgroundColor: WidgetStatePropertyAll(
                                                          Theme.of(context).colorScheme.surfaceContainer,
                                                        ),
                                                      ),
                                                      onPressed:
                                                          () => showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) => Dialog(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          Theme.of(
                                                                            context,
                                                                          ).colorScheme.surfaceContainer,
                                                                      borderRadius: BorderRadius.circular(16),
                                                                    ),
                                                                    padding: EdgeInsets.all(24),
                                                                    child: QrImageView(
                                                                      data: 'tagbeautymaster://orders/${order.id}',
                                                                    ),
                                                                  ),
                                                                ),
                                                          ),
                                                      icon: Icon(Icons.qr_code_rounded),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                                child: Row(
                                                  spacing: 16,
                                                  children: [
                                                    Expanded(
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
                                                                            title: Text(
                                                                              S.of(context).orderCancelAlertTitle,
                                                                            ),
                                                                            content: Text(
                                                                              S.of(context).orderCancelAlertMessage,
                                                                            ),
                                                                            actionsAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed:
                                                                                    () => Navigator.pop(context, true),
                                                                                child: Text(
                                                                                  S.of(context).orderCancelAlertConfirm,
                                                                                  style: TextStyle(
                                                                                    color:
                                                                                        Theme.of(
                                                                                          context,
                                                                                        ).colorScheme.error,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed:
                                                                                    () => Navigator.pop(context, false),
                                                                                child: Text(
                                                                                  S.of(context).orderCancelAlertCancel,
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
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 48,
                                                        child: FilledButton(
                                                          onPressed: () {},
                                                          child: Text('Перенести запись'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
      ),
    );
  }
}
