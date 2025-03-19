import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/screens/cart/bloc/cart_bloc.dart';
import 'package:beauty_client/presentation/screens/cart/widget/select_service_dialog.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/service_list_item.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  void selectService(BuildContext context) async {
    final service = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (childContext) => SelectServiceDialog(services: context.read<CartBloc>().state.services ?? []),
    );
    if (context.mounted && service != null) {
      context.read<CartBloc>().add(CartEvent.serviceSelected(service));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => context.maybePop()),
              title: Text(S.of(context).cartTitle),
            ),
            body:
                state.venue == null || state.services == null
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
                                      Text(S.of(context).cartService, style: Theme.of(context).textTheme.headlineSmall),
                                      const SizedBox(height: 16),
                                      if (state.selectedService != null)
                                        ServiceListItem(
                                          service: state.selectedService!,
                                          onTap: () => selectService(context),
                                        )
                                      else
                                        ServiceListItemPlaceholder(onTap: () => selectService(context)),
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
                                child: ElevatedButton(onPressed: () {}, child: Text(S.of(context).cartConfirmButton)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
    );
  }
}
