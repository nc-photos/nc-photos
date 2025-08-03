part of '../home_collections.dart';

enum _ItemType {
  ncAlbum,
  album,
  dirAlbum,
  tagAlbum,
}

@npLog
class _Item implements SelectableItemMetadata {
  _Item._({
    required this.collection,
    required this.coverUrl,
    required this.coverMime,
  }) : isShared = collection.shares.isNotEmpty || !collection.isOwned {
    _initType();
  }

  factory _Item.fromCollection(Collection collection) {
    try {
      final result = collection.getCoverUrl(k.coverSize, k.coverSize);
      return _Item._(
        collection: collection,
        coverUrl: result?.url,
        coverMime: result?.mime,
      );
    } catch (e, stackTrace) {
      _$_ItemNpLog.log
          .warning("[fromCollection] Failed while getCoverUrl", e, stackTrace);
      return _Item._(
        collection: collection,
        coverUrl: null,
        coverMime: null,
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _Item && collection.compareIdentity(other.collection));

  @override
  int get hashCode => collection.identityHashCode;

  @override
  bool get isSelectable => true;

  String get name => collection.name;

  String? getSubtitle({
    int? itemCountOverride,
  }) {
    if (collection.count != null) {
      return L10n.global().albumSize(itemCountOverride ?? collection.count!);
    } else {
      return null;
    }
  }

  _ItemType get itemType => _itemType;

  void _initType() {
    _ItemType? type;
    if (collection.contentProvider is CollectionNcAlbumProvider) {
      type = _ItemType.ncAlbum;
    } else if (collection.contentProvider is CollectionAlbumProvider) {
      final provider = collection.contentProvider as CollectionAlbumProvider;
      if (provider.album.provider is AlbumStaticProvider) {
        type = _ItemType.album;
      } else if (provider.album.provider is AlbumDirProvider) {
        type = _ItemType.dirAlbum;
      } else if (provider.album.provider is AlbumTagProvider) {
        type = _ItemType.tagAlbum;
      }
    }
    if (type == null) {
      throw UnsupportedError("Collection type not supported");
    }
    _itemType = type;
  }

  final Collection collection;
  final String? coverUrl;
  final String? coverMime;
  final bool isShared;

  late _ItemType _itemType;
}
