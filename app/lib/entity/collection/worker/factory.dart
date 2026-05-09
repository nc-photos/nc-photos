import 'package:flutter/foundation.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/ad_hoc.dart';
import 'package:nc_photos/entity/collection/content_provider/album.dart';
import 'package:nc_photos/entity/collection/content_provider/location_group.dart';
import 'package:nc_photos/entity/collection/content_provider/memory.dart';
import 'package:nc_photos/entity/collection/content_provider/nc_album.dart';
import 'package:nc_photos/entity/collection/content_provider/person.dart';
import 'package:nc_photos/entity/collection/content_provider/tag.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/collection/worker/ad_hoc.dart';
import 'package:nc_photos/entity/collection/worker/album.dart';
import 'package:nc_photos/entity/collection/worker/location_group.dart';
import 'package:nc_photos/entity/collection/worker/memory.dart';
import 'package:nc_photos/entity/collection/worker/nc_album.dart';
import 'package:nc_photos/entity/collection/worker/person.dart';
import 'package:nc_photos/entity/collection/worker/tag.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:np_string/np_string.dart';

abstract interface class CollectionWorkerFactory {
  static CollectionListItemWorker listItem(
    DiContainer c,
    Account account,
    Collection collection, {
    required bool shouldUseRecognizeApiKey,
  }) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => CollectionAdHocListItemWorker(
        c,
        account,
        collection,
      ),
      const (CollectionAlbumProvider) => CollectionAlbumListItemWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        CollectionLocationGroupListItemWorker(c, account, collection),
      const (CollectionMemoryProvider) => CollectionMemoryListItemWorker(
        c,
        account,
        collection,
      ),
      const (CollectionNcAlbumProvider) => CollectionNcAlbumListItemWorker(
        c,
        account,
        collection,
      ),
      const (CollectionPersonProvider) => CollectionPersonListItemWorker(
        c,
        account,
        collection,
        shouldUseRecognizeApiKey: shouldUseRecognizeApiKey,
      ),
      const (CollectionTagProvider) => CollectionTagListItemWorker(
        c,
        account,
        collection,
      ),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionAddFilesWorker addFiles(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocAddFilesWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumAddFilesWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupAddFilesWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryAddFilesWorker(),
      const (CollectionNcAlbumProvider) => CollectionNcAlbumAddFilesWorker(
        c,
        account,
        collection,
      ),
      const (CollectionPersonProvider) => const CollectionPersonAddFilesWorker(),
      const (CollectionTagProvider) => const CollectionTagAddFilesWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionEditWorker edit(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocEditWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumEditWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupEditWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryEditWorker(),
      const (CollectionNcAlbumProvider) => CollectionNcAlbumEditWorker(
        c,
        account,
        collection,
      ),
      const (CollectionPersonProvider) => const CollectionPersonEditWorker(),
      const (CollectionTagProvider) => const CollectionTagEditWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionRemoveItemsWorker removeItems(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocRemoveItemsWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumRemoveItemsWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupRemoveItemsWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryRemoveItemsWorker(),
      const (CollectionNcAlbumProvider) => CollectionNcAlbumRemoveItemsWorker(
        c,
        account,
        collection,
      ),
      const (CollectionPersonProvider) => const CollectionPersonRemoveItemsWorker(),
      const (CollectionTagProvider) => const CollectionTagRemoveItemsWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionShareWorker share(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocShareWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumShareWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupShareWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryShareWorker(),
      const (CollectionNcAlbumProvider) => const CollectionNcAlbumShareWorker(),
      const (CollectionPersonProvider) => const CollectionPersonShareWorker(),
      const (CollectionTagProvider) => const CollectionTagShareWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionUnshareWorker unshare(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocUnshareWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumUnshareWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupUnshareWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryUnshareWorker(),
      const (CollectionNcAlbumProvider) => const CollectionNcAlbumUnshareWorker(),
      const (CollectionPersonProvider) => const CollectionPersonUnshareWorker(),
      const (CollectionTagProvider) => const CollectionTagUnshareWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionImportPendingSharedWorker importPendingShared(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) =>
        const CollectionAdHocImportPendingSharedWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumImportPendingSharedWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupImportPendingSharedWorker(),
      const (CollectionMemoryProvider) =>
        const CollectionMemoryImportPendingSharedWorker(),
      const (CollectionNcAlbumProvider) =>
        const CollectionNcAlbumImportPendingSharedWorker(),
      const (CollectionPersonProvider) =>
        const CollectionPersonImportPendingSharedWorker(),
      const (CollectionTagProvider) => const CollectionTagImportPendingSharedWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionAdaptToNewItemWorker adaptToNewItem(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocAdaptToNewItemWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumAdaptToNewItemWorker(
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupAdaptToNewItemWorker(),
      const (CollectionMemoryProvider) =>
        const CollectionMemoryAdaptToNewItemWorker(),
      const (CollectionNcAlbumProvider) =>
        const CollectionNcAlbumAdaptToNewItemWorker(),
      const (CollectionPersonProvider) =>
        const CollectionPersonAdaptToNewItemWorker(),
      const (CollectionTagProvider) => const CollectionTagAdaptToNewItemWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionIsItemRemovableWorker isItemRemovable(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocIsItemRemovableWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumIsItemRemovableWorker(
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupIsItemRemovableWorker(),
      const (CollectionMemoryProvider) =>
        const CollectionMemoryIsItemRemovableWorker(),
      const (CollectionNcAlbumProvider) =>
        const CollectionNcAlbumIsItemRemovableWorker(),
      const (CollectionPersonProvider) =>
        const CollectionPersonIsItemRemovableWorker(),
      const (CollectionTagProvider) => const CollectionTagIsItemRemovableWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionIsItemDeletableWorker isItemDeletable(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocIsItemDeletableWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumIsItemDeletableWorker(
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupIsItemDeletableWorker(),
      const (CollectionMemoryProvider) =>
        const CollectionMemoryIsItemDeletableWorker(),
      const (CollectionNcAlbumProvider) =>
        const CollectionNcAlbumIsItemDeletableWorker(),
      const (CollectionPersonProvider) =>
        const CollectionPersonIsItemDeletableWorker(),
      const (CollectionTagProvider) => const CollectionTagIsItemDeletableWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionRemoveWorker remove(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocRemoveWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumRemoveWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupRemoveWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryRemoveWorker(),
      const (CollectionNcAlbumProvider) => CollectionNcAlbumRemoveWorker(
        c,
        account,
        collection,
      ),
      const (CollectionPersonProvider) => const CollectionPersonRemoveWorker(),
      const (CollectionTagProvider) => const CollectionTagRemoveWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionIsPermittedWorker isPermitted(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => CollectionAdHocIsPermittedWorker(collection),
      const (CollectionAlbumProvider) => CollectionAlbumIsPermittedWorker(
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        CollectionLocationGroupIsPermittedWorker(collection),
      const (CollectionMemoryProvider) => CollectionMemoryIsPermittedWorker(
        collection,
      ),
      const (CollectionNcAlbumProvider) => CollectionNcAlbumIsPermittedWorker(
        collection,
      ),
      const (CollectionPersonProvider) => CollectionPersonIsPermittedWorker(
        collection,
      ),
      const (CollectionTagProvider) => CollectionTagIsPermittedWorker(collection),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionIsManualCoverWorker isManualCover(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocIsManualCoverWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumIsManualCoverWorker(
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupIsManualCoverWorker(),
      const (CollectionMemoryProvider) => const CollectionMemoryIsManualCoverWorker(),
      const (CollectionNcAlbumProvider) =>
        const CollectionNcAlbumIsManualCoverWorker(),
      const (CollectionPersonProvider) => const CollectionPersonIsManualCoverWorker(),
      const (CollectionTagProvider) => const CollectionTagIsManualCoverWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }

  static CollectionUpdatePostLoadWorker updatePostLoad(
    DiContainer c,
    Account account,
    Collection collection,
  ) {
    return switch (collection.contentProvider.runtimeType) {
      const (CollectionAdHocProvider) => const CollectionAdHocUpdatePostLoadWorker(),
      const (CollectionAlbumProvider) => CollectionAlbumUpdatePostLoadWorker(
        c,
        account,
        collection,
      ),
      const (CollectionLocationGroupProvider) =>
        const CollectionLocationGroupUpdatePostLoadWorker(),
      const (CollectionMemoryProvider) =>
        const CollectionMemoryUpdatePostLoadWorker(),
      const (CollectionNcAlbumProvider) =>
        const CollectionNcAlbumUpdatePostLoadWorker(),
      const (CollectionPersonProvider) =>
        const CollectionPersonUpdatePostLoadWorker(),
      const (CollectionTagProvider) => const CollectionTagUpdatePostLoadWorker(),
      _ => throw UnsupportedError(
        "Unknown type: ${collection.contentProvider.runtimeType}",
      ),
    };
  }
}

abstract interface class CollectionListItemWorker {
  /// List items inside this collection
  Stream<List<CollectionItem>> listItem();
}

abstract interface class CollectionAddFilesWorker {
  /// Add [files] to this collection and return the added count
  Future<int> addFiles(
    List<FileDescriptor> files, {
    ErrorWithValueHandler<FileDescriptor>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  });
}

abstract interface class CollectionEditWorker {
  /// Edit this collection
  Future<Collection> edit({
    String? name,
    List<CollectionItem>? items,
    CollectionItemSort? itemSort,
    OrNull<FileDescriptor>? cover,
    List<CollectionItem>? knownItems,
  });
}

abstract interface class CollectionRemoveItemsWorker {
  /// Remove [items] from this collection and return the removed count
  Future<int> removeItems(
    List<CollectionItem> items, {
    ErrorWithValueIndexedHandler<CollectionItem>? onError,
    required ValueChanged<Collection> onCollectionUpdated,
  });
}

abstract interface class CollectionShareWorker {
  /// Share the collection with [sharee]
  Future<CollectionShareResult> share(
    Sharee sharee, {
    required ValueChanged<Collection> onCollectionUpdated,
  });
}

abstract interface class CollectionUnshareWorker {
  /// Unshare the collection with a user
  Future<CollectionShareResult> unshare(
    CiString userId, {
    required ValueChanged<Collection> onCollectionUpdated,
  });
}

abstract interface class CollectionImportPendingSharedWorker {
  /// Import a pending shared collection and return the resulting collection
  Future<Collection> importPendingShared();
}

abstract interface class CollectionAdaptToNewItemWorker {
  /// Convert a [NewCollectionItem] to an adapted one
  Future<CollectionItem> adaptToNewItem(NewCollectionItem original);
}

abstract interface class CollectionIsItemRemovableWorker {
  bool isItemRemovable(CollectionItem item);
}

abstract interface class CollectionIsItemDeletableWorker {
  bool isItemDeletable(CollectionItem item);
}

abstract interface class CollectionRemoveWorker {
  /// Remove this collection
  Future<void> remove();
}

abstract interface class CollectionIsPermittedWorker {
  /// Return if this capability is allowed
  bool isPermitted(CollectionCapability capability);
}

abstract interface class CollectionIsManualCoverWorker {
  /// Return if the cover of this collection has been manually set
  bool isManualCover();
}

abstract interface class CollectionUpdatePostLoadWorker {
  /// Called when the collection items belonging to this collection is first
  /// loaded
  Future<Collection?> updatePostLoad(List<CollectionItem> items);
}
