import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_client/presentation/components/service_grid_item.dart';
import 'package:flutter/material.dart';

class SelectServiceDialog extends StatelessWidget {
  final List<Service> services;
  final Staff? selectedStaff;

  const SelectServiceDialog({super.key, required this.services, this.selectedStaff});

  @override
  Widget build(BuildContext context) {
    final servicesWithStaff =
        services.where((service) => selectedStaff == null || selectedStaff!.services.contains(service.id)).toList();

    final servicesWithoutStaff =
        services.where((service) => selectedStaff != null && !selectedStaff!.services.contains(service.id)).toList();

    return AppDraggableModalSheet(
      builder:
          (context, scrollController) => Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Stack(
                children: [
                  CustomScrollView(
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
                              sliver: SliverGrid.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemCount: servicesWithStaff.length,
                                itemBuilder:
                                    (context, index) => ServiceGridItem(
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
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                      S.of(context).servicesWithoutStaff,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                            SliverPadding(
                              padding: EdgeInsets.only(top: 16),
                              sliver: SliverGrid.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemCount: servicesWithoutStaff.length,
                                itemBuilder:
                                    (context, index) => Opacity(
                                      opacity: 0.5,
                                      child: ServiceGridItem(
                                        grayScaleImage: true,
                                        service: servicesWithoutStaff[index],
                                        onTap: () {
                                          Navigator.of(context).pop(servicesWithoutStaff[index]);
                                        },
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(top: 8, right: 8, child: CloseButton()),
                ],
              ),
            ),
          ),
    );
  }
}
