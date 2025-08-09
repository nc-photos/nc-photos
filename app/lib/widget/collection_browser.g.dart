// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_browser.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    Collection? collection,
    CollectionCoverResult? cover,
    List<CollectionItem>? items,
    List<CollectionItem>? rawItems,
    Set<int>? itemsWhitelist,
    bool? isLoading,
    List<_Item>? transformedItems,
    Set<_Item>? selectedItems,
    bool? isSelectionRemovable,
    bool? isSelectionManageableFile,
    bool? isSelectionDeletable,
    bool? isEditMode,
    bool? isEditBusy,
    String? editName,
    List<CollectionItem>? editItems,
    List<_Item>? editTransformedItems,
    CollectionItemSort? editSort,
    bool? isAddMapBusy,
    Unique<_PlacePickerRequest?>? placePickerRequest,
    bool? isDragging,
    int? zoom,
    double? scale,
    Collection? importResult,
    ExceptionEvent? error,
    String? message,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic collection,
    dynamic cover = copyWithNull,
    dynamic items,
    dynamic rawItems,
    dynamic itemsWhitelist = copyWithNull,
    dynamic isLoading,
    dynamic transformedItems,
    dynamic selectedItems,
    dynamic isSelectionRemovable,
    dynamic isSelectionManageableFile,
    dynamic isSelectionDeletable,
    dynamic isEditMode,
    dynamic isEditBusy,
    dynamic editName = copyWithNull,
    dynamic editItems = copyWithNull,
    dynamic editTransformedItems = copyWithNull,
    dynamic editSort = copyWithNull,
    dynamic isAddMapBusy,
    dynamic placePickerRequest,
    dynamic isDragging,
    dynamic zoom,
    dynamic scale = copyWithNull,
    dynamic importResult = copyWithNull,
    dynamic error = copyWithNull,
    dynamic message = copyWithNull,
  }) {
    return _State(
      collection: collection as Collection? ?? that.collection,
      cover:
          cover == copyWithNull ? that.cover : cover as CollectionCoverResult?,
      items: items as List<CollectionItem>? ?? that.items,
      rawItems: rawItems as List<CollectionItem>? ?? that.rawItems,
      itemsWhitelist:
          itemsWhitelist == copyWithNull
              ? that.itemsWhitelist
              : itemsWhitelist as Set<int>?,
      isLoading: isLoading as bool? ?? that.isLoading,
      transformedItems:
          transformedItems as List<_Item>? ?? that.transformedItems,
      selectedItems: selectedItems as Set<_Item>? ?? that.selectedItems,
      isSelectionRemovable:
          isSelectionRemovable as bool? ?? that.isSelectionRemovable,
      isSelectionManageableFile:
          isSelectionManageableFile as bool? ?? that.isSelectionManageableFile,
      isSelectionDeletable:
          isSelectionDeletable as bool? ?? that.isSelectionDeletable,
      isEditMode: isEditMode as bool? ?? that.isEditMode,
      isEditBusy: isEditBusy as bool? ?? that.isEditBusy,
      editName: editName == copyWithNull ? that.editName : editName as String?,
      editItems:
          editItems == copyWithNull
              ? that.editItems
              : editItems as List<CollectionItem>?,
      editTransformedItems:
          editTransformedItems == copyWithNull
              ? that.editTransformedItems
              : editTransformedItems as List<_Item>?,
      editSort:
          editSort == copyWithNull
              ? that.editSort
              : editSort as CollectionItemSort?,
      isAddMapBusy: isAddMapBusy as bool? ?? that.isAddMapBusy,
      placePickerRequest:
          placePickerRequest as Unique<_PlacePickerRequest?>? ??
          that.placePickerRequest,
      isDragging: isDragging as bool? ?? that.isDragging,
      zoom: zoom as int? ?? that.zoom,
      scale: scale == copyWithNull ? that.scale : scale as double?,
      importResult:
          importResult == copyWithNull
              ? that.importResult
              : importResult as Collection?,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
      message: message == copyWithNull ? that.message : message as String?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_WrappedCollectionBrowserStateNpLog
    on _WrappedCollectionBrowserState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.collection_browser._WrappedCollectionBrowserState",
  );
}

