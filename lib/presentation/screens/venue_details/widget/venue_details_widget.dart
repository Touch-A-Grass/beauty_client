import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/components/app_carousel.dart';
import 'package:beauty_client/presentation/components/dot_painter.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/components/parallax_flow_delegate.dart';
import 'package:beauty_client/presentation/components/service_grid_item.dart';
import 'package:beauty_client/presentation/components/shimmer_box.dart';
import 'package:beauty_client/presentation/components/staff_gird_item.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/venue_details/bloc/venue_details_bloc.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'services_tab.dart';
part 'staff_tab.dart';

class VenueDetailsWidget extends StatefulWidget {
  const VenueDetailsWidget({super.key});

  @override
  State<VenueDetailsWidget> createState() => _VenueDetailsWidgetState();
}

class _VenueDetailsWidgetState extends State<VenueDetailsWidget> with TickerProviderStateMixin {
  final scrollController = ScrollController();
  final AppCarouselController carouselController = AppCarouselController(1);

  final ValueNotifier<double> dotAnimation = ValueNotifier(0);

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
        BlocSingleChangeListener<VenueDetailsBloc, VenueDetailsState>(
          map: (state) => state.staffLoadingError,
          listener: (context, state) => context.showErrorSnackBar(state.staffLoadingError!),
        ),
        BlocListener<VenueDetailsBloc, VenueDetailsState>(
          listenWhen: (prev, curr) => prev.allPhotos.length != curr.allPhotos.length,
          listener: (context, state) {
            carouselController.length = state.allPhotos.length;
          },
        ),
      ],
      child: BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
        builder:
            (context, state) => Scaffold(
              body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder:
                      (context, innerBoxIsScrolled) => [
                        SliverMainAxisGroup(
                          slivers: [
                            SliverAppBar(
                              elevation: 0,
                              scrolledUnderElevation: 0,
                              floating: false,
                              pinned: false,
                              primary: false,
                              automaticallyImplyLeading: false,
                              expandedHeight: MediaQuery.of(context).size.width,
                              backgroundColor: Colors.transparent,
                              flexibleSpace: Stack(
                                children: [
                                  if (state.venue?.theme.photo.isNotEmpty ?? false) ...[
                                    SizedBox.expand(
                                      child: AnimatedBuilder(
                                        animation: scrollController,
                                        builder:
                                            (context, _) => Flow(
                                              delegate: ParallaxFlowDelegate(
                                                scrollable: Scrollable.of(context),
                                                itemContext: context,
                                              ),
                                              children: [
                                                AppCarousel(
                                                  controller: carouselController,
                                                  itemBuilder:
                                                      (context, index) => CachedNetworkImage(
                                                        imageUrl: state.allPhotos[index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 16,
                                      child: Center(
                                        child: AnimatedBuilder(
                                          animation: carouselController,
                                          builder:
                                              (context, _) =>
                                                  carouselController.length > 1
                                                      ? DotProgressWidget(
                                                        color: Theme.of(context).colorScheme.shadow,
                                                        switchAnimation: carouselController.animation,
                                                        position: carouselController.page,
                                                        selectedColor: Theme.of(context).colorScheme.onPrimary,
                                                        length: carouselController.length,
                                                      )
                                                      : SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                  ] else
                                    ShimmerLoading(borderRadius: BorderRadius.zero),
                                  Positioned(
                                    left: 16,
                                    top: 16 + MediaQuery.of(context).padding.top,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 32),
                                      child: BackButton(
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStatePropertyAll(
                                            Theme.of(context).colorScheme.surface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (state.venue?.name.isNotEmpty ?? false)
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                            sliver: SliverToBoxAdapter(
                              child: Text(state.venue!.name, style: Theme.of(context).textTheme.headlineSmall),
                            ),
                          ),
                        if (state.venue?.description.isNotEmpty ?? false)
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                            sliver: SliverToBoxAdapter(
                              child: Text(state.venue!.description, style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ),
                        SliverOverlapAbsorber(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          sliver: SliverPinnedHeader(
                            child: AnimatedBuilder(
                              animation: scrollController,
                              builder:
                                  (context, _) => Padding(
                                    padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).padding.top *
                                          min(1, scrollController.offset / MediaQuery.of(context).size.width),
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                                      child: TabBar(tabs: const [Tab(text: 'Услуги'), Tab(text: 'Мастера')]),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                  body: TabBarView(children: [ServicesTab(), StaffTab()]),
                ),
              ),
            ),
      ),
    );
  }
}
