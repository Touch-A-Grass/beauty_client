import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/cart/bloc/cart_bloc.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_service_dialog.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_staff_dialog.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/service_list_item.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/staff_list_item.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      builder:
          (childContext) => SelectServiceDialog(
            services: context.read<CartBloc>().state.services ?? [],
            selectedStaff: context.read<CartBloc>().state.selectedStaff,
          ),
    );
    if (context.mounted && service != null) {
      context.read<CartBloc>().add(CartEvent.serviceSelected(service));
    }
  }

  void selectStaff(BuildContext context) async {
    final staff = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (childContext) => SelectStaffDialog(
            staff: context.read<CartBloc>().state.staffs ?? [],
            selectedService: context.read<CartBloc>().state.selectedService,
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
            (context, state) => Scaffold(
              appBar: AppBar(
                leading: BackButton(onPressed: () => context.maybePop()),
                title: Text(S.of(context).cartTitle),
              ),
              body:
                  state.venue == null || state.services == null || state.staffs == null || state.isCreatingOrder
                      ? const Center(child: CircularProgressIndicator())
                      : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            sliver: SliverMainAxisGroup(
                              slivers: [
                                SliverToBoxAdapter(child: VenueListItem(venue: state.venue!, showBorder: false)),
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
                                          ServiceListItem(
                                            service: state.selectedService!,
                                            onTap: () => selectService(context),
                                          )
                                        else
                                          ServiceListItemPlaceholder(onTap: () => selectService(context)),
                                        const SizedBox(height: 32),
                                        Text(
                                          S.of(context).cartMaster,
                                          style: Theme.of(context).textTheme.headlineSmall,
                                        ),
                                        const SizedBox(height: 16),
                                        if (state.selectedStaff != null)
                                          StaffListItem(staff: state.selectedStaff!, onTap: () => selectStaff(context))
                                        else
                                          StaffListItemPlaceholder(onTap: () => selectStaff(context)),
                                        const SizedBox(height: 32),
                                        Text(
                                          S.of(context).cartServiceTime,
                                          style: Theme.of(context).textTheme.headlineSmall,
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          height: 48,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                                initialDate: state.date,
                                              );
                                              if (!context.mounted || date == null) return;
                                              final time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (!context.mounted || time == null) return;
                                              final dateWithTime = date.copyWith(hour: time.hour, minute: time.minute);
                                              context.read<CartBloc>().add(CartEvent.dateChanged(dateWithTime));
                                            },
                                            child: Text(
                                              state.date != null
                                                  ? dateFormat.format(state.date!)
                                                  : S.of(context).cartDatePlaceholder,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        TextFormField(
                                          focusNode: commentFocus,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(16) +
                                    EdgeInsets.only(bottom: 16 + MediaQuery.of(context).padding.bottom),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
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
    );
  }
}
