
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:flutter/material.dart';

/*
class SelectTimeslotSheet extends StatelessWidget {
  // final List<>

  const SelectTimeslotSheet({super.key, required this.services, this.selectedStaff});

  @override
  Widget build(BuildContext context) {
    final servicesWithStaff =
    services.where((service) => selectedStaff == null || selectedStaff!.services.contains(service.id)).toList();

    final servicesWithoutStaff =
    services.where((service) => selectedStaff != null && !selectedStaff!.services.contains(service.id)).toList();

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
                      itemCount: servicesWithStaff.length,
                      itemBuilder:
                          (context, index) => ServiceListItem(
                        service: servicesWithStaff[index],
                        onTap: () {
                          Navigator.of(context).pop(servicesWithStaff[index]);
                        },
                      ),
                    ),
                  ),
                  if (servicesWithoutStaff.isNotEmpty)
                    SliverPadding(
                      padding: EdgeInsets.only(top: 16),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          S.of(context).servicesWithoutStaff,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 16),
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemCount: servicesWithoutStaff.length,
                      itemBuilder:
                          (context, index) => ServiceListItem(
                        service: servicesWithoutStaff[index],
                        isError: true,
                        onTap: () {
                          Navigator.of(context).pop(servicesWithoutStaff[index]);
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
*/
