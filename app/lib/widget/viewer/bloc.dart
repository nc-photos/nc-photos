part of '../viewer.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc(
    this._c, {
    required this.account,
    required this.filesController,
    required this.collectionsController,
    required this.prefController,
    required this.brightness,
    required List<int> fileIds,
    required int startIndex,
    this.collectionId,
  }) : super(_State.init(
          fileIds: fileIds,
          index: startIndex,
          currentFile:
              filesController.stream.value.dataMap[fileIds[startIndex]],
          appBarButtons: prefController.viewerAppBarButtonsValue,
          bottomAppBarButtons: prefController.viewerBottomAppBarButtonsValue,
        )) {
    on<_Init>(_onInit);
    on<_SetIndex>(_onSetIndex);
    on<_RequestPage>(_onRequestPage);
    on<_SetCollection>(_onSetCollection);
    on<_SetCollectionItems>(_onSetCollectionItems);
    on<_MergeFiles>(_onMergeFiles);

    on<_ToggleAppBar>(_onToggleAppBar);
    on<_ShowAppBar>(_onShowAppBar);
    on<_HideAppBar>(_onHideAppBar);
    on<_SetAppBarButtons>(_onAppBarButtons);
    on<_SetBottomAppBarButtons>(_onBottomAppBarButtons);
    on<_PauseLivePhoto>(_onPauseLivePhoto);
    on<_PlayLivePhoto>(_onPlayLivePhoto);
    on<_Unfavorite>(_onUnfavorite);
    on<_Favorite>(_onFavorite);
    on<_Unarchive>(_onUnarchive);
    on<_Archive>(_onArchive);
    on<_Share>(_onShare);
    on<_Edit>(_onEdit);
    on<_Enhance>(_onEnhance);
    on<_Download>(_onDownload);
    on<_Delete>(_onDelete);
    on<_RemoveFromCollection>(_onRemoveFromCollection);
    on<_StartSlideshow>(_onStartSlideshow);
    on<_SetAs>(_onSetAs);

    on<_OpenDetailPane>(_onOpenDetailPane);
    on<_CloseDetailPane>(_onCloseDetailPane);
    on<_DetailPaneClosed>(_onDetailPaneClosed);
    on<_ShowDetailPane>(_onShowDetailPane);
    on<_SetDetailPaneInactive>(_onSetDetailPaneInactive);
    on<_SetDetailPaneActive>(_onSetDetailPaneActive);

    on<_SetFileContentHeight>(_onSetFileContentHeight);
    on<_SetIsZoomed>(_onSetIsZoomed);

    on<_RemovePage>(_onRemovePage);

    on<_SetError>(_onSetError);

    if (collectionId != null) {
      _subscriptions.add(collectionsController.stream.listen((event) {
        for (final c in event.data) {
          if (c.collection.id == collectionId) {
            add(_SetCollection(c.collection, c.controller));
            _collectionItemsSubscription?.cancel();
            _collectionItemsSubscription = c.controller.stream.listen((event) {
              add(_SetCollectionItems(event.items));
            });
            return;
          }
        }
        _log.warning("[_Bloc] Collection not found: $collectionId");
        add(const _SetCollection(null, null));
        add(const _SetCollectionItems(null));
        _collectionItemsSubscription?.cancel();
      }));
    }
    _subscriptions.add(prefController.viewerAppBarButtonsChange.listen((event) {
      add(_SetAppBarButtons(event));
    }));
    _subscriptions
        .add(prefController.viewerBottomAppBarButtonsChange.listen((event) {
      add(_SetBottomAppBarButtons(event));
    }));
    _subscriptions.add(stream
        .distinct((a, b) =>
            identical(a.rawFiles, b.rawFiles) &&
            identical(a.collectionItems, b.collectionItems))
        .listen((event) {
      add(const _MergeFiles());
    }));

    add(_SetIndex(startIndex));
  }

  @override
  Future<void> close() {
    _collectionItemsSubscription?.cancel();
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  @override
  void onError(Object error, StackTrace stackTrace) {
    // we need this to prevent onError being triggered recursively
    if (!isClosed && !_isHandlingError) {
      _isHandlingError = true;
      try {
        add(_SetError(error, stackTrace));
      } catch (_) {}
      _isHandlingError = false;
    }
    super.onError(error, stackTrace);
  }

  Future<void> _onInit(_Init ev, _Emitter emit) async {
    await Future.wait([
      forEach(
        emit,
        filesController.stream,
        onData: (data) => state.copyWith(
          rawFiles: data.dataMap,
        ),
      ),
      forEach(
        emit,
        filesController.errorStream,
        onData: (data) => state.copyWith(
          error: ExceptionEvent(data.error, data.stackTrace),
        ),
      ),
    ]);
  }

  void _onSetIndex(_SetIndex ev, _Emitter emit) {
    _log.info(ev);
    final fileId = state.fileIdOrders[ev.index];
    final fileState = state.fileStates[fileId] ?? _PageState.create();
    final file = state.files[fileId];
    emit(state.copyWith(
      index: ev.index,
      currentFile: file,
      fileStates: state.fileStates[fileId] == null
          ? state.fileStates.addedAll({fileId: fileState})
          : null,
      currentFileState: fileState,
      isInitialLoad: false,
    ));
    if (file == null) {
      filesController.queryByFileId([fileId]);
    }
  }

  void _onRequestPage(_RequestPage ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(index: ev.index));
  }

  void _onSetCollection(_SetCollection ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      collection: ev.collection,
      collectionItemsController: ev.itemsController,
    ));
  }

  void _onSetCollectionItems(_SetCollectionItems ev, _Emitter emit) {
    _log.info(ev);
    final itemMap = ev.value
        ?.whereType<CollectionFileItem>()
        .map((e) => MapEntry(e.file.fdId, e))
        .toMap();
    emit(state.copyWith(collectionItems: itemMap));
  }

  void _onMergeFiles(_MergeFiles ev, _Emitter emit) {
    _log.info(ev);
    final Map<int, FileDescriptor> files;
    if (collectionId == null) {
      // not collection, nothing to merge
      files = state.rawFiles;
    } else {
      if (state.collectionItems == null) {
        // collection not ready
        return;
      }
      files = state.rawFiles.addedAll(state.collectionItems!
          .map((key, value) => MapEntry(key, value.file)));
    }
    emit(state.copyWith(
      files: files,
      currentFile: files[state.fileIdOrders[state.index]],
    ));
  }

  void _onToggleAppBar(_ToggleAppBar ev, _Emitter emit) {
    _log.info(ev);
    final to = !state.isShowAppBar;
    emit(state.copyWith(isShowAppBar: to));
    if (to) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  }

  void _onShowAppBar(_ShowAppBar ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isShowAppBar: true));
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  void _onHideAppBar(_HideAppBar ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isShowAppBar: false));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _onAppBarButtons(_SetAppBarButtons ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(appBarButtons: ev.value));
  }

  void _onBottomAppBarButtons(_SetBottomAppBarButtons ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(bottomAppBarButtons: ev.value));
  }

  void _onPauseLivePhoto(_PauseLivePhoto ev, _Emitter emit) {
    _log.info(ev);
    _updateFileState(ev.fileId, emit, shouldPlayLivePhoto: false);
  }

  void _onPlayLivePhoto(_PlayLivePhoto ev, _Emitter emit) {
    _log.info(ev);
    _updateFileState(ev.fileId, emit, shouldPlayLivePhoto: true);
  }

  void _onUnfavorite(_Unfavorite ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onUnfavorite] file is null: ${ev.fileId}");
      return;
    }
    filesController.updateProperty([f], isFavorite: false);
  }

  void _onFavorite(_Favorite ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onFavorite] file is null: ${ev.fileId}");
      return;
    }
    filesController.updateProperty([f], isFavorite: true);
  }

  void _onUnarchive(_Unarchive ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onUnarchive] file is null: ${ev.fileId}");
      return;
    }
    filesController.updateProperty([f], isArchived: const OrNull(false));
    _removeFileFromStream(ev.fileId, emit);
  }

  void _onArchive(_Archive ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onArchive] file is null: ${ev.fileId}");
      return;
    }
    filesController.updateProperty([f], isArchived: const OrNull(true));
    _removeFileFromStream(ev.fileId, emit);
  }

  void _onShare(_Share ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onShare] file is null: ${ev.fileId}");
      return;
    }
    emit(state.copyWith(shareRequest: Unique(_ShareRequest(f))));
  }

  void _onEdit(_Edit ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onEdit] file is null: ${ev.fileId}");
      return;
    }
    emit(state.copyWith(
      imageEditorRequest: Unique(ImageEditorArguments(account, f)),
    ));
  }

  void _onEnhance(_Enhance ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onEnhance] file is null: ${ev.fileId}");
      return;
    }
    emit(state.copyWith(
      imageEnhancerRequest: Unique(ImageEnhancerArguments(
        account,
        f,
        prefController.isSaveEditResultToServerValue,
      )),
    ));
  }

  void _onDownload(_Download ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onDownload] file is null: ${ev.fileId}");
      return;
    }
    DownloadHandler(_c).downloadFiles(account, [f]);
  }

  void _onDelete(_Delete ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onDelete] file is null: ${ev.fileId}");
      return;
    }
    RemoveSelectionHandler(filesController: filesController)(
      account: account,
      selection: [f],
      isRemoveOpened: true,
      isMoveToTrash: true,
    );
    _removeFileFromStream(f.fdId, emit);
  }

  void _onRemoveFromCollection(_RemoveFromCollection ev, _Emitter emit) {
    _log.info(ev);
    if (!CollectionAdapter.of(_c, account, state.collection!)
        .isPermitted(CollectionCapability.manualItem)) {
      throw UnsupportedError("Operation not supported by this collection");
    }
    state.collectionItemsController!.removeItems([ev.value]);
    _removeFileFromStream((ev.value as CollectionFileItem).file.fdId, emit);
  }

  void _onStartSlideshow(_StartSlideshow ev, _Emitter emit) {
    _log.info(ev);
    final req = _SlideshowRequest(
      fileIds: state.fileIdOrders,
      startIndex:
          state.fileIdOrders.indexOf(ev.fileId).let((i) => i == -1 ? 0 : i),
      collectionId: collectionId,
    );
    emit(state.copyWith(slideshowRequest: Unique(req)));
  }

  void _onSetAs(_SetAs ev, _Emitter emit) {
    _log.info(ev);
    final f = state.files[ev.fileId];
    if (f == null) {
      _log.severe("[_onSetAs] file is null: ${ev.fileId}");
      return;
    }
    final req = _SetAsRequest(
      account: account,
      file: f,
    );
    emit(state.copyWith(setAsRequest: Unique(req)));
  }

  void _onOpenDetailPane(_OpenDetailPane ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      openDetailPaneRequest: Unique(_OpenDetailPaneRequest(ev.shouldAnimate)),
    ));
  }

  void _onCloseDetailPane(_CloseDetailPane ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      closeDetailPane: Unique(true),
      isClosingDetailPane: true,
    ));
  }

  void _onDetailPaneClosed(_DetailPaneClosed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      isShowDetailPane: false,
      isClosingDetailPane: false,
    ));
  }

  void _onShowDetailPane(_ShowDetailPane ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(
      isShowDetailPane: true,
      isDetailPaneActive: true,
    ));
  }

  void _onSetDetailPaneInactive(_SetDetailPaneInactive ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isDetailPaneActive: false));
  }

  void _onSetDetailPaneActive(_SetDetailPaneActive ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isDetailPaneActive: true));
  }

  void _onSetFileContentHeight(_SetFileContentHeight ev, _Emitter emit) {
    _log.info(ev);
    _updateFileState(ev.fileId, emit, itemHeight: ev.value);
  }

  void _onSetIsZoomed(_SetIsZoomed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isZoomed: ev.value));
  }

  void _onRemovePage(_RemovePage ev, _Emitter emit) {
    _log.info(ev);
    final newFileIds = state.fileIdOrders.removedAt(ev.value);
    emit(state.copyWith(
      fileIdOrders: newFileIds,
      index: ev.value <= state.index ? state.index - 1 : state.index,
    ));
  }

  void _onSetError(_SetError ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  void _updateFileState(
    int fileId,
    _Emitter emit, {
    double? itemHeight,
    bool? hasLoaded,
    bool? shouldPlayLivePhoto,
  }) {
    final newStates = Map.of(state.fileStates);
    var newState = state.fileStates[fileId] ?? _PageState.create();
    newState = newState.copyWith(
      hasLoaded: hasLoaded,
      shouldPlayLivePhoto: shouldPlayLivePhoto,
    );
    if (itemHeight != null) {
      // we don't support resetting itemHeight to null
      newState = newState.copyWith(itemHeight: itemHeight);
    }
    newStates[fileId] = newState;
    if (fileId == state.currentFile?.fdId) {
      emit(state.copyWith(
        fileStates: newStates,
        currentFileState: newState,
      ));
    } else {
      emit(state.copyWith(fileStates: newStates));
    }
  }

  void _removeFileFromStream(int fileId, _Emitter emit) {
    final index = state.fileIdOrders.indexOf(fileId);
    emit(state.copyWith(pendingRemovePage: Unique(index)));
  }

  final DiContainer _c;
  final Account account;
  final FilesController filesController;
  final CollectionsController collectionsController;
  final PrefController prefController;
  final Brightness brightness;
  final String? collectionId;

  final _subscriptions = <StreamSubscription>[];
  StreamSubscription? _collectionItemsSubscription;
  var _isHandlingError = false;
}
