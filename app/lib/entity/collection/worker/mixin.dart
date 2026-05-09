import 'package:flutter/foundation.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection/worker/factory.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_string/np_string.dart';

mixin CollectionWorkerNoAddFileTag implements CollectionAddFilesWorker {
  @override
  Future<int> addFiles(
    List<FileDescriptor> files, {
    ErrorWithValueHandler<FileDescriptor>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  }) {
    throw UnsupportedError("Operation not supported");
  }
}

mixin CollectionWorkerNoEditTag implements CollectionEditWorker {
  @override
  Future<Collection> edit({
    String? name,
    List<CollectionItem>? items,
    CollectionItemSort? itemSort,
    OrNull<FileDescriptor>? cover,
    List<CollectionItem>? knownItems,
  }) {
    throw UnsupportedError("Operation not supported");
  }
}

mixin CollectionWorkerNoRemoveItemsTag implements CollectionRemoveItemsWorker {
  @override
  Future<int> removeItems(
    List<CollectionItem> items, {
    ErrorWithValueIndexedHandler<CollectionItem>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  }) {
    throw UnsupportedError("Operation not supported");
  }
}

mixin CollectionWorkerNoShareTag implements CollectionShareWorker {
  @override
  Future<CollectionShareResult> share(
    Sharee sharee, {
    required ValueChanged<Collection> onCollectionUpdated,
  }) {
    throw UnsupportedError("Operation not supported");
  }
}

mixin CollectionWorkerNoUnshareTag implements CollectionUnshareWorker {
  @override
  Future<CollectionShareResult> unshare(
    CiString userId, {
    required ValueChanged<Collection> onCollectionUpdated,
  }) {
    throw UnsupportedError("Operation not supported");
  }
}

mixin CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  @override
  Future<Collection> importPendingShared() {
    throw UnsupportedError("Operation not supported");
  }
}

mixin CollectionWorkerNoRemoveTag implements CollectionRemoveWorker {
  @override
  Future<void> remove() {
    throw UnsupportedError("Operation not supported");
  }
}

// Shared concrete workers for common cases

class CollectionNoOpEditWorker
    with CollectionWorkerNoEditTag
    implements CollectionEditWorker {
  const CollectionNoOpEditWorker();
}

class CollectionNoOpRemoveItemsWorker
    with CollectionWorkerNoRemoveItemsTag
    implements CollectionRemoveItemsWorker {
  const CollectionNoOpRemoveItemsWorker();
}

class CollectionNoOpShareWorker
    with CollectionWorkerNoShareTag
    implements CollectionShareWorker {
  const CollectionNoOpShareWorker();
}

class CollectionNoOpUnshareWorker
    with CollectionWorkerNoUnshareTag
    implements CollectionUnshareWorker {
  const CollectionNoOpUnshareWorker();
}

class CollectionNoOpImportPendingSharedWorker
    with CollectionWorkerNoImportPendingSharedTag
    implements CollectionImportPendingSharedWorker {
  const CollectionNoOpImportPendingSharedWorker();
}

class CollectionNoOpRemoveWorker
    with CollectionWorkerNoRemoveTag
    implements CollectionRemoveWorker {
  const CollectionNoOpRemoveWorker();
}

class CollectionBasicAdaptToNewItemWorker
    implements CollectionAdaptToNewItemWorker {
  const CollectionBasicAdaptToNewItemWorker();

  @override
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original) async {
    if (original is NewCollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    }
    throw UnsupportedError("Unsupported type: ${original.runtimeType}");
  }
}

class CollectionNeverIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionNeverIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => false;
}

class CollectionAlwaysIsItemRemovableWorker
    implements CollectionIsItemRemovableWorker {
  const CollectionAlwaysIsItemRemovableWorker();

  @override
  bool isItemRemovable(CollectionItem item) => true;
}

class CollectionAlwaysIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionAlwaysIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => true;
}

class CollectionNeverIsItemDeletableWorker
    implements CollectionIsItemDeletableWorker {
  const CollectionNeverIsItemDeletableWorker();

  @override
  bool isItemDeletable(CollectionItem item) => false;
}

class CollectionCapabilitiesIsPermittedWorker
    implements CollectionIsPermittedWorker {
  const CollectionCapabilitiesIsPermittedWorker(this._capabilities);

  @override
  bool isPermitted(CollectionCapability capability) =>
      _capabilities.contains(capability);

  final List<CollectionCapability> _capabilities;
}

class CollectionFalseIsManualCoverWorker
    implements CollectionIsManualCoverWorker {
  const CollectionFalseIsManualCoverWorker();

  @override
  bool isManualCover() => false;
}

class CollectionNullUpdatePostLoadWorker
    implements CollectionUpdatePostLoadWorker {
  const CollectionNullUpdatePostLoadWorker();

  @override
  Future<Collection?> updatePostLoad(List<CollectionItem> items) =>
      Future.value(null);
}
