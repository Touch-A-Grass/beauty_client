import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/components/error_snackbar.dart';
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
        builder: (context, state) => ListView.separated(
          itemBuilder: (context, index) => VenueListItem(
            venue: state.venues.data[index],
            onClick: () {
              context.pushRoute(VenueDetailsRoute(venueId: state.venues.data[index].id));
            },
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: state.venues.data.length,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
