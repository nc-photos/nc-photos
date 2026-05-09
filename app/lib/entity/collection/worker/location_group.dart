import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/location_group.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection/worker/mixin.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/pref.dart';
import 'package:np_db/np_db.dart';

class CollectionLocationGroupListItemWorker
    implements CollectionListItemWorker {
  CollectionLocationGroupListItemWorker(this._c, this.account, this.collection)
    : _provider = collection.contentProvider as CollectionLocationGroupProvider;

  @override
  Stream<List<CollectionItem>> listItem() async* {
    final files = await _c.fileRepo2.getFileDescriptors(
      account,
      file_util.unstripPath(
        account,
        AccountPref.of(account).getShareFolderOr(),
      ),
      location: DbFileQueryByLocation(
        place: _provider.location.name,
        locale: _provider.locale,
        countryCode: _provider.location.countryCode,
        isFuzzy: false,
      ),
      isAscending: false,
    );
    yield files
        .where((f) => file_util.isSupportedFormat(f))
        .map((f) => BasicCollectionFileItem(f))
        .toList();
  }

  final DiContainer _c;
  final Account account;
  final Collection collection;

  final CollectionLocationGroupProvider _provider;
}

class CollectionLocationGroupAddFilesWorker
    with CollectionWorkerNoAddFileTag
    implements CollectionAddFilesWorker {
  const CollectionLocationGroupAddFilesWorker();
}

class CollectionLocationGroupEditWorker
    with CollectionWorkerNoEditTag
    implements CollectionEditWorker {
  const CollectionLocationGroupEditWorker();
}

class CollectionLocationGroupRemoveItemsWorker
    with CollectionWorkerNoRemoveItemsTag
    implements CollectionRemoveItemsWorker {
  const CollectionLocationGroupRemoveItemsWorker();
}

class CollectionLocationGroupShareWorker
    with CollectionWorkerNoShareTag
    implements CollectionShareWorker {
  const CollectionLocationGroupShareWorker();
}

class CollectionLocationGroupUnshareWorker
    with CollectionWorkerNoUnshareTag
    implements CollectionUnshareWorker {
  const CollectionLocationGroupUnshareWorker();
}

class CollectionLocationGroupImportPendingSharedWorker
    with CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  const CollectionLocationGroupImportPendingSharedWorker();
}

class CollectionLocationGroupAdaptToNewItemWorker
    implements CollectionAdaptToNewItemWorker {
  const CollectionLocationGroupAdaptToNewItemWorker();

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    }
    throw UnsupportedError("Unsupported type: ${original.runtimeType}");
  }
}

class CollectionLocationGroupIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionLocationGroupIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => false;
}

class CollectionLocationGroupIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionLocationGroupIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => true;
}

class CollectionLocationGroupRemoveWorker
    with CollectionWorkerNoRemoveTag
    implements CollectionRemoveWorker {
  const CollectionLocationGroupRemoveWorker();
}

class CollectionLocationGroupIsPermittedWorker
    implements CollectionIsPermittedWorker {
  CollectionLocationGroupIsPermittedWorker(Collection collection)
    : _provider = collection.contentProvider as CollectionLocationGroupProvider;

  @override
  bool isPermitted(CollectionCapability capability) =>
      _provider.capabilities.contains(capability);

  final CollectionLocationGroupProvider _provider;
}

class CollectionLocationGroupIsManualCoverWorker
    implements CollectionIsManualCoverWorker {
  const CollectionLocationGroupIsManualCoverWorker();

  @override
  bool isManualCover() => false;
}

class CollectionLocationGroupUpdatePostLoadWorker
    implements CollectionUpdatePostLoadWorker {
  const CollectionLocationGroupUpdatePostLoadWorker();

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);
}
