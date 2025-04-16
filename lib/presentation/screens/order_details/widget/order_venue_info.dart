part of 'order_details_widget.dart';

class _OrderVenueInfo extends StatelessWidget {
  final Order order;

  const _OrderVenueInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    return VenueListItem(
      venue: order.venue,
      shrinkDescription: true,
      onClick: () => context.pushRoute(VenueDetailsRoute(venueId: order.venue.id, venue: order.venue)),
      showLocationButton: true,
    );
  }
}
