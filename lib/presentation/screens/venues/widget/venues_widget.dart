import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/models/venue_theme_config.dart';
import 'package:beauty_client/presentation/screens/venues/bloc/venues_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class VenuesWidget extends StatefulWidget {
  const VenuesWidget({super.key});

  @override
  State<VenuesWidget> createState() => _VenuesWidgetState();
}

class _VenuesWidgetState extends State<VenuesWidget> {
  // final mapController = MapController(initPosition: GeoPoint(latitude: 0, longitude: 0));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenuesBloc, VenuesState>(
      builder: (context, state) => DefaultTabController(
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
                      ListView.separated(
                        itemBuilder: (context, index) => Text(state.venues.data[index].name),
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemCount: state.venues.data.length,
                      ),
                      const FlutterMap(
                        children: [

                          MobileLayerTransformer(
                            child: VenueListItem(
                              venue: Venue(
                                id: '',
                                name: '',
                                theme: VenueThemeConfig(color: 0, photo: ''),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
