part of 'dashboard_widget.dart';

class _ProfileWidget extends StatefulWidget {
  final User user;

  const _ProfileWidget({required this.user});

  @override
  State<_ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<_ProfileWidget> {
  final phoneFormatter = AppFormatters.createPhoneFormatter();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(dimension: 80, child: CircleAvatar(child: Icon(Icons.person))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                S.of(context).welcomeMessage(widget.user.name),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(phoneFormatter.maskText(widget.user.phoneNumber)),
            ],
          ),
        ),
      ],
    );
  }
}
