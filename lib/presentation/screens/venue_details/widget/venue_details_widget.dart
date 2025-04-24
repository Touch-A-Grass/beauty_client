import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/components/app_carousel.dart';
import 'package:beauty_client/presentation/components/dot_painter.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/components/parallax_flow_delegate.dart';
import 'package:beauty_client/presentation/components/service_grid_item.dart';
import 'package:beauty_client/presentation/components/shimmer_box.dart';
import 'package:beauty_client/presentation/components/staff_grid_item.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/service_details/service_details_bottom_sheet.dart';
import 'package:beauty_client/presentation/screens/venue_details/bloc/venue_details_bloc.dart';
import 'package:beauty_client/presentation/util/bloc_single_change_listener.dart';
import 'package:beauty_client/presentation/util/navigator_util.dart';
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
    final buttonStyle = ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface));

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
                child: LayoutBuilder(
                  builder:
                      (context, constraints) => NestedScrollView(
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
                                    automaticallyImplyLeading: false,
                                    expandedHeight: constraints.maxWidth,
                                    backgroundColor: Colors.transparent,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        BackButton(style: buttonStyle),
                                        if (state.venue != null)
                                          IconButton(
                                            style: buttonStyle,
                                            onPressed: () => NavigatorUtil.navigateToLocation(state.venue!.location),
                                            icon: const Icon(Icons.location_pin),
                                          ),
                                      ],
                                    ),
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
                                                      if (state.allPhotos.length == 1)
                                                        CachedNetworkImage(
                                                          imageUrl: state.allPhotos[0],
                                                          fit: BoxFit.cover,
                                                        )
                                                      else
                                                        AppCarousel(
                                                          enableScroll: ModalRoute.of(context)?.isCurrent ?? true,
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
                              if (state.venue?.address.isNotEmpty ?? false)
                                SliverPadding(
                                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                                  sliver: SliverToBoxAdapter(
                                    child: Row(
                                      spacing: 4,
                                      children: [
                                        Icon(Icons.location_pin, size: 16),
                                        Expanded(child: Text(state.venue!.address)),
                                      ],
                                    ),
                                  ),
                                ),
                              if (state.maxPrice != null && state.minPrice != null ||
                                  state.minDuration != null && state.maxDuration != null)
                                SliverPadding(
                                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                                  sliver: SliverToBoxAdapter(
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (state.maxPrice != null && state.minPrice != null)
                                            Text(
                                              '${state.minPrice} – ${state.maxPrice} ₽',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end,
                                            )
                                          else
                                            SizedBox.shrink(),
                                          if (state.minDuration != null && state.maxDuration != null)
                                            Text(
                                              '${state.minDuration!.inMinutes} ~ ${state.maxDuration!.inMinutes} мин.',
                                              style: Theme.of(context).textTheme.labelLarge,
                                              textAlign: TextAlign.end,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (state.venue?.description.isNotEmpty ?? false)
                                SliverPadding(
                                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                                  sliver: SliverToBoxAdapter(child: Text(state.venue!.description)),
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
                                                min(1, scrollController.offset / constraints.maxWidth),
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
      ),
    );
  }
}
