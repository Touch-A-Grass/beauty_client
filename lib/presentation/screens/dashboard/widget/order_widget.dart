part of 'dashboard_widget.dart';

class _OrderWidget extends StatefulWidget {
  final Order order;

  const _OrderWidget(this.order);

  @override
  State<_OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<_OrderWidget> {
  final dateFormat = DateFormat('dd MMMM, HH:mm');

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.pushRoute(OrderDetailsRoute(orderId: widget.order.id)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: TextStyle(color: color),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              widget.order.service.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: color,
                                leadingDistribution: TextLeadingDistribution.even,
                              ),
                            ),
                          ),
                          Text(
                            dateFormat.format(widget.order.startTimestamp),
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: color,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [Icon(Icons.location_pin, color: color), Text(widget.order.venue.name)],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  context.navigateTo(OrdersRoute());
                },
                icon: const Icon(Icons.menu_open),
                iconSize: 24,
                padding: EdgeInsets.all(4),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
