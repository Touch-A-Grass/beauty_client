part of 'cart_widget.dart';

class _StaffInfoPlaceHolder extends StatelessWidget {
  final VoidCallback? onTap;

  const _StaffInfoPlaceHolder({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(dimension: 96, child: CircleAvatar(child: Icon(Icons.person))),
        Expanded(
          child: Text(
            S.of(context).cartDateMasterRequired,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
        if (onTap != null) IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
      ],
    );
  }
}
