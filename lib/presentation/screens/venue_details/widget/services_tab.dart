part of 'venue_details_widget.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
          builder: (context, state) {
            if (state.isLoadingServices) {
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
                  itemCount: state.services.length,
                  itemBuilder:
                      (context, index) => ServiceGridItem(
                        service: state.services[index],
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder:
                                (childContext) => ServiceDetailsBottomSheet(
                                  service: state.services[index],
                                  onCreateOrderPressed: () {
                                    context.pushRoute(
                                      CartRoute(
                                        venueId: state.venue!.id,
                                        selectedServiceId: state.services[index].id,
                                        services: state.services,
                                        venue: state.venue!,
                                        staffs: state.staff,
                                      ),
                                    );
                                  },
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
