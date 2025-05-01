import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/user.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/asset_icon.dart';
import 'package:beauty_client/presentation/components/shimmer_box.dart';
import 'package:beauty_client/presentation/models/loading_state.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:beauty_client/presentation/util/phone_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'loading_widget.dart';
part 'order_widget.dart';
part 'profile_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) => BlocBuilder<DashboardBloc, DashboardState>(
    builder: (context, state) {
      final orderState = state.ordersState;
      final venuesState = state.venuesState;
      final userState = state.userState;

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AssetIcon('assets/icons/beauty_service.svg', color: Theme.of(context).colorScheme.primary, size: 64),
          actions: [
            IconButton(
              onPressed: () {
                context.pushRoute(ProfileRoute());
              },
              icon: Icon(Icons.settings_rounded),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child:
              orderState is ProgressLoadingState ||
                      venuesState is ProgressLoadingState ||
                      userState is ProgressLoadingState
                  ? _UserLoadingSkeleton()
                  : switch (state.userState) {
                    ProgressLoadingState<User>() => _UserLoadingSkeleton(),
                    SuccessLoadingState<User> user => CustomScrollView(
                      slivers: [
                        SliverSafeArea(
                          top: false,
                          sliver: SliverPadding(
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                            sliver: SliverMainAxisGroup(
                              slivers: [
                                SliverToBoxAdapter(child: _ProfileWidget(user: user.data)),
                                if (orderState is SuccessLoadingState<Order?> && orderState.data != null)
                                  SliverPadding(
                                    padding: const EdgeInsets.only(top: 32),
                                    sliver: SliverToBoxAdapter(child: _OrderWidget(orderState.data!)),
                                  ),
                                if (venuesState is SuccessLoadingState<List<Venue>>) ...[
                                  SliverPadding(
                                    padding: const EdgeInsets.only(top: 32),
                                    sliver: SliverToBoxAdapter(
                                      child: Row(
                                        spacing: 16,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              S.of(context).nearestVenuesTitle,
                                              style: Theme.of(context).textTheme.titleLarge,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => context.navigateTo(VenuesRoute()),
                                            child: Text(S.of(context).showAllButton),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.only(top: 16),
                                    sliver: SliverList.separated(
                                      itemBuilder:
                                          (context, index) => VenueListItem(
                                            venue: venuesState.data[index],
                                            onClick:
                                                () => context.pushRoute(
                                                  VenueDetailsRoute(
                                                    venueId: venuesState.data[index].id,
                                                    venue: venuesState.data[index],
                                                  ),
                                                ),
                                          ),
                                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                                      itemCount: venuesState.data.length,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ErrorLoadingState<User> user => Center(child: Text(user.error.message)),
                  },
        ),
      );
    },
  );
}
