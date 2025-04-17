import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_client/presentation/components/parallax_flow_delegate.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';

class ServiceDetailsBottomSheet extends StatelessWidget {
  final Service service;
  final VoidCallback? onCreateOrderPressed;

  const ServiceDetailsBottomSheet({super.key, required this.service, this.onCreateOrderPressed});

  @override
  Widget build(BuildContext context) {
    return AppDraggableModalSheet(
      size: 0.7,
      builder:
          (context, controller) => ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: controller,
                    slivers: [
                      if (service.photo != null)
                        SliverToBoxAdapter(
                          child: AnimatedBuilder(
                            animation: controller,
                            builder:
                                (context, _) => AspectRatio(
                                  aspectRatio: 2,
                                  child: Flow(
                                    delegate: ParallaxFlowDelegate(
                                      scrollable: Scrollable.of(context),
                                      itemContext: context,
                                    ),
                                    children: [CachedNetworkImage(imageUrl: service.photo!, fit: BoxFit.cover)],
                                  ),
                                ),
                          ),
                        ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        sliver: SliverToBoxAdapter(
                          child: Text(service.name, style: Theme.of(context).textTheme.headlineSmall),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                        sliver: SliverToBoxAdapter(
                          child: Opacity(
                            opacity: 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (service.price != null)
                                  Text(
                                    service.price!.toPriceFormat(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  )
                                else
                                  SizedBox.shrink(),
                                if (service.duration != null)
                                  Text(
                                    '~ ${service.duration!.inMinutes} мин.',
                                    style: Theme.of(context).textTheme.labelLarge,
                                    textAlign: TextAlign.end,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 4, left: 16, right: 16),
                        sliver: SliverToBoxAdapter(
                          child: MarkdownWidget(
                            padding: EdgeInsets.zero,
                            selectable: false,
                            data: service.description,
                            shrinkWrap: true,
                            config: MarkdownConfig(
                              configs: [
                                PConfig(textStyle: Theme.of(context).textTheme.bodyMedium!),
                                ImgConfig(
                                  builder: (context, attributes) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      child: LayoutBuilder(
                                        builder:
                                            (context, constraints) => Align(
                                              alignment: Alignment.topCenter,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: CachedNetworkImage(
                                                    imageUrl: attributes['src']!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16 + MediaQuery.of(context).padding.bottom,
                              top: 16,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton(onPressed: onCreateOrderPressed, child: Text('Записаться')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CloseButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
