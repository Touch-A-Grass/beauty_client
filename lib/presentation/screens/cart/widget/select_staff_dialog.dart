import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_client/presentation/components/staff_grid_item.dart';
import 'package:flutter/material.dart';

class SelectStaffDialog extends StatelessWidget {
  final List<Staff> staff;
  final Service? selectedService;

  const SelectStaffDialog({super.key, required this.staff, this.selectedService});

  @override
  Widget build(BuildContext context) {
    final staffWithService =
        staff.where((staff) => selectedService == null || staff.services.contains(selectedService?.id)).toList();
    final staffWithoutService =
        staff.where((staff) => selectedService != null && !staff.services.contains(selectedService?.id)).toList();

    return AppDraggableModalSheet(
      builder:
          (context, scrollController) => Padding(
            padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text(S.of(context).cartMaster, style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(top: 16),
                          sliver: SliverGrid.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: staffWithService.length,
                            itemBuilder:
                                (context, index) => StaffGridItem(
                                  staff: staffWithService[index],
                                  onTap: () {
                                    Navigator.of(context).pop(staffWithService[index]);
                                  },
                                ),
                          ),
                        ),
                        if (staffWithoutService.isNotEmpty)
                          SliverPadding(
                            padding: EdgeInsets.only(top: 16),
                            sliver: SliverToBoxAdapter(
                              child: Opacity(
                                opacity: 0.5,
                                child: Text(
                                  S.of(context).staffsWithoutService,
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
                            itemCount: staffWithoutService.length,
                            itemBuilder:
                                (context, index) => Container(
                                  foregroundDecoration: BoxDecoration(
                                    color: Colors.grey,
                                    backgroundBlendMode: BlendMode.saturation,
                                  ),
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: StaffGridItem(
                                      staff: staffWithoutService[index],
                                      onTap: () => Navigator.of(context).pop(staffWithoutService[index]),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
