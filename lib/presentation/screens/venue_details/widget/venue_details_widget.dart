import 'package:beauty_client/presentation/components/error_snackbar.dart';
import 'package:beauty_client/presentation/screens/venue_details/bloc/venue_details_bloc.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/service_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueDetailsWidget extends StatefulWidget {
  const VenueDetailsWidget({super.key});

  @override
  State<VenueDetailsWidget> createState() => _VenueDetailsWidgetState();
}

class _VenueDetailsWidgetState extends State<VenueDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<VenueDetailsBloc, VenueDetailsState>(
      listenWhen: (prev, curr) =>
          curr.servicesLoadingError != null && !identical(prev.servicesLoadingError, curr.servicesLoadingError),
      listener: (context, state) {
        context.showErrorSnackBar(state.servicesLoadingError!);
      },
      child: BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Venue Details')),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: state.isLoadingServices
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    itemCount: state.services.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => ServiceListItem(service: state.services[index]),
                  ),
          ),
        ),
      ),
    );
  }
}
