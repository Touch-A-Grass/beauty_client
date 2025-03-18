import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/components/parallax_flow_delegate.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/venue_details/bloc/venue_details_bloc.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/service_list_item.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

class VenueDetailsWidget extends StatefulWidget {
  const VenueDetailsWidget({super.key});

  @override
  State<VenueDetailsWidget> createState() => _VenueDetailsWidgetState();
}

class _VenueDetailsWidgetState extends State<VenueDetailsWidget> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocSingleChangeListener<VenueDetailsBloc, VenueDetailsState>(
          map: (state) => state.servicesLoadingError,
          listener: (context, state) => context.showErrorSnackBar(state.servicesLoadingError!),
        ),
        BlocSingleChangeListener<VenueDetailsBloc, VenueDetailsState>(
          map: (state) => state.venueLoadingError,
          listener: (context, state) => context.showErrorSnackBar(state.venueLoadingError!),
        ),
      ],
      child: BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
        builder:
            (context, state) => Scaffold(
              appBar: AppBar(title: Text(state.venue?.name ?? ''), forceMaterialTransparency: true),
              body: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        (state.isLoadingServices || state.isLoadingVenue && state.venue == null)
                            ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                            : MultiSliver(
                              children: [
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: AnimatedBuilder(
                                        animation: scrollController,
                                        builder:
                                            (context, _) => Flow(
                                              delegate: ParallaxFlowDelegate(
                                                scrollable: Scrollable.of(context),
                                                itemContext: context,
                                              ),
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: state.venue!.theme.photo,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.venue?.description.isNotEmpty ?? false)
                                  SliverPadding(
                                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                    sliver: SliverToBoxAdapter(
                                      child: Text(
                                        state.venue!.description,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                if (state.services.isNotEmpty)
                                  MultiSliver(
                                    pushPinnedChildren: true,
                                    children: [
                                      SliverPinnedHeader(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text('Услуги', style: Theme.of(context).textTheme.headlineSmall),
                                          ),
                                        ),
                                      ),
                                      SliverSafeArea(
                                        sliver: SliverPadding(
                                          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                                          sliver: SliverList.separated(
                                            itemCount: state.services.length,
                                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                                            itemBuilder:
                                                (context, index) => ServiceListItem(
                                                  service: state.services[index],
                                                  onTap: () {
                                                    context.pushRoute(
                                                      CartRoute(
                                                        venueId: state.venue!.id,
                                                        selectedServiceId: state.services[index].id,
                                                        services: state.services,
                                                        venue: state.venue!,
                                                      ),
                                                    );
                                                  },
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
