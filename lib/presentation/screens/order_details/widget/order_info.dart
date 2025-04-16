part of 'order_details_widget.dart';

class _OrderInfo extends StatelessWidget {
  final Order order;

  const _OrderInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        ServiceInfoWidget(service: order.service),
        Text(
          order.status.statusName(context),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: order.status.color()),
        ),
      ],
    );
  }
}
