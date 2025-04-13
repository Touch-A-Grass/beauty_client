part of 'venue_details_widget.dart';

class StaffTab extends StatelessWidget {
  const StaffTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
          builder: (context, state) {
            if (state.isLoadingStaff) {
              return const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()));
            }
            return SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.staff.length,
                  itemBuilder:
                      (context, index) => StaffGirdItem(
                        staff: state.staff[index],
                        onTap: () {
                          context.pushRoute(
                            CartRoute(
                              venueId: state.venue!.id,
                              selectedStaffId: state.staff[index].id,
                              services: state.services,
                              venue: state.venue!,
                              staffs: state.staff,
                            ),
                          );
                        },
                      ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
