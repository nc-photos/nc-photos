import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/adapter/adapter_mixin.dart';
import 'package:nc_photos/entity/collection/content_provider/nc_album.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/nc_album_item_adapter.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/use_case/find_file_descriptor.dart';
import 'package:nc_photos/use_case/nc_album/add_file_to_nc_album.dart';
import 'package:nc_photos/use_case/nc_album/edit_nc_album.dart';
import 'package:nc_photos/use_case/nc_album/list_nc_album.dart';
import 'package:nc_photos/use_case/nc_album/list_nc_album_item.dart';
import 'package:nc_photos/use_case/nc_album/remove_from_nc_album.dart';
import 'package:nc_photos/use_case/nc_album/remove_nc_album.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';

part 'nc_album.g.dart';

@npLog
class CollectionNcAlbumAdapter
    with CollectionAdapterUnshareableTag
    implements CollectionAdapter {
  CollectionNcAlbumAdapter(this._c, this.account, this.collection)
      : assert(require(_c)),
        _provider = collection.contentProvider as CollectionNcAlbumProvider;

  static bool require(DiContainer c) => ListNcAlbumItem.require(c);

  @override
  Stream<List<CollectionItem>> listItem() {
    return ListNcAlbumItem(_c)(account, _provider.album)
        .asyncMap((items) async {
      final found = await FindFileDescriptor(_c)(
        account,
        items.map((e) => e.fileId).toList(),
        onFileNotFound: (fileId) {
          // happens when this is a file shared with you
          _log.warning("[listItem] File not found: $fileId");
        },
      );
      return items.map((i) {
        final f = found.firstWhereOrNull((e) => e.fdId == i.fileId);
        return CollectionFileItemNcAlbumItemAdapter(
          i,
          // retain the path such that it is correctly recognized as part of an
          // album
          f?.replacePath(i.path),
        );
      }).toList();
    });
  }

  @override
  Future<int> addFiles(
    List<FileDescriptor> files, {
    ErrorWithValueHandler<FileDescriptor>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  }) async {
    final count = await AddFileToNcAlbum(_c)(account, _provider.album, files,
        onError: onError);
    if (count > 0) {
      try {
        final newAlbum = await _syncRemote();
        onCollectionUpdated(collection.copyWith(
          contentProvider: _provider.copyWith(
            album: newAlbum,
          ),
        ));
      } catch (e, stackTrace) {
        _log.severe("[addFiles] Failed while _syncRemote", e, stackTrace);
      }
    }
    return count;
  }

  @override
  Future<Collection> edit({
    String? name,
    List<CollectionItem>? items,
    CollectionItemSort? itemSort,
    OrNull<FileDescriptor>? cover,
    List<CollectionItem>? knownItems,
  }) async {
    assert(name != null);
    if (items != null || itemSort != null || cover != null) {
      _log.warning(
          "[edit] Nextcloud album does not support editing item or sort");
    }
    // final newItems = items?.run((items) => items
    //     .map((e) => e is CollectionFileItem ? e.file : null)
    //     .whereNotNull()
    //     .toList());
    final newAlbum = await EditNcAlbum(_c)(
      account,
      _provider.album,
      name: name,
      // items: newItems,
      // itemSort: itemSort,
    );
    return collection.copyWith(
      name: name,
      contentProvider: _provider.copyWith(album: newAlbum),
    );
  }

  @override
  Future<int> removeItems(
    List<CollectionItem> items, {
    ErrorWithValueIndexedHandler<CollectionItem>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  }) async {
    final count = await RemoveFromNcAlbum(_c)(account, _provider.album, items,
        onError: onError);
    if (count > 0) {
      try {
        final newAlbum = await _syncRemote();
        onCollectionUpdated(collection.copyWith(
          contentProvider: _provider.copyWith(
            album: newAlbum,
          ),
        ));
      } catch (e, stackTrace) {
        _log.severe("[removeItems] Failed while _syncRemote", e, stackTrace);
      }
    }
    return count;
  }

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    } else {
      throw UnsupportedError("Unsupported type: ${original.runtimeType}");
    }
  }

  @override
  bool isItemRemovable(CollectionItem item) => true;

  @override
  bool isItemDeletable(CollectionItem item) => false;

  @override
  Future<void> remove() => RemoveNcAlbum(_c)(account, _provider.album);

  @override
  bool isPermitted(CollectionCapability capability) {
    if (!_provider.capabilities.contains(capability)) {
      return false;
    }
    if (_provider.isOwned) {
      return true;
    } else {
      return _provider.guestCapabilities.contains(capability);
    }
  }

  @override
  bool isManualCover() => false;

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);

  Future<NcAlbum> _syncRemote() async {
    final remote = await ListNcAlbum(_c)(account).last;
    return remote.firstWhere((e) => e.compareIdentity(_provider.album));
  }

  final DiContainer _c;
  final Account account;
  final Collection collection;

  final CollectionNcAlbumProvider _provider;
}
