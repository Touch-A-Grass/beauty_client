import 'package:auto_route/annotations.dart';
import 'package:beauty_client/presentation/screens/venues/bloc/venues_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venues_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VenuesBloc(context.read()),
      child: const VenuesWidget(),
    );
  }
}
