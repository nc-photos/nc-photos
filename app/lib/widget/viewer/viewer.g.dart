// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $ViewerPositionInfoCopyWithWorker {
  ViewerPositionInfo call({int? pageIndex, AnyFile? originalFile});
}

class _$ViewerPositionInfoCopyWithWorkerImpl
    implements $ViewerPositionInfoCopyWithWorker {
  _$ViewerPositionInfoCopyWithWorkerImpl(this.that);

  @override
  ViewerPositionInfo call({dynamic pageIndex, dynamic originalFile}) {
    return ViewerPositionInfo(
      pageIndex: pageIndex as int? ?? that.pageIndex,
      originalFile: originalFile as AnyFile? ?? that.originalFile,
    );
  }

  final ViewerPositionInfo that;
}

extension $ViewerPositionInfoCopyWith on ViewerPositionInfo {
  $ViewerPositionInfoCopyWithWorker get copyWith => _$copyWith;
  $ViewerPositionInfoCopyWithWorker get _$copyWith =>
      _$ViewerPositionInfoCopyWithWorkerImpl(this);
}

abstract class $_StateCopyWithWorker {
  _State call({
    Map<int, String>? pageAfIdMap,
    Map<String, AnyFile>? anyFiles,
    Map<String, AnyFile>? mergedAfIdFileMap,
    Map<String, _PageState>? fileStates,
    int? index,
    AnyFile? currentFile,
    _PageState? currentFileState,
    Collection? collection,
    CollectionItemsController? collectionItemsController,
    Map<String, CollectionFileItem>? collectionItems,
    bool? isShowDetailPane,
    bool? isClosingDetailPane,
    bool? isDetailPaneActive,
    Unique<_OpenDetailPaneRequest>? openDetailPaneRequest,
    Unique<bool>? closeDetailPane,
    bool? isZoomed,
    bool? isInitialLoad,
    int? forwardBound,
    int? backwardBound,
    bool? isShowAppBar,
    List<ViewerAppBarButtonType>? appBarButtons,
    List<ViewerAppBarButtonType>? bottomAppBarButtons,
    Unique<AnyFile?>? pendingRemoveFile,
    List<String>? removedAfIds,
    Unique<ImageEditorArguments?>? imageEditorRequest,
    Unique<ImageEnhancerArguments?>? imageEnhancerRequest,
    Unique<_ShareRequest?>? shareRequest,
    Unique<_StartSlideshowRequest?>? startSlideshowRequest,
    Unique<_SlideshowRequest?>? slideshowRequest,
    Unique<_SetAsRequest?>? setAsRequest,
    Unique<_UploadRequest?>? uploadRequest,
    bool? isBusy,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic pageAfIdMap,
    dynamic anyFiles,
    dynamic mergedAfIdFileMap,
    dynamic fileStates,
    dynamic index,
    dynamic currentFile = copyWithNull,
    dynamic currentFileState = copyWithNull,
    dynamic collection = copyWithNull,
    dynamic collectionItemsController = copyWithNull,
    dynamic collectionItems = copyWithNull,
    dynamic isShowDetailPane,
    dynamic isClosingDetailPane,
    dynamic isDetailPaneActive,
    dynamic openDetailPaneRequest,
    dynamic closeDetailPane,
    dynamic isZoomed,
    dynamic isInitialLoad,
    dynamic forwardBound = copyWithNull,
    dynamic backwardBound = copyWithNull,
    dynamic isShowAppBar,
    dynamic appBarButtons,
    dynamic bottomAppBarButtons,
    dynamic pendingRemoveFile,
    dynamic removedAfIds,
    dynamic imageEditorRequest,
    dynamic imageEnhancerRequest,
    dynamic shareRequest,
    dynamic startSlideshowRequest,
    dynamic slideshowRequest,
    dynamic setAsRequest,
    dynamic uploadRequest,
    dynamic isBusy,
    dynamic error = copyWithNull,
  }) {
    return _State(
      pageAfIdMap: pageAfIdMap as Map<int, String>? ?? that.pageAfIdMap,
      anyFiles: anyFiles as Map<String, AnyFile>? ?? that.anyFiles,
      mergedAfIdFileMap:
          mergedAfIdFileMap as Map<String, AnyFile>? ?? that.mergedAfIdFileMap,
      fileStates: fileStates as Map<String, _PageState>? ?? that.fileStates,
      index: index as int? ?? that.index,
      currentFile:
          currentFile == copyWithNull
              ? that.currentFile
              : currentFile as AnyFile?,
      currentFileState:
          currentFileState == copyWithNull
              ? that.currentFileState
              : currentFileState as _PageState?,
      collection:
          collection == copyWithNull
              ? that.collection
              : collection as Collection?,
      collectionItemsController:
          collectionItemsController == copyWithNull
              ? that.collectionItemsController
              : collectionItemsController as CollectionItemsController?,
      collectionItems:
          collectionItems == copyWithNull
              ? that.collectionItems
              : collectionItems as Map<String, CollectionFileItem>?,
      isShowDetailPane: isShowDetailPane as bool? ?? that.isShowDetailPane,
      isClosingDetailPane:
          isClosingDetailPane as bool? ?? that.isClosingDetailPane,
      isDetailPaneActive:
          isDetailPaneActive as bool? ?? that.isDetailPaneActive,
      openDetailPaneRequest:
          openDetailPaneRequest as Unique<_OpenDetailPaneRequest>? ??
          that.openDetailPaneRequest,
      closeDetailPane: closeDetailPane as Unique<bool>? ?? that.closeDetailPane,
      isZoomed: isZoomed as bool? ?? that.isZoomed,
      isInitialLoad: isInitialLoad as bool? ?? that.isInitialLoad,
      forwardBound:
          forwardBound == copyWithNull
              ? that.forwardBound
              : forwardBound as int?,
      backwardBound:
          backwardBound == copyWithNull
              ? that.backwardBound
              : backwardBound as int?,
      isShowAppBar: isShowAppBar as bool? ?? that.isShowAppBar,
      appBarButtons:
          appBarButtons as List<ViewerAppBarButtonType>? ?? that.appBarButtons,
      bottomAppBarButtons:
          bottomAppBarButtons as List<ViewerAppBarButtonType>? ??
          that.bottomAppBarButtons,
      pendingRemoveFile:
          pendingRemoveFile as Unique<AnyFile?>? ?? that.pendingRemoveFile,
      removedAfIds: removedAfIds as List<String>? ?? that.removedAfIds,
      imageEditorRequest:
          imageEditorRequest as Unique<ImageEditorArguments?>? ??
          that.imageEditorRequest,
      imageEnhancerRequest:
          imageEnhancerRequest as Unique<ImageEnhancerArguments?>? ??
          that.imageEnhancerRequest,
      shareRequest:
          shareRequest as Unique<_ShareRequest?>? ?? that.shareRequest,
      startSlideshowRequest:
          startSlideshowRequest as Unique<_StartSlideshowRequest?>? ??
          that.startSlideshowRequest,
      slideshowRequest:
          slideshowRequest as Unique<_SlideshowRequest?>? ??
          that.slideshowRequest,
      setAsRequest:
          setAsRequest as Unique<_SetAsRequest?>? ?? that.setAsRequest,
      uploadRequest:
          uploadRequest as Unique<_UploadRequest?>? ?? that.uploadRequest,
      isBusy: isBusy as bool? ?? that.isBusy,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

abstract class $_PageStateCopyWithWorker {
  _PageState call({
    double? itemHeight,
    bool? hasLoaded,
    bool? shouldPlayLivePhoto,
  });
}

class _$_PageStateCopyWithWorkerImpl implements $_PageStateCopyWithWorker {
  _$_PageStateCopyWithWorkerImpl(this.that);

  @override
  _PageState call({
    dynamic itemHeight = copyWithNull,
    dynamic hasLoaded,
    dynamic shouldPlayLivePhoto,
  }) {
    return _PageState(
      itemHeight:
          itemHeight == copyWithNull ? that.itemHeight : itemHeight as double?,
      hasLoaded: hasLoaded as bool? ?? that.hasLoaded,
      shouldPlayLivePhoto:
          shouldPlayLivePhoto as bool? ?? that.shouldPlayLivePhoto,
    );
  }

  final _PageState that;
}

extension $_PageStateCopyWith on _PageState {
  $_PageStateCopyWithWorker get copyWith => _$copyWith;
  $_PageStateCopyWithWorker get _$copyWith =>
      _$_PageStateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_WrappedViewerStateNpLog on _WrappedViewerState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.viewer.viewer._WrappedViewerState");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.viewer.viewer._Bloc");
}

extension _$_ContentBodyStateNpLog on _ContentBodyState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.viewer.viewer._ContentBodyState");
}

extension _$_PageViewStateNpLog on _PageViewState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.viewer.viewer._PageViewState");
}

