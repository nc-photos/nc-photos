part of '../home_photos2.dart';

class _BannerAd extends StatelessWidget {
  const _BannerAd();

  @override
  Widget build(BuildContext context) {
    return SliverMeasureExtent(
      onChange: (extent) {
        context.addEvent(_UpdateBannerAdExtent(extent));
      },
      child: const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 8),
        sliver: SliverToBoxAdapter(
          child: AdBanner(),
        ),
      ),
    );
  }
}
