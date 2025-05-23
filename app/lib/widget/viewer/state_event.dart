part of 'viewer.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.pageFileIdMap,
    required this.fileIdFileMap,
    required this.mergedFileIdFileMap,
    required this.fileStates,
    required this.index,
    required this.currentFile,
    this.currentFileState,
    this.collection,
    this.collectionItemsController,
    this.collectionItems,
    required this.isShowDetailPane,
    required this.isClosingDetailPane,
    required this.isDetailPaneActive,
    required this.openDetailPaneRequest,
    required this.closeDetailPane,
    required this.isZoomed,
    required this.isInitialLoad,
    required this.isShowAppBar,
    required this.appBarButtons,
    required this.bottomAppBarButtons,
    required this.pendingRemoveFile,
    required this.removedFileIds,
    required this.imageEditorRequest,
    required this.imageEnhancerRequest,
    required this.shareRequest,
    required this.startSlideshowRequest,
    required this.slideshowRequest,
    required this.setAsRequest,
    required this.isBusy,
    this.error,
  });

  factory _State.init({
    required int initialIndex,
    required FileDescriptor initialFile,
    required List<ViewerAppBarButtonType> appBarButtons,
    required List<ViewerAppBarButtonType> bottomAppBarButtons,
  }) =>
      _State(
        pageFileIdMap: const {},
        fileIdFileMap: const {},
        mergedFileIdFileMap: const {},
        fileStates: const {},
        index: initialIndex,
        currentFile: initialFile,
        isShowDetailPane: false,
        isClosingDetailPane: false,
        isDetailPaneActive: false,
        openDetailPaneRequest: Unique(const _OpenDetailPaneRequest(false)),
        closeDetailPane: Unique(false),
        isZoomed: false,
        isInitialLoad: true,
        isShowAppBar: true,
        appBarButtons: appBarButtons,
        bottomAppBarButtons: bottomAppBarButtons,
        pendingRemoveFile: Unique(null),
        removedFileIds: const [],
        imageEditorRequest: Unique(null),
        imageEnhancerRequest: Unique(null),
        shareRequest: Unique(null),
        startSlideshowRequest: Unique(null),
        slideshowRequest: Unique(null),
        setAsRequest: Unique(null),
        isBusy: false,
      );

  @override
  String toString() => _$toString();

  bool get canOpenDetailPane => !isZoomed;

  final Map<int, int> pageFileIdMap;
  final Map<int, FileDescriptor> fileIdFileMap;
  final Map<int, FileDescriptor> mergedFileIdFileMap;
  final Map<int, _PageState> fileStates;
  final int index;
  final FileDescriptor? currentFile;
  final _PageState? currentFileState;
  final Collection? collection;
  final CollectionItemsController? collectionItemsController;
  final Map<int, CollectionFileItem>? collectionItems;
  final bool isShowDetailPane;
  final bool isClosingDetailPane;
  final bool isDetailPaneActive;
  final Unique<_OpenDetailPaneRequest> openDetailPaneRequest;
  final Unique<bool> closeDetailPane;
  final bool isZoomed;
  final bool isInitialLoad;

  final bool isShowAppBar;
  final List<ViewerAppBarButtonType> appBarButtons;
  final List<ViewerAppBarButtonType> bottomAppBarButtons;

  final Unique<FileDescriptor?> pendingRemoveFile;
  final List<int> removedFileIds;

  final Unique<ImageEditorArguments?> imageEditorRequest;
  final Unique<ImageEnhancerArguments?> imageEnhancerRequest;
  final Unique<_ShareRequest?> shareRequest;
  final Unique<_StartSlideshowRequest?> startSlideshowRequest;
  final Unique<_SlideshowRequest?> slideshowRequest;
  final Unique<_SetAsRequest?> setAsRequest;

  final bool isBusy;
  final ExceptionEvent? error;
}

@genCopyWith
@toString
class _PageState {
  const _PageState({
    required this.itemHeight,
    required this.hasLoaded,
    required this.shouldPlayLivePhoto,
  });

  factory _PageState.create() {
    return const _PageState(
      itemHeight: null,
      hasLoaded: false,
      shouldPlayLivePhoto: false,
    );
  }

  @override
  String toString() => _$toString();

