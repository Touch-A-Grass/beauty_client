import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/staff_list_item.dart';
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
                        child: Text(S.of(context).cartMaster, style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16),
                        sliver: SliverList.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemCount: staffWithService.length,
                          itemBuilder:
                              (context, index) => StaffListItem(
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
                            child: Text(
                              S.of(context).staffsWithoutService,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16),
                        sliver: SliverList.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemCount: staffWithoutService.length,
                          itemBuilder:
                              (context, index) => StaffListItem(
                                staff: staffWithoutService[index],
                                isError: true,
                                onTap: () => Navigator.of(context).pop(staffWithoutService[index]),
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
