import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/ad_hoc.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection/worker/mixin.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/use_case/find_file_descriptor.dart';

class CollectionAdHocListItemWorker implements CollectionListItemWorker {
  CollectionAdHocListItemWorker(this._c, this.account, this.collection)
    : _provider = collection.contentProvider as CollectionAdHocProvider;

  @override
  Stream<List<CollectionItem>> listItem() async* {
    final files = await FindFileDescriptor(_c)(
      account,
      _provider.fileIds,
      onFileNotFound: (_) {
        // ignore not found
      },
    );
    yield files
        .where((f) => file_util.isSupportedFormat(f))
        .map((f) => BasicCollectionFileItem(f))
        .toList();
  }

  final DiContainer _c;
  final Account account;
  final Collection collection;

  final CollectionAdHocProvider _provider;
}

class CollectionAdHocAddFilesWorker
    with CollectionWorkerNoAddFileTag
    implements CollectionAddFilesWorker {
  const CollectionAdHocAddFilesWorker();
}

class CollectionAdHocEditWorker
    with CollectionWorkerNoEditTag
    implements CollectionEditWorker {
  const CollectionAdHocEditWorker();
}

class CollectionAdHocRemoveItemsWorker
    with CollectionWorkerNoRemoveItemsTag
    implements CollectionRemoveItemsWorker {
  const CollectionAdHocRemoveItemsWorker();
}

class CollectionAdHocShareWorker
    with CollectionWorkerNoShareTag
    implements CollectionShareWorker {
  const CollectionAdHocShareWorker();
}

class CollectionAdHocUnshareWorker
    with CollectionWorkerNoUnshareTag
    implements CollectionUnshareWorker {
  const CollectionAdHocUnshareWorker();
}

class CollectionAdHocImportPendingSharedWorker
    with CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  const CollectionAdHocImportPendingSharedWorker();
}

class CollectionAdHocAdaptToNewItemWorker
    implements CollectionAdaptToNewItemWorker {
  const CollectionAdHocAdaptToNewItemWorker();

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    }
    throw UnsupportedError("Unsupported type: ${original.runtimeType}");
  }
}

class CollectionAdHocIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionAdHocIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => false;
}

class CollectionAdHocIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionAdHocIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => true;
}

class CollectionAdHocRemoveWorker
    with CollectionWorkerNoRemoveTag
    implements CollectionRemoveWorker {
  const CollectionAdHocRemoveWorker();
}

class CollectionAdHocIsPermittedWorker implements CollectionIsPermittedWorker {
  CollectionAdHocIsPermittedWorker(Collection collection)
    : _provider = collection.contentProvider as CollectionAdHocProvider;

  @override
  bool isPermitted(CollectionCapability capability) =>
      _provider.capabilities.contains(capability);

  final CollectionAdHocProvider _provider;
}

class CollectionAdHocIsManualCoverWorker
    implements CollectionIsManualCoverWorker {
  const CollectionAdHocIsManualCoverWorker();

  @override
  bool isManualCover() => false;
}

class CollectionAdHocUpdatePostLoadWorker
    implements CollectionUpdatePostLoadWorker {
  const CollectionAdHocUpdatePostLoadWorker();

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);
}
