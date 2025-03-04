import 'package:beauty_client/presentation/screens/venues/list/venue_list.dart';
import 'package:beauty_client/presentation/screens/venues/map/venue_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class VenuesWidget extends StatefulWidget {
  const VenuesWidget({super.key});

  @override
  State<VenuesWidget> createState() => _VenuesWidgetState();
}

class _VenuesWidgetState extends State<VenuesWidget> {
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Список'),
                  Tab(text: 'Карта'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    VenueList(),
                    VenueMap(),
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
