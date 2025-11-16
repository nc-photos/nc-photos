part of 'collection_browser.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.collection,
    this.cover,
    required this.items,
    required this.rawItems,
    this.itemsWhitelist,
    required this.isLoading,
    required this.transformedItems,
    required this.selectedItems,
    required this.isSelectionRemovable,
    required this.isSelectionManageableFile,
    required this.isSelectionDeletable,
    required this.isEditMode,
    required this.isEditBusy,
    this.editName,
    this.editItems,
    this.editTransformedItems,
    this.editSort,
    required this.isAddMapBusy,
    required this.placePickerRequest,
    required this.isDragging,
    required this.zoom,
    this.scale,
    this.importResult,
    this.error,
    this.message,
  });

  factory _State.init({
    required Collection collection,
    required CollectionCoverResult? cover,
    required int zoom,
  }) {
    return _State(
      collection: collection,
      cover: cover,
      items: const [],
      rawItems: const [],
      isLoading: false,
      transformedItems: const [],
      selectedItems: const {},
      isSelectionRemovable: true,
      isSelectionManageableFile: true,
      isSelectionDeletable: true,
      isEditMode: false,
      isEditBusy: false,
      isAddMapBusy: false,
      placePickerRequest: Unique(null),
      isDragging: false,
      zoom: zoom,
    );
  }

  @override
  String toString() => _$toString();

  String get currentEditName => editName ?? collection.name;

  final Collection collection;
  final CollectionCoverResult? cover;
  final List<CollectionItem> items;
  final List<CollectionItem> rawItems;
  final Set<int>? itemsWhitelist;
  final bool isLoading;
  final List<_Item> transformedItems;

  final Set<_Item> selectedItems;
  final bool isSelectionRemovable;
  final bool isSelectionManageableFile;
  final bool isSelectionDeletable;

  final bool isEditMode;
  final bool isEditBusy;
  final String? editName;
  final List<CollectionItem>? editItems;
  final List<_Item>? editTransformedItems;
  final CollectionItemSort? editSort;
  final bool isAddMapBusy;
  final Unique<_PlacePickerRequest?> placePickerRequest;

  final bool isDragging;

  final int zoom;
  final double? scale;

  final Collection? importResult;

  final ExceptionEvent? error;
  final String? message;
}

abstract class _Event {}

@toString
class _UpdateCollection implements _Event {
  const _UpdateCollection(this.collection);

  @override
  String toString() => _$toString();

  final Collection collection;
}

/// Load the content of this collection
@toString
class _LoadItems implements _Event {
  const _LoadItems();

  @override
  String toString() => _$toString();
}

/// Transform the collection list (e.g., filtering, sorting, etc)
@toString
class _TransformItems implements _Event {
  const _TransformItems({required this.items});

  @override
  String toString() => _$toString();

  final List<CollectionItem> items;
}

@toString
class _ImportPendingSharedCollection implements _Event {
  const _ImportPendingSharedCollection();

  @override
  String toString() => _$toString();
}

@toString
class _Download implements _Event {
  const _Download();

  @override
  String toString() => _$toString();
}

@toString
class _Export implements _Event {
  const _Export();

  @override
  String toString() => _$toString();
}

@toString
class _BeginEdit implements _Event {
  const _BeginEdit();

  @override
  String toString() => _$toString();
}

@toString
class _EditName implements _Event {
  const _EditName(this.name);

  @override
  String toString() => _$toString();

  final String name;
}

@toString
class _AddLabelToCollection implements _Event {
  const _AddLabelToCollection(this.label);

  @override
  String toString() => _$toString();

  final String label;
}

@toString
class _RequestAddMap implements _Event {
  const _RequestAddMap();

  @override
  String toString() => _$toString();
}

@toString
class _AddMapToCollection implements _Event {
  const _AddMapToCollection(this.location);

  @override
  String toString() => _$toString();

  final CameraPosition location;
}

@toString
class _EditSort implements _Event {
  const _EditSort(this.sort);

  @override
  String toString() => _$toString();

  final CollectionItemSort sort;
}

@toString
class _EditManualSort implements _Event {
  const _EditManualSort(this.sorted);

  @override
  String toString() => _$toString();

  final List<_Item> sorted;
}

@toString
class _TransformEditItems implements _Event {
  const _TransformEditItems({required this.items});

  @override
  String toString() => _$toString();

  final List<CollectionItem> items;
}

@toString
class _DoneEdit implements _Event {
  const _DoneEdit();

  @override
  String toString() => _$toString();
}

@toString
class _CancelEdit implements _Event {
  const _CancelEdit();

  @override
  String toString() => _$toString();
}

@toString
class _UnsetCover implements _Event {
  const _UnsetCover();

  @override
  String toString() => _$toString();
}

/// Set the currently selected items
@toString
class _SetSelectedItems implements _Event {
  const _SetSelectedItems({required this.items});

  @override
  String toString() => _$toString();

  final Set<_Item> items;
}

/// Download the currently selected items
@toString
class _DownloadSelectedItems implements _Event {
  const _DownloadSelectedItems();

  @override
  String toString() => _$toString();
}

@toString
class _AddSelectedItemsToCollection implements _Event {
  const _AddSelectedItemsToCollection(this.collection);

  @override
  String toString() => _$toString();

  final Collection collection;
}

/// Remove the currently selected items from this collection
@toString
class _RemoveSelectedItemsFromCollection implements _Event {
  const _RemoveSelectedItemsFromCollection();

  @override
  String toString() => _$toString();
}

/// Archive the currently selected files
@toString
class _ArchiveSelectedItems implements _Event {
  const _ArchiveSelectedItems();

  @override
  String toString() => _$toString();
}

/// Delete the currently selected files
@toString
class _DeleteSelectedItems implements _Event {
  const _DeleteSelectedItems();

  @override
  String toString() => _$toString();
}

@toString
class _SetDragging implements _Event {
  const _SetDragging(this.flag);

  @override
  String toString() => _$toString();

  final bool flag;
}

@toString
class _StartScaling implements _Event {
  const _StartScaling();

  @override
  String toString() => _$toString();
}

@toString
class _EndScaling implements _Event {
  const _EndScaling();

  @override
  String toString() => _$toString();
}

@toString
class _SetScale implements _Event {
  const _SetScale(this.scale);

  @override
  String toString() => _$toString();

  final double scale;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}

@toString
class _SetMessage implements _Event {
  const _SetMessage(this.message);

  @override
  String toString() => _$toString();

  final String message;
}
