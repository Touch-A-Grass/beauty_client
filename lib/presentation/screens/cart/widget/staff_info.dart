part of 'cart_widget.dart';

class _StaffInfo extends StatelessWidget {
  final Staff staff;
  final VoidCallback? onTap;

  const _StaffInfo({required this.staff, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 96,
          child: CircleAvatar(
            foregroundImage: staff.photo != null ? CachedNetworkImageProvider(ImageUtil.parse256(staff.photo!)) : null,
            child: Text(staff.initials),
          ),
        ),
        Expanded(child: Text(staff.name, style: Theme.of(context).textTheme.titleMedium)),
        if (onTap != null) IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
      ],
    );
  }
}

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
