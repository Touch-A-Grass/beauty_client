import 'package:beauty_client/domain/models/coupon.dart';
import 'package:flutter/material.dart';

class CouponItem extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback? onTap;

  const CouponItem({super.key, required this.coupon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Row(
              children: [
                Expanded(child: Text(coupon.name, style: Theme.of(context).textTheme.titleMedium)),
                Text(
                  '${coupon.discountValue}${switch (coupon.discountType) {
                    DiscountType.fixed => '₽',
                    DiscountType.percentage => '%',
                  }}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Text(coupon.description, style: Theme.of(context).textTheme.bodyMedium),
            Text(coupon.code, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
