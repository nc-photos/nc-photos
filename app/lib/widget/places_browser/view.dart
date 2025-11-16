part of 'places_browser.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(L10n.global().collectionPlacesLabel),
      floating: true,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AboutGeocodingDialog(),
            );
          },
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}

class _CountryList extends StatelessWidget {
  const _CountryList({this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.transformedCountryItems !=
              current.transformedCountryItems,
      builder:
          (context, state) => SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: state.transformedCountryItems.length,
                itemBuilder: (context, i) {
                  final item = state.transformedCountryItems[i];
                  return _CountryItemView(
                    account: context.read<_Bloc>().account,
                    item: item,
                    onTap:
                        onTap == null
                            ? null
                            : () {
                              onTap!.call(i, item);
                            },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
              ),
            ),
          ),
    );
  }

  final Function(int index, _Item item)? onTap;
}

class _ContentList extends StatelessWidget {
  const _ContentList({this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.transformedPlaceItems != current.transformedPlaceItems,
      builder:
          (context, state) => SliverStaggeredGrid.extentBuilder(
            maxCrossAxisExtent: 160,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            itemCount: state.transformedPlaceItems.length,
            itemBuilder: (context, index) {
              final item = state.transformedPlaceItems[index];
              return _PlaceItemView(
                account: context.read<_Bloc>().account,
                item: item,
                onTap:
                    onTap == null
                        ? null
                        : () {
                          onTap!.call(index, item);
                        },
              );
            },
            staggeredTileBuilder: (_) => const StaggeredTile.count(1, 1),
          ),
    );
  }

  final Function(int index, _Item item)? onTap;
}

class _PlaceItemView extends StatelessWidget {
  const _PlaceItemView({required this.account, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CollectionListSmall(
      label: item.name,
      onTap: onTap,
      child: _LocationThumbnail(
        account: account,
        coverUrl: item.coverUrl,
        coverMime: item.coverMime,
      ),
    );
  }

  final Account account;
  final _Item item;
  final VoidCallback? onTap;
}

class _CountryItemView extends StatelessWidget {
  const _CountryItemView({
    required this.account,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LocationThumbnail(
                account: account,
                coverUrl: item.coverUrl,
                coverMime: item.coverMime,
              ),
              const SizedBox(width: 8),
              Text(item.name),
              const SizedBox(width: 8),
            ],
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (onTap != null)
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ),
        ],
      ),
    );
  }

  final Account account;
  final _Item item;
  final VoidCallback? onTap;
}

class _LocationThumbnail extends StatelessWidget {
  const _LocationThumbnail({
    required this.account,
    required this.coverUrl,
    required this.coverMime,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return NetworkRectThumbnail(
        account: account,
        imageUrl: coverUrl!,
        mime: coverMime,
        errorBuilder: (_) => const _LocationPlaceholder(),
      );
    } catch (_) {
      return const FittedBox(child: _LocationPlaceholder());
    }
  }

  final Account account;
  final String? coverUrl;
  final String? coverMime;
}

class _LocationPlaceholder extends StatelessWidget {
  const _LocationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.location_on,
        color: Theme.of(context).listPlaceholderForegroundColor,
      ),
    );
  }
}
