part of 'order_details_widget.dart';

class _OrderInfo extends StatelessWidget {
  final Order order;

  const _OrderInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(order.service.name, style: Theme.of(context).textTheme.headlineSmall)),
              Text(
                order.status.statusName(context),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: order.status.color()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Text(order.service.description)),
              if (order.service.price != null)
                Text(order.service.price!.toPriceFormat(), style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