extension _$_ViewerContentControllerNpLog on _ViewerContentController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.viewer.viewer._ViewerContentController");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$ViewerContentProviderResultToString on ViewerContentProviderResult {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ViewerContentProviderResult {files: ${files.map((e) => e.id).toReadableString()}}";
  }
}

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {pageAfIdMap: {length: ${pageAfIdMap.length}}, anyFiles: {length: ${anyFiles.length}}, mergedAfIdFileMap: {length: ${mergedAfIdFileMap.length}}, fileStates: {length: ${fileStates.length}}, index: $index, currentFile: $currentFile, currentFileState: $currentFileState, collection: $collection, collectionItemsController: $collectionItemsController, collectionItems: ${collectionItems == null ? null : "{length: ${collectionItems!.length}}"}, isShowDetailPane: $isShowDetailPane, isClosingDetailPane: $isClosingDetailPane, isDetailPaneActive: $isDetailPaneActive, openDetailPaneRequest: $openDetailPaneRequest, closeDetailPane: $closeDetailPane, isZoomed: $isZoomed, isInitialLoad: $isInitialLoad, forwardBound: $forwardBound, backwardBound: $backwardBound, isShowAppBar: $isShowAppBar, appBarButtons: [length: ${appBarButtons.length}], bottomAppBarButtons: [length: ${bottomAppBarButtons.length}], pendingRemoveFile: $pendingRemoveFile, removedAfIds: [length: ${removedAfIds.length}], imageEditorRequest: $imageEditorRequest, imageEnhancerRequest: $imageEnhancerRequest, shareRequest: $shareRequest, startSlideshowRequest: $startSlideshowRequest, slideshowRequest: $slideshowRequest, setAsRequest: $setAsRequest, uploadRequest: $uploadRequest, isBusy: $isBusy, error: $error}";
  }
}

