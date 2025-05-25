import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_back_button.dart';
import 'package:beauty_client/presentation/components/avatar.dart';
import 'package:beauty_client/presentation/components/coupon_item.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/components/service_info_widget.dart';
import 'package:beauty_client/presentation/components/staff_info_widget.dart';
import 'package:beauty_client/presentation/components/venue_theme_builder.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/cart/bloc/cart_bloc.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_coupon_dialog.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_service_dialog.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_staff_dialog.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_timeslot_sheet.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'service_info.dart';
part 'staff_info.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final dateFormat = DateFormat('dd MMMM, HH:mm');

  void selectService(BuildContext context) async {
    final service = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (childContext) => VenueThemeBuilder(
            venueId: context.read<CartBloc>().state.venue?.id,
            builder:
                (innerContext) => SelectServiceDialog(
                  services: context.read<CartBloc>().state.services ?? [],
                  selectedStaff: context.read<CartBloc>().state.selectedStaff,
                ),
          ),
    );
    if (context.mounted && service != null) {
      context.read<CartBloc>().add(CartEvent.serviceSelected(service));
    }
  }

  void selectCoupon(BuildContext context) async {
    final coupon = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (childContext) => VenueThemeBuilder(
            venueId: context.read<CartBloc>().state.venue?.id,
            builder:
                (innerContext) => SelectCouponDialog(selectedService: context.read<CartBloc>().state.selectedService),
          ),
    );
    if (context.mounted && coupon != null) {
      context.read<CartBloc>().add(CartEvent.couponSelected(coupon));
    }
  }

  void selectStaff(BuildContext context) async {
    final staff = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (childContext) => VenueThemeBuilder(
            venueId: context.read<CartBloc>().state.venue?.id,
            builder:
                (innerContext) => SelectStaffDialog(
                  staff: context.read<CartBloc>().state.staffs ?? [],
                  selectedService: context.read<CartBloc>().state.selectedService,
                ),
          ),
    );
    if (context.mounted && staff != null) {
      context.read<CartBloc>().add(CartEvent.staffSelected(staff));
    }
  }

  final commentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocSingleChangeListener<CartBloc, CartState>(
          map: (state) => state.orderCreatingError,
          listener: (context, state) => context.showErrorSnackBar(state.orderCreatingError!),
        ),
        BlocSingleChangeListener<CartBloc, CartState>(
          map: (state) => state.isOrderCreated,
          identicalCheck: false,
          listener: (context, state) {
            AutoRouter.of(context).pushAndPopUntil(OrdersRoute(), predicate: (route) => false);
          },
        ),
      ],
      child: BlocBuilder<CartBloc, CartState>(
        builder:
            (context, state) => VenueThemeBuilder(
              venueId: state.venue?.id,
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(leading: AppBackButton(), title: Text(S.of(context).cartTitle)),
                    body: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child:
                          state.venue == null || state.services == null || state.staffs == null || state.isCreatingOrder
                              ? const Center(child: CircularProgressIndicator())
                              : CustomScrollView(
                                slivers: [
                                  SliverSafeArea(
                                    top: false,
                                    bottom: false,
                                    sliver: SliverPadding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      sliver: SliverMainAxisGroup(
                                        slivers: [
                                          SliverPadding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            sliver: SliverToBoxAdapter(child: VenueListItem(venue: state.venue!)),
                                          ),
                                          SliverPadding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            sliver: SliverToBoxAdapter(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  const SizedBox(height: 32),
                                                  Text(
                                                    S.of(context).cartService,
                                                    style: Theme.of(context).textTheme.headlineSmall,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  if (state.selectedService != null)
                                                    ServiceInfoWidget(
                                                      service: state.selectedService!,
                                                      onTap: () => selectService(context),
                                                    )
                                                  else
                                                    _ServiceInfoPlaceHolder(onTap: () => selectService(context)),
                                                  const SizedBox(height: 32),
                                                  Text(
                                                    S.of(context).cartMaster,
                                                    style: Theme.of(context).textTheme.headlineSmall,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  if (state.selectedStaff != null)
                                                    StaffInfoWidget(
                                                      staff: state.selectedStaff!,
                                                      onTap: () => selectStaff(context),
                                                    )
                                                  else
                                                    _StaffInfoPlaceHolder(onTap: () => selectStaff(context)),
                                                  const SizedBox(height: 32),
                                                  Text(
                                                    S.of(context).cartServiceTime,
                                                    style: Theme.of(context).textTheme.headlineSmall,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  SizedBox(
                                                    height: 48,
                                                    child: OutlinedButton(
                                                      onPressed: switch (state.timeSlotsState) {
                                                        CartTimeSlotsStateEmpty() ||
                                                        CartTimeSlotsStateLoading() ||
                                                        CartTimeSlotsStateError() => null,
                                                        CartTimeSlotsStateLoaded s => () async {
                                                          final date = await showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor: Colors.transparent,
                                                            useSafeArea: true,
                                                            isScrollControlled: true,
                                                            builder:
                                                                (childContext) => VenueThemeBuilder(
                                                                  venueId: state.venue?.id,
                                                                  builder:
                                                                      (innerContext) => SelectTimeslotSheet(
                                                                        timeSlots: s.timeSlots,
                                                                        service: state.selectedService!,
                                                                      ),
                                                                ),
                                                          );

                                                          if (context.mounted && date != null) {
                                                            context.read<CartBloc>().add(CartEvent.dateChanged(date));
                                                          }
                                                        },
                                                      },
                                                      child: switch (state.timeSlotsState) {
                                                        CartTimeSlotsStateEmpty() => Text(
                                                          S.of(context).cartDatePlaceholder,
                                                        ),
                                                        CartTimeSlotsStateLoading() => Center(
                                                          child: SizedBox.square(
                                                            dimension: 24,
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                        CartTimeSlotsStateLoaded() => Text(
                                                          state.date != null
                                                              ? dateFormat.format(state.date!)
                                                              : S.of(context).cartDatePlaceholder,
                                                        ),
                                                        CartTimeSlotsStateError() => Text(
                                                          S.of(context).cartDatePlaceholder,
                                                        ),
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 32),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          S.of(context).cartCoupon,
                                                          style: Theme.of(context).textTheme.headlineSmall,
                                                        ),
                                                      ),
                                                      if (state.coupon != null)
                                                        IconButton(
                                                          onPressed:
                                                              () => context.read<CartBloc>().add(
                                                                CartEvent.couponRemoved(),
                                                              ),
                                                          icon: const Icon(Icons.delete),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  if (state.coupon != null)
                                                    CouponItem(
                                                      onTap: () => selectCoupon(context),
                                                      coupon: state.coupon!,
                                                    )
                                                  else
                                                    OutlinedButton(
                                                      onPressed: () => selectCoupon(context),
                                                      child: Text(S.of(context).cartAddCoupon),
                                                    ),
                                                  const SizedBox(height: 32),
                                                  if (state.totalPrice != null) ...[
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            S.of(context).cartTotal,
                                                            style: Theme.of(context).textTheme.titleMedium,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${state.totalPrice!} ₽',
                                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 32),
                                                  ],
                                                  TextFormField(
                                                    focusNode: commentFocus,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      labelText: S.of(context).cartComment,
                                                    ),
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    onChanged: (value) {
                                                      context.read<CartBloc>().add(CartEvent.commentChanged(value));
                                                    },
                                                    onTapOutside: (_) => commentFocus.unfocus(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(16) +
                                            EdgeInsets.only(
                                              bottom: 16 + MediaQuery.of(context).padding.bottom,
                                              left: MediaQuery.of(context).padding.left,
                                              right: MediaQuery.of(context).padding.right,
                                            ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 48,
                                          child: FilledButton(
                                            onPressed:
                                                state.selectedService != null &&
                                                        state.selectedStaff != null &&
                                                        state.date != null
                                                    ? () {
                                                      context.read<CartBloc>().add(const CartEvent.createRequested());
                                                    }
                                                    : null,
                                            child: Text(S.of(context).cartConfirmButton),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
            ),
      ),
    );
  }
}
