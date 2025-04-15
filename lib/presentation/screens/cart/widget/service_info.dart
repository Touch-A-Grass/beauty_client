part of 'cart_widget.dart';

class _ServiceInfo extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;

  const _ServiceInfo({required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedAvatar(
            image: service.photo != null ? CachedNetworkImageProvider(ImageUtil.parse256(service.photo!)) : null,
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(service.name, style: Theme.of(context).textTheme.titleMedium),
                Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  children: [
                    if (service.price != null)
                      Expanded(
                        child: Text(
                          service.price!.toPriceFormat(),
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Expanded(child: SizedBox()),
                    if (service.duration != null)
                      Text('~${service.duration?.inMinutes} мин.', style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ],
            ),
          ),
          if (onTap != null) IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}

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
