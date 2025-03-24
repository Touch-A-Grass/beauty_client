part of 'order_details_widget.dart';

class _OrderMasterInfo extends StatefulWidget {
  final Order order;

  const _OrderMasterInfo({required this.order});

  @override
  State<_OrderMasterInfo> createState() => _OrderMasterInfoState();
}

class _OrderMasterInfoState extends State<_OrderMasterInfo> {
  final phoneFormatter = AppFormatters.createPhoneFormatter();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).cartMaster, style: Theme.of(context).textTheme.headlineSmall),
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
                      Text(widget.order.staff.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(phoneFormatter.maskText(widget.order.staff.phoneNumber)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    launchUrl(Uri.parse('tel:+${widget.order.staff.phoneNumber}'));
                  },
                  icon: Icon(Icons.phone),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