  final double? itemHeight;
  final bool hasLoaded;
  final bool shouldPlayLivePhoto;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _SetIndex implements _Event {
  const _SetIndex(this.index);

  @override
  String toString() => _$toString();

  final int index;
}

@toString
class _JumpToLastSlideshow implements _Event {
  const _JumpToLastSlideshow({
    required this.index,
    required this.fileId,
  });

  @override
  String toString() => _$toString();

  final int index;
  final int fileId;
}

@toString
class _SetCollection implements _Event {
  const _SetCollection(this.collection, this.itemsController);

  @override
  String toString() => _$toString();

  final Collection? collection;
  final CollectionItemsController? itemsController;
}

@toString
class _SetCollectionItems implements _Event {
  const _SetCollectionItems(this.value);

  @override
  String toString() => _$toString();

  final List<CollectionItem>? value;
}

/// Merge regular files with collection items. The point of doing this is to
/// support shared files in an server side shared album, as these files do not
/// have a record in filesController
@toString
class _MergeFiles implements _Event {
  const _MergeFiles();

  @override
  String toString() => _$toString();
}

@toString
class _NewPageContent implements _Event {
  const _NewPageContent(this.value);

  @override
  String toString() => _$toString();

  final Map<int, FileDescriptor> value;
}

@toString
class _ToggleAppBar implements _Event {
  const _ToggleAppBar();

  @override
  String toString() => _$toString();
}

@toString
class _ShowAppBar implements _Event {
  const _ShowAppBar();

  @override
  String toString() => _$toString();
}

@toString
class _HideAppBar implements _Event {
  const _HideAppBar();

  @override
  String toString() => _$toString();
}

@toString
class _SetAppBarButtons implements _Event {
  const _SetAppBarButtons(this.value);

  @override
  String toString() => _$toString();

  final List<ViewerAppBarButtonType> value;
}

@toString
class _SetBottomAppBarButtons implements _Event {
  const _SetBottomAppBarButtons(this.value);

  @override
  String toString() => _$toString();

  final List<ViewerAppBarButtonType> value;
}

@toString
class _PauseLivePhoto implements _Event {
  const _PauseLivePhoto(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _PlayLivePhoto implements _Event {
  const _PlayLivePhoto(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Unfavorite implements _Event {
  const _Unfavorite(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Favorite implements _Event {
  const _Favorite(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Unarchive implements _Event {
  const _Unarchive(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Archive implements _Event {
  const _Archive(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Share implements _Event {
  const _Share(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Edit implements _Event {
  const _Edit(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Enhance implements _Event {
  const _Enhance(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Download implements _Event {
  const _Download(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _Delete implements _Event {
  const _Delete(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _RemoveFromCollection implements _Event {
  const _RemoveFromCollection(this.value);

  @override
  String toString() => _$toString();

  final CollectionItem value;
}

@toString
class _StartSlideshow implements _Event {
  const _StartSlideshow(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _StartSlideshowResult implements _Event {
  const _StartSlideshowResult(this.request, this.config);

  @override
  String toString() => _$toString();

  final _StartSlideshowRequest request;
  final SlideshowConfig config;
}

@toString
class _SetAs implements _Event {
  const _SetAs(this.fileId);

  @override
  String toString() => _$toString();

  final int fileId;
}

@toString
class _OpenDetailPane implements _Event {
  const _OpenDetailPane(this.shouldAnimate);

  @override
  String toString() => _$toString();

  final bool shouldAnimate;
}

@toString
class _CloseDetailPane implements _Event {
  const _CloseDetailPane();

  @override
  String toString() => _$toString();
}

@toString
class _DetailPaneClosed implements _Event {
  const _DetailPaneClosed();

  @override
  String toString() => _$toString();
}

@toString
class _ShowDetailPane implements _Event {
  const _ShowDetailPane();

  @override
  String toString() => _$toString();
}

@toString
class _SetDetailPaneInactive implements _Event {
  const _SetDetailPaneInactive();

  @override
  String toString() => _$toString();
}

@toString
class _SetDetailPaneActive implements _Event {
  const _SetDetailPaneActive();

  @override
  String toString() => _$toString();
}

@toString
class _SetFileContentHeight implements _Event {
  const _SetFileContentHeight(this.fileId, this.value);

  @override
  String toString() => _$toString();

  final int fileId;
  final double value;
}

@toString
class _SetIsZoomed implements _Event {
  const _SetIsZoomed(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _RemoveFile implements _Event {
  const _RemoveFile(this.file);

  @override
  String toString() => _$toString();

  final FileDescriptor file;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