extension _$_SelectionAppBarNpLog on _SelectionAppBar {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.collection_browser._SelectionAppBar");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.collection_browser._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {collection: $collection, cover: $cover, items: [length: ${items.length}], rawItems: [length: ${rawItems.length}], itemsWhitelist: ${itemsWhitelist == null ? null : "{length: ${itemsWhitelist!.length}}"}, isLoading: $isLoading, transformedItems: [length: ${transformedItems.length}], selectedItems: {length: ${selectedItems.length}}, isSelectionRemovable: $isSelectionRemovable, isSelectionManageableFile: $isSelectionManageableFile, isSelectionDeletable: $isSelectionDeletable, isEditMode: $isEditMode, isEditBusy: $isEditBusy, editName: $editName, editItems: ${editItems == null ? null : "[length: ${editItems!.length}]"}, editTransformedItems: ${editTransformedItems == null ? null : "[length: ${editTransformedItems!.length}]"}, editSort: ${editSort == null ? null : "${editSort!.name}"}, isAddMapBusy: $isAddMapBusy, placePickerRequest: $placePickerRequest, isDragging: $isDragging, zoom: $zoom, scale: ${scale == null ? null : "${scale!.toStringAsFixed(3)}"}, importResult: $importResult, error: $error, message: $message}";
  }
}

extension _$_UpdateCollectionToString on _UpdateCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UpdateCollection {collection: $collection}";
  }
}

extension _$_LoadItemsToString on _LoadItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadItems {}";
  }
}

extension _$_TransformItemsToString on _TransformItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformItems {items: [length: ${items.length}]}";
  }
}

extension _$_ImportPendingSharedCollectionToString
    on _ImportPendingSharedCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ImportPendingSharedCollection {}";
  }
}

extension _$_DownloadToString on _Download {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Download {}";
  }
}

extension _$_ExportToString on _Export {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Export {}";
  }
}

extension _$_BeginEditToString on _BeginEdit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_BeginEdit {}";
  }
}

extension _$_EditNameToString on _EditName {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EditName {name: $name}";
  }
}

extension _$_AddLabelToCollectionToString on _AddLabelToCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_AddLabelToCollection {label: $label}";
  }
}

extension _$_RequestAddMapToString on _RequestAddMap {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RequestAddMap {}";
  }
}

extension _$_AddMapToCollectionToString on _AddMapToCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_AddMapToCollection {location: $location}";
  }
}

extension _$_EditSortToString on _EditSort {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EditSort {sort: ${sort.name}}";
  }
}

extension _$_EditManualSortToString on _EditManualSort {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EditManualSort {sorted: [length: ${sorted.length}]}";
  }
}

extension _$_TransformEditItemsToString on _TransformEditItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformEditItems {items: [length: ${items.length}]}";
  }
}

extension _$_DoneEditToString on _DoneEdit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DoneEdit {}";
  }
}

extension _$_CancelEditToString on _CancelEdit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_CancelEdit {}";
  }
}

extension _$_UnsetCoverToString on _UnsetCover {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UnsetCover {}";
  }
}

extension _$_SetSelectedItemsToString on _SetSelectedItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSelectedItems {items: {length: ${items.length}}}";
  }
}

extension _$_DownloadSelectedItemsToString on _DownloadSelectedItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DownloadSelectedItems {}";
  }
}

extension _$_AddSelectedItemsToCollectionToString
    on _AddSelectedItemsToCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_AddSelectedItemsToCollection {collection: $collection}";
  }
}

extension _$_RemoveSelectedItemsFromCollectionToString
    on _RemoveSelectedItemsFromCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RemoveSelectedItemsFromCollection {}";
  }
}

extension _$_ArchiveSelectedItemsToString on _ArchiveSelectedItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ArchiveSelectedItems {}";
  }
}

extension _$_DeleteSelectedItemsToString on _DeleteSelectedItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DeleteSelectedItems {}";
  }
}

extension _$_SetDraggingToString on _SetDragging {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDragging {flag: $flag}";
  }
}

extension _$_StartScalingToString on _StartScaling {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_StartScaling {}";
  }
}

extension _$_EndScalingToString on _EndScaling {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EndScaling {}";
  }
}

extension _$_SetScaleToString on _SetScale {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetScale {scale: ${scale.toStringAsFixed(3)}}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}

extension _$_SetMessageToString on _SetMessage {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetMessage {message: $message}";
  }
}

extension _$_ArchiveFailedErrorToString on _ArchiveFailedError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ArchiveFailedError {count: $count}";
  }
}

extension _$_RemoveFailedErrorToString on _RemoveFailedError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RemoveFailedError {count: $count}";
  }
}