extension _$_PageStateToString on _PageState {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PageState {itemHeight: ${itemHeight == null ? null : "${itemHeight!.toStringAsFixed(3)}"}, hasLoaded: $hasLoaded, shouldPlayLivePhoto: $shouldPlayLivePhoto}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetIndexToString on _SetIndex {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetIndex {index: $index}";
  }
}

extension _$_JumpToLastSlideshowToString on _JumpToLastSlideshow {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_JumpToLastSlideshow {index: $index, afId: $afId}";
  }
}

extension _$_SetCollectionToString on _SetCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCollection {collection: $collection, itemsController: $itemsController}";
  }
}

extension _$_SetCollectionItemsToString on _SetCollectionItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCollectionItems {value: ${value == null ? null : "[length: ${value!.length}]"}}";
  }
}

extension _$_MergeFilesToString on _MergeFiles {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_MergeFiles {}";
  }
}

extension _$_NewPageContentToString on _NewPageContent {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_NewPageContent {value: {length: ${value.length}}}";
  }
}

extension _$_SetForwardBoundToString on _SetForwardBound {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetForwardBound {value: $value}";
  }
}

extension _$_SetBackwardBoundToString on _SetBackwardBound {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetBackwardBound {value: $value}";
  }
}

extension _$_ToggleAppBarToString on _ToggleAppBar {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleAppBar {}";
  }
}

