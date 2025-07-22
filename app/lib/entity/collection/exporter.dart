import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/album.dart';
import 'package:nc_photos/entity/collection/content_provider/nc_album.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/use_case/find_file.dart';
import 'package:np_log/np_log.dart';

part 'exporter.g.dart';

@npLog
class CollectionExporter {
  const CollectionExporter(this.account, this.collectionsController,
      this.collection, this.items, this.exportName);

  /// Export as a new collection backed by our client side album
  Future<Collection> asAlbum() async {
    final files = await FindFile(KiwiContainer().resolve<DiContainer>())(
      account,
      items.whereType<CollectionFileItem>().map((e) => e.file.fdId).toList(),
      onFileNotFound: (fileId) {
        _log.severe("[asAlbum] File not found: $fileId");
      },
    );
    final newAlbum = Album(
      name: exportName,
      provider: AlbumStaticProvider(
        items: items
            .map((e) {
              if (e is CollectionFileItem) {
                final f = files
                    .firstWhereOrNull((f) => f.compareServerIdentity(e.file));
                if (f == null) {
                  return null;
                } else {
                  return AlbumFileItem(
                    addedBy: account.userId,
                    addedAt: clock.now().toUtc(),
                    file: f,
                    ownerId: f.ownerId ?? account.userId,
                  );
                }
              } else if (e is CollectionLabelItem) {
                return AlbumLabelItem(
                  addedBy: account.userId,
                  addedAt: clock.now().toUtc(),
                  text: e.text,
                );
              } else if (e is CollectionMapItem) {
                return AlbumMapItem(
                  addedBy: account.userId,
                  addedAt: clock.now().toUtc(),
                  location: e.location,
                );
              } else {
                return null;
              }
            })
            .nonNulls
            .toList(),
        latestItemTime: collection.lastModified,
      ),
      coverProvider: const AlbumAutoCoverProvider(),
      sortProvider: const AlbumTimeSortProvider(isAscending: false),
    );
    var newCollection = Collection(
      name: exportName,
      contentProvider: CollectionAlbumProvider(
        account: account,
        album: newAlbum,
      ),
    );
    return await collectionsController.createNew(newCollection);
  }

  /// Export as a new collection backed by Nextcloud album
  Future<Collection> asNcAlbum() async {
    var newCollection = Collection(
      name: exportName,
      contentProvider: CollectionNcAlbumProvider(
        account: account,
        album: NcAlbum.createNew(account: account, name: exportName),
      ),
    );
    newCollection = await collectionsController.createNew(newCollection);
    // only files are supported in NcAlbum
    final newFiles =
        items.whereType<CollectionFileItem>().map((e) => e.file).toList();
    final data = collectionsController
        .peekStream()
        .data
        .firstWhere((e) => e.collection.compareIdentity(newCollection));
    await data.controller.addFiles(newFiles);
    return newCollection;
  }

  final Account account;
  final CollectionsController collectionsController;
  final Collection collection;
  final List<CollectionItem> items;
  final String exportName;
}
