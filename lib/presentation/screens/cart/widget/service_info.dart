part of 'cart_widget.dart';

class _ServiceInfoPlaceHolder extends StatelessWidget {
  final VoidCallback? onTap;

  const _ServiceInfoPlaceHolder({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RoundedAvatar(),
        Expanded(
          child: Text(
            S.of(context).cartDateServiceRequired,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
        if (onTap != null) IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
      ],
    );
  }
}
