import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/service_list_item.dart';
import 'package:flutter/material.dart';

class SelectServiceDialog extends StatelessWidget {
  final List<Service> services;

  const SelectServiceDialog({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return AppDraggableModalSheet(
      builder:
          (context, scrollController) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Text(S.of(context).cartService, style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16),
                        sliver: SliverList.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemCount: services.length,
                          itemBuilder:
                              (context, index) => ServiceListItem(
                                service: services[index],
                                onTap: () {
                                  Navigator.of(context).pop(services[index]);
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
