import 'package:beauty_client/presentation/components/error_snackbar.dart';
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
            onClick: () {},
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: state.venues.data.length,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
