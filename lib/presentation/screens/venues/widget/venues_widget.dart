import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/screens/venues/list/venue_list.dart';
import 'package:beauty_client/presentation/screens/venues/map/venue_map.dart';
import 'package:flutter/material.dart';

class VenuesWidget extends StatelessWidget {
  const VenuesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Column(
            children: [
              TabBar(tabs: [Tab(text: S.of(context).dashboardListButton), Tab(text: S.of(context).dashboardMapButton)]),
              const Expanded(child: TabBarView(children: [VenueList(), VenueMap()])),
            ],
          ),
        ),
      ),
    );
  }
}
