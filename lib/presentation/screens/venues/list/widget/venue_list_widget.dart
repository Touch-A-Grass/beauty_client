import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_refresh_indicator.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/components/shimmer_box.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/venues/list/bloc/venue_list_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueListWidget extends StatelessWidget {
  const VenueListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VenueListBloc, VenueListState>(
      listenWhen: (prev, curr) => curr.loadingError != null && !identical(prev.loadingError, curr.loadingError),
      listener: (context, state) {
        context.showErrorSnackBar(state.loadingError!);
      },
      child: BlocBuilder<VenueListBloc, VenueListState>(
        builder: (context, state) {
          if (state.isLoadingVenues && state.venues.data.isEmpty) {
            return _LoadingSkeleton();
          }
          if (!state.isLoadingVenues && state.venues.data.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sentiment_dissatisfied, size: 100, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 16),
                Text(S.of(context).noVenuesNearbyMessage, style: Theme.of(context).textTheme.titleSmall),
              ],
            );
          }
          return AppRefreshIndicator(
            isRefreshing: state.isLoadingVenues,
            onRefresh: () => context.read<VenueListBloc>().add(const VenueListEvent.requested(refresh: true)),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  sliver: SliverList.separated(
                    itemBuilder:
                        (context, index) => VenueListItem(
                          venue: state.venues.data[index],
                          onClick: () {
                            final venue = state.venues.data[index];
                            context.pushRoute(VenueDetailsRoute(venueId: venue.id, venue: venue));
                          },
                        ),
                    separatorBuilder: (context, index) => const Divider(height: 24),
                    itemCount: state.venues.data.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          sliver: SliverList.separated(
            itemBuilder: (context, index) => ShimmerLoading(height: 130, width: double.infinity),
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
