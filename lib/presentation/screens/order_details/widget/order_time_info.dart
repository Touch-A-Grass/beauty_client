part of 'order_details_widget.dart';

class _OrderTimeInfo extends StatefulWidget {
  final Order order;

  const _OrderTimeInfo({required this.order});

  @override
  State<_OrderTimeInfo> createState() => _OrderTimeInfoState();
}

class _OrderTimeInfoState extends State<_OrderTimeInfo> {
  final dateFormatter = DateFormat('dd MMMM HH:mm');
  final endTimeFormatter = DateFormat('HH:mm');

  final calendarFormatter = DateFormat('yyyyMMddTHHmmss');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).cartServiceTime, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainer,
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dateFormatter.format(widget.order.startTimestamp)} - ${endTimeFormatter.format(widget.order.endTimestamp)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () {
                  launchUrl(Uri.parse(generateLink()));
                },
                icon: Icon(Icons.date_range),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String generateLink() {
    return 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=${S.of(context).calendarRecordText(widget.order.venue.name, widget.order.service.name).replaceAll(' ', '+')}&dates=${calendarFormatter.format(widget.order.startTimestamp)}/${calendarFormatter.format(widget.order.endTimestamp)}';
  }
}
