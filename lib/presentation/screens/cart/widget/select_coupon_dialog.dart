import 'package:beauty_client/domain/models/coupon.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_client/presentation/components/coupon_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCouponDialog extends StatefulWidget {
  final Service? selectedService;

  const SelectCouponDialog({super.key, this.selectedService});

  @override
  State<SelectCouponDialog> createState() => _SelectCouponDialogState();
}

class _SelectCouponDialogState extends State<SelectCouponDialog> {
  late final VenueRepository venueRepository;

  @override
  void initState() {
    venueRepository = context.read();
    loadCoupons();
    super.initState();
  }

  Future<void> loadCoupons() async {
    final coupons = await venueRepository.getCoupons();
    if (context.mounted) {
      setState(() {
        isLoading = false;
        this.coupons
          ..clear()
          ..addAll(coupons.data);
      });
    }
  }

  final List<Coupon> coupons = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
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
                              child: Text(S.of(context).cartMaster, style: Theme.of(context).textTheme.headlineSmall),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.only(top: 16),
                              sliver: SliverList.separated(
                                itemCount: coupons.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                itemBuilder:
                                    (context, index) => CouponItem(
                                      coupon: coupons[index],
                                      onTap: () {
                                        Navigator.of(context).pop(coupons[index]);
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(top: 8, right: 8, child: CloseButton()),
                  if (isLoading) Positioned.fill(child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ),
    );
  }
}
