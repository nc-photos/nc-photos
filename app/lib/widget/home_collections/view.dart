part of '../home_collections.dart';

class _ItemView extends StatelessWidget {
  const _ItemView({
    required this.account,
    required this.item,
    this.collectionItemCountOverride,
  });

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    switch (item.itemType) {
      case _ItemType.ncAlbum:
        icon = const Icon(Icons.cloud);
        break;
      case _ItemType.album:
        icon = null;
        break;
      case _ItemType.tagAlbum:
        icon = const Icon(Icons.local_offer);
        break;
      case _ItemType.dirAlbum:
        icon = const Icon(Icons.folder);
        break;
    }
    var subtitle = "";
    if (item.isShared) {
      subtitle = "${L10n.global().albumSharedLabel} | ";
    }
    subtitle +=
        item.getSubtitle(itemCountOverride: collectionItemCountOverride) ?? "";
    return CollectionGridItem(
      cover: _CollectionCover(
        account: account,
        url: item.coverUrl,
        mime: item.coverMime,
      ),
      title: item.name,
      subtitle: subtitle,
      icon: icon,
    );
  }

  final Account account;
  final _Item item;
  final int? collectionItemCountOverride;
}

class _CollectionCover extends StatelessWidget {
  const _CollectionCover({
    required this.account,
    required this.url,
    required this.mime,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Theme.of(context).listPlaceholderBackgroundColor,
        constraints: const BoxConstraints.expand(),
        child: url != null
            ? FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: CachedNetworkImageBuilder(
                  type: CachedNetworkImageType.cover,
                  imageUrl: url!,
                  mime: mime,
                  account: account,
                  errorWidget: (context, url, error) {
                    // just leave it empty
                    return Container();
                  },
                ).build(),
              )
            : Icon(
                Icons.panorama,
                color: Theme.of(context).listPlaceholderForegroundColor,
                size: 88,
              ),
      ),
    );
  }

  final Account account;
  final String? url;
  final String? mime;
}
