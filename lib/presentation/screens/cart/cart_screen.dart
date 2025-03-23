import 'package:auto_route/annotations.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/presentation/screens/cart/bloc/cart_bloc.dart';
import 'package:beauty_client/presentation/screens/cart/widget/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CartScreen extends StatelessWidget {
  final String venueId;
  final Venue? venue;
  final List<Service>? services;
  final List<Staff>? staffs;
  final String? selectedServiceId;
  final String? selectedStaffId;

  const CartScreen({
    super.key,
    @PathParam('venueId') required this.venueId,
    this.venue,
    this.services,
    this.staffs,
    this.selectedServiceId,
    this.selectedStaffId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CartBloc(
            context.read(),
            context.read(),
            venueId: venueId,
            venue: venue,
            services: services ?? const [],
            selectedServiceId: selectedServiceId,
            selectedStaffId: selectedStaffId,
          )..add(const CartEvent.started()),
      child: const CartWidget(),
    );
  }
}
