import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/tag.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection/worker/mixin.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/use_case/list_tagged_file.dart';

class CollectionTagListItemWorker implements CollectionListItemWorker {
  CollectionTagListItemWorker(this._c, this.account, this.collection)
    : _provider = collection.contentProvider as CollectionTagProvider;

  @override
  Stream<List<CollectionItem>> listItem() async* {
    final files = await ListTaggedFile(_c)(account, _provider.tags);
    yield files.map((f) => BasicCollectionFileItem(f)).toList();
  }

  final DiContainer _c;
  final Account account;
  final Collection collection;

  final CollectionTagProvider _provider;
}

class CollectionTagAddFilesWorker
    with CollectionWorkerNoAddFileTag
    implements CollectionAddFilesWorker {
  const CollectionTagAddFilesWorker();
}

class CollectionTagEditWorker
    with CollectionWorkerNoEditTag
    implements CollectionEditWorker {
  const CollectionTagEditWorker();
}

class CollectionTagRemoveItemsWorker
    with CollectionWorkerNoRemoveItemsTag
    implements CollectionRemoveItemsWorker {
  const CollectionTagRemoveItemsWorker();
}

class CollectionTagShareWorker
    with CollectionWorkerNoShareTag
    implements CollectionShareWorker {
  const CollectionTagShareWorker();
}

class CollectionTagUnshareWorker
    with CollectionWorkerNoUnshareTag
    implements CollectionUnshareWorker {
  const CollectionTagUnshareWorker();
}

class CollectionTagImportPendingSharedWorker
    with CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  const CollectionTagImportPendingSharedWorker();
}

class CollectionTagAdaptToNewItemWorker
    implements CollectionAdaptToNewItemWorker {
  const CollectionTagAdaptToNewItemWorker();

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    }
    throw UnsupportedError("Unsupported type: ${original.runtimeType}");
  }
}

class CollectionTagIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionTagIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => false;
}

class CollectionTagIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionTagIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => true;
}

class CollectionTagRemoveWorker
    with CollectionWorkerNoRemoveTag
    implements CollectionRemoveWorker {
  const CollectionTagRemoveWorker();
}

class CollectionTagIsPermittedWorker implements CollectionIsPermittedWorker {
  CollectionTagIsPermittedWorker(Collection collection)
    : _provider = collection.contentProvider as CollectionTagProvider;

  @override
  bool isPermitted(CollectionCapability capability) =>
      _provider.capabilities.contains(capability);

  final CollectionTagProvider _provider;
}

class CollectionTagIsManualCoverWorker
    implements CollectionIsManualCoverWorker {
  const CollectionTagIsManualCoverWorker();

  @override
  bool isManualCover() => false;
}

class CollectionTagUpdatePostLoadWorker
    implements CollectionUpdatePostLoadWorker {
  const CollectionTagUpdatePostLoadWorker();

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);
}