extension _$_ShowAppBarToString on _ShowAppBar {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ShowAppBar {}";
  }
}

extension _$_HideAppBarToString on _HideAppBar {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_HideAppBar {}";
  }
}

extension _$_SetAppBarButtonsToString on _SetAppBarButtons {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAppBarButtons {value: [length: ${value.length}]}";
  }
}

extension _$_SetBottomAppBarButtonsToString on _SetBottomAppBarButtons {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetBottomAppBarButtons {value: [length: ${value.length}]}";
  }
}

extension _$_PauseLivePhotoToString on _PauseLivePhoto {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PauseLivePhoto {afId: $afId}";
  }
}

extension _$_PlayLivePhotoToString on _PlayLivePhoto {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PlayLivePhoto {afId: $afId}";
  }
}

extension _$_UnfavoriteToString on _Unfavorite {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Unfavorite {afId: $afId}";
  }
}

extension _$_FavoriteToString on _Favorite {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Favorite {afId: $afId}";
  }
}

extension _$_UnarchiveToString on _Unarchive {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Unarchive {afId: $afId}";
  }
}

extension _$_ArchiveToString on _Archive {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Archive {afId: $afId}";
  }
}

extension _$_ShareToString on _Share {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Share {afId: $afId}";
  }
}

extension _$_EditToString on _Edit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Edit {afId: $afId}";
  }
}

extension _$_EnhanceToString on _Enhance {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Enhance {afId: $afId}";
  }
}

extension _$_DownloadToString on _Download {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Download {afId: $afId}";
  }
}

extension _$_DeleteToString on _Delete {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Delete {afId: $afId}";
  }
}

extension _$_RemoveFromCollectionToString on _RemoveFromCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RemoveFromCollection {value: $value}";
  }
}

extension _$_StartSlideshowToString on _StartSlideshow {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_StartSlideshow {afId: $afId}";
  }
}

extension _$_StartSlideshowResultToString on _StartSlideshowResult {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_StartSlideshowResult {request: $request, config: $config}";
  }
}

extension _$_SetAsToString on _SetAs {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAs {afId: $afId}";
  }
}

extension _$_UploadToString on _Upload {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Upload {afId: $afId}";
  }
}

extension _$_OpenDetailPaneToString on _OpenDetailPane {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OpenDetailPane {shouldAnimate: $shouldAnimate}";
  }
}

extension _$_CloseDetailPaneToString on _CloseDetailPane {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_CloseDetailPane {}";
  }
}

extension _$_DetailPaneClosedToString on _DetailPaneClosed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DetailPaneClosed {}";
  }
}

extension _$_ShowDetailPaneToString on _ShowDetailPane {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ShowDetailPane {}";
  }
}

extension _$_SetDetailPaneInactiveToString on _SetDetailPaneInactive {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDetailPaneInactive {}";
  }
}

extension _$_SetDetailPaneActiveToString on _SetDetailPaneActive {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetDetailPaneActive {}";
  }
}

extension _$_SetFileContentHeightToString on _SetFileContentHeight {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFileContentHeight {afId: $afId, value: ${value.toStringAsFixed(3)}}";
  }
}

extension _$_SetIsZoomedToString on _SetIsZoomed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetIsZoomed {value: $value}";
  }
}

extension _$_RemoveFileToString on _RemoveFile {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RemoveFile {file: $file}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
