part of 'dashboard_widget.dart';

class _UserLoadingSkeleton extends StatelessWidget {
  const _UserLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
        child: CustomScrollView(
          slivers: [
            _UserLoadingSliver(),
            SliverPadding(padding: EdgeInsets.only(top: 32), sliver: _OrderLoadingSliver()),
            SliverPadding(
              padding: const EdgeInsets.only(top: 32),
              sliver: SliverToBoxAdapter(child: ShimmerLoading(width: 128, height: 32)),
            ),
            SliverPadding(padding: const EdgeInsets.only(top: 16), sliver: _VenueLoadingSliver()),
          ],
        ),
      ),
    );
  }
}

class _UserLoadingSliver extends StatelessWidget {
  const _UserLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          ShimmerLoadingPainter(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          Expanded(child: ShimmerLoading(width: double.infinity, height: 32)),
        ],
      ),
    );
  }
}

class _OrderLoadingSliver extends StatelessWidget {
  const _OrderLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: ShimmerLoading(width: double.infinity, height: 100));
  }
}

class _VenueLoadingSliver extends StatelessWidget {
  const _VenueLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (context, index) => const _VenueLoadingItem(),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: 3,
    );
  }
}

class _VenueLoadingItem extends StatelessWidget {
  const _VenueLoadingItem();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(width: double.infinity, height: 160);
  }
}
