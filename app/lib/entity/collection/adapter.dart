import 'package:flutter/foundation.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter/ad_hoc.dart';
import 'package:nc_photos/entity/collection/adapter/album.dart';
import 'package:nc_photos/entity/collection/adapter/location_group.dart';
import 'package:nc_photos/entity/collection/adapter/memory.dart';
import 'package:nc_photos/entity/collection/adapter/nc_album.dart';
import 'package:nc_photos/entity/collection/adapter/person.dart';
import 'package:nc_photos/entity/collection/adapter/tag.dart';
import 'package:nc_photos/entity/collection/content_provider/ad_hoc.dart';
import 'package:nc_photos/entity/collection/content_provider/album.dart';
import 'package:nc_photos/entity/collection/content_provider/location_group.dart';
import 'package:nc_photos/entity/collection/content_provider/memory.dart';
import 'package:nc_photos/entity/collection/content_provider/nc_album.dart';
import 'package:nc_photos/entity/collection/content_provider/person.dart';
import 'package:nc_photos/entity/collection/content_provider/tag.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_string/np_string.dart';

abstract class CollectionAdapter {
  const CollectionAdapter();

  static CollectionAdapter of(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    switch (collection.contentProvider.runtimeType) {
      case const (CollectionAdHocProvider):
        return CollectionAdHocAdapter(c, account, collection);
      case const (CollectionAlbumProvider):
        return CollectionAlbumAdapter(c, account, collection);
      case const (CollectionLocationGroupProvider):
        return CollectionLocationGroupAdapter(c, account, collection);
      case const (CollectionMemoryProvider):
        return CollectionMemoryAdapter(c, account, collection);
      case const (CollectionNcAlbumProvider):
        return CollectionNcAlbumAdapter(c, account, collection);
      case const (CollectionPersonProvider):
        return CollectionPersonAdapter(c, account, collection);
      case const (CollectionTagProvider):
        return CollectionTagAdapter(c, account, collection);
      default:
        throw UnsupportedError(
          "Unknown type: ${collection.contentProvider.runtimeType}",
        );
    }
  }

  /// List items inside this collection
  Stream<List<CollectionItem>> listItem();

  /// Add [files] to this collection and return the added count
  Future<int> addFiles(
    List<FileDescriptor> files, {
    ErrorWithValueHandler<FileDescriptor>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  });

  /// Edit this collection
  Future<Collection> edit({
    String? name,
    List<CollectionItem>? items,
    CollectionItemSort? itemSort,
    OrNull<FileDescriptor>? cover,
    List<CollectionItem>? knownItems,
  });

  /// Remove [items] from this collection and return the removed count
  Future<int> removeItems(
    List<CollectionItem> items, {
    ErrorWithValueIndexedHandler<CollectionItem>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  });

  /// Share the collection with [sharee]
  Future<CollectionShareResult> share(
    Sharee sharee, {
    required ValueChanged<Collection> onCollectionUpdated,
  });

  /// Unshare the collection with a user
  Future<CollectionShareResult> unshare(
    CiString userId, {
    required ValueChanged<Collection> onCollectionUpdated,
  });

  /// Import a pending shared collection and return the resulting collection
  Future<Collection> importPendingShared();

  /// Convert a [NewCollectionItem] to an adapted one
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original);

  bool isItemRemovable(CollectionItem item);

  bool isItemDeletable(CollectionItem item);

  /// Remove this collection
  Future<void> remove();

  /// Return if this capability is allowed
  bool isPermitted(CollectionCapability capability);

  /// Return if the cover of this collection has been manually set
  bool isManualCover();

  /// Called when the collection items belonging to this collection is first
  /// loaded
  Future<Collection?> updatePostLoad(List<CollectionItem> items);
}

abstract class CollectionItemAdapter {
  const CollectionItemAdapter();

  CollectionItem toItem();
}
