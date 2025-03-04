import 'package:auto_route/annotations.dart';
import 'package:beauty_client/presentation/screens/venues/list/bloc/venue_list_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/map/bloc/venue_map_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venues_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VenueListBloc(context.read(), context.read())),
        BlocProvider(create: (context) => VenueMapBloc(context.read(), context.read())),
      ],
      child: const VenuesWidget(),
    );
  }
}
