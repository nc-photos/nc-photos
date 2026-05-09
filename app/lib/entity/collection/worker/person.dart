import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/person.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection/worker/mixin.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/use_case/person/list_person_face.dart';

class CollectionPersonListItemWorker implements CollectionListItemWorker {
  CollectionPersonListItemWorker(
    this._c,
    this.account,
    this.collection, {
    required this.shouldUseRecognizeApiKey,
  }) : _provider = collection.contentProvider as CollectionPersonProvider;

  @override
  Stream<List<CollectionItem>> listItem() {
    final rootDirs = account.roots
        .map((e) => File(path: file_util.unstripPath(account, e)))
        .toList();
    return ListPersonFace(_c)(
      account,
      _provider.person,
      shouldUseRecognizeApiKey: shouldUseRecognizeApiKey,
    ).map((faces) {
      return faces
          .map((e) => e.file)
          .where(
            (f) =>
                file_util.isSupportedFormat(f) &&
                rootDirs.any((dir) => file_util.isUnderDir(f, dir)),
          )
          .map((f) => BasicCollectionFileItem(f))
          .toList();
    });
  }

  final DiContainer _c;
  final Account account;
  final Collection collection;
  final bool shouldUseRecognizeApiKey;

  final CollectionPersonProvider _provider;
}

class CollectionPersonAddFilesWorker
    with CollectionWorkerNoAddFileTag
    implements CollectionAddFilesWorker {
  const CollectionPersonAddFilesWorker();
}

class CollectionPersonEditWorker
    with CollectionWorkerNoEditTag
    implements CollectionEditWorker {
  const CollectionPersonEditWorker();
}

class CollectionPersonRemoveItemsWorker
    with CollectionWorkerNoRemoveItemsTag
    implements CollectionRemoveItemsWorker {
  const CollectionPersonRemoveItemsWorker();
}

class CollectionPersonShareWorker
    with CollectionWorkerNoShareTag
    implements CollectionShareWorker {
  const CollectionPersonShareWorker();
}

class CollectionPersonUnshareWorker
    with CollectionWorkerNoUnshareTag
    implements CollectionUnshareWorker {
  const CollectionPersonUnshareWorker();
}

class CollectionPersonImportPendingSharedWorker
    with CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  const CollectionPersonImportPendingSharedWorker();
}

class CollectionPersonAdaptToNewItemWorker
    implements CollectionAdaptToNewItemWorker {
  const CollectionPersonAdaptToNewItemWorker();

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    }
    throw UnsupportedError("Unsupported type: ${original.runtimeType}");
  }
}

class CollectionPersonIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionPersonIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => false;
}

class CollectionPersonIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionPersonIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => true;
}

class CollectionPersonRemoveWorker
    with CollectionWorkerNoRemoveTag
    implements CollectionRemoveWorker {
  const CollectionPersonRemoveWorker();
}

class CollectionPersonIsPermittedWorker implements CollectionIsPermittedWorker {
  CollectionPersonIsPermittedWorker(Collection collection)
    : _provider = collection.contentProvider as CollectionPersonProvider;

  @override
  bool isPermitted(CollectionCapability capability) =>
      _provider.capabilities.contains(capability);

  final CollectionPersonProvider _provider;
}

class CollectionPersonIsManualCoverWorker
    implements CollectionIsManualCoverWorker {
  const CollectionPersonIsManualCoverWorker();

  @override
  bool isManualCover() => false;
}

class CollectionPersonUpdatePostLoadWorker
    implements CollectionUpdatePostLoadWorker {
  const CollectionPersonUpdatePostLoadWorker();

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);
}
