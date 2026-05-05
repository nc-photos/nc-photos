import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/memory.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection/worker/mixin.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/pref.dart';
import 'package:np_datetime/np_datetime.dart';

class CollectionMemoryListItemWorker implements CollectionListItemWorker {
  CollectionMemoryListItemWorker(this._c, this.account, this.collection)
    : _provider = collection.contentProvider as CollectionMemoryProvider;

  @override
  Stream<List<CollectionItem>> listItem() async* {
    final date = DateTime(_provider.year, _provider.month, _provider.day);
    final dayRange = _c.pref.getMemoriesRangeOr();
    final from = date.subtract(Duration(days: dayRange));
    final to = date.add(Duration(days: dayRange + 1));
    final files = await _c.fileRepo2.getFileDescriptors(
      account,
      file_util.unstripPath(
        account,
        AccountPref.of(account).getShareFolderOr(),
      ),
      timeRange: TimeRange(from: from, to: to),
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

  final CollectionMemoryProvider _provider;
}

class CollectionMemoryAddFilesWorker
    with CollectionWorkerNoAddFileTag
    implements CollectionAddFilesWorker {
  const CollectionMemoryAddFilesWorker();
}

class CollectionMemoryEditWorker
    with CollectionWorkerNoEditTag
    implements CollectionEditWorker {
  const CollectionMemoryEditWorker();
}

class CollectionMemoryRemoveItemsWorker
    with CollectionWorkerNoRemoveItemsTag
    implements CollectionRemoveItemsWorker {
  const CollectionMemoryRemoveItemsWorker();
}

class CollectionMemoryShareWorker
    with CollectionWorkerNoShareTag
    implements CollectionShareWorker {
  const CollectionMemoryShareWorker();
}

class CollectionMemoryUnshareWorker
    with CollectionWorkerNoUnshareTag
    implements CollectionUnshareWorker {
  const CollectionMemoryUnshareWorker();
}

class CollectionMemoryImportPendingSharedWorker
    with CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  const CollectionMemoryImportPendingSharedWorker();
}

class CollectionMemoryAdaptToNewItemWorker
    implements CollectionAdaptToNewItemWorker {
  const CollectionMemoryAdaptToNewItemWorker();

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    }
    throw UnsupportedError("Unsupported type: ${original.runtimeType}");
  }
}

class CollectionMemoryIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionMemoryIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => false;
}

class CollectionMemoryIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionMemoryIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => true;
}

class CollectionMemoryRemoveWorker
    with CollectionWorkerNoRemoveTag
    implements CollectionRemoveWorker {
  const CollectionMemoryRemoveWorker();
}

class CollectionMemoryIsPermittedWorker implements CollectionIsPermittedWorker {
  CollectionMemoryIsPermittedWorker(Collection collection)
    : _provider = collection.contentProvider as CollectionMemoryProvider;

  @override
  bool isPermitted(CollectionCapability capability) =>
      _provider.capabilities.contains(capability);

  final CollectionMemoryProvider _provider;
}

class CollectionMemoryIsManualCoverWorker
    implements CollectionIsManualCoverWorker {
  const CollectionMemoryIsManualCoverWorker();

  @override
  bool isManualCover() => false;
}

class CollectionMemoryUpdatePostLoadWorker
    implements CollectionUpdatePostLoadWorker {
  const CollectionMemoryUpdatePostLoadWorker();

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);
}
