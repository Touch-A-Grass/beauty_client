part of 'order_details_widget.dart';

class _OrderVenueInfo extends StatelessWidget {
  final Order order;

  const _OrderVenueInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).venue, style: Theme.of(context).textTheme.headlineSmall),
        IntrinsicHeight(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceContainer,
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(order.venue.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(order.venue.description),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (!await launchUrl(
                      Uri.parse(
                        'yandexnavi://build_route_on_map?lat_to=${order.venue.location.latitude}&lon_to=${order.venue.location.longitude}',
                      ),
                    )) {
                      await launchUrl(
                        Uri.parse(
                          'google.navigation:q=${order.venue.location.latitude},${order.venue.location.longitude}',
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.location_pin),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
