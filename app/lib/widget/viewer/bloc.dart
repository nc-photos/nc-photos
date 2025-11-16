part of 'viewer.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc(
    this._c, {
    required this.account,
    required this.anyFilesController,
    required this.filesController,
    required this.localFilesController,
    required this.collectionsController,
    required this.prefController,
    required this.accountPrefController,
    required this.brightness,
    required this.contentProvider,
    required this.initialFile,
    this.collectionId,
  }) : contentController = _ViewerContentController(
         contentProvider: contentProvider,
         initialFile: initialFile,
       ),
       super(
         _State.init(
           initialFile: initialFile,
           appBarButtons: prefController.viewerAppBarButtonsValue,
           bottomAppBarButtons: prefController.viewerBottomAppBarButtonsValue,
         ),
       ) {
    on<_Init>(_onInit);
    on<_SetIndex>(_onSetIndex);
    on<_JumpToLastSlideshow>(_onJumpToLastSlideshow);
    on<_SetCollection>(_onSetCollection);
    on<_SetCollectionItems>(_onSetCollectionItems);
    on<_MergeFiles>(_onMergeFiles);
    on<_NewPageContent>(_onNewPageContent);
    on<_SetForwardBound>(_onSetForwardBound);
    on<_SetBackwardBound>(_onSetBackwardBound);

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
    on<_DeleteWithHint>(_onDeleteWithHint);
    on<_RemoveFromCollection>(_onRemoveFromCollection);
    on<_StartSlideshow>(_onStartSlideshow);
    on<_StartSlideshowResult>(_onStartSlideshowResult);
    on<_SetAs>(_onSetAs);
    on<_Upload>(_onUpload);

    on<_OpenDetailPane>(_onOpenDetailPane);
    on<_CloseDetailPane>(_onCloseDetailPane);
    on<_DetailPaneClosed>(_onDetailPaneClosed);
    on<_ShowDetailPane>(_onShowDetailPane);
    on<_SetDetailPaneInactive>(_onSetDetailPaneInactive);
    on<_SetDetailPaneActive>(_onSetDetailPaneActive);

    on<_SetFileContentHeight>(_onSetFileContentHeight);
    on<_SetIsZoomed>(_onSetIsZoomed);

    on<_RemoveFile>(_onRemoveFile);

    on<_SetError>(_onSetError);

    if (collectionId != null) {
      _subscriptions.add(
        collectionsController.stream.listen((event) {
          for (final c in event.data) {
            if (c.collection.id == collectionId) {
              add(_SetCollection(c.collection, c.controller));
              _collectionItemsSubscription?.cancel();
              _collectionItemsSubscription = c.controller.stream.listen((
                event,
              ) {
                add(_SetCollectionItems(event.items));
              });
              return;
            }
          }
          _log.warning("[_Bloc] Collection not found: $collectionId");
          add(const _SetCollection(null, null));
          add(const _SetCollectionItems(null));
          _collectionItemsSubscription?.cancel();
        }),
      );
    }
    _subscriptions.add(
      prefController.viewerAppBarButtonsChange.listen((event) {
        add(_SetAppBarButtons(event));
      }),
    );
    _subscriptions.add(
      prefController.viewerBottomAppBarButtonsChange.listen((event) {
        add(_SetBottomAppBarButtons(event));
      }),
    );
    _subscriptions.add(
      stream
          .distinct(
            (a, b) =>
                identical(a.anyFiles, b.anyFiles) &&
                identical(a.collectionItems, b.collectionItems),
          )
          .listen((event) {
            add(const _MergeFiles());
          }),
    );
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
    final results = await Future.wait([
      contentController.getForwardContent(),
      contentController.getBackwardContent(),
    ]);
    emit(
      state.copyWith(
        pageAfIdMap: {
          ...results[0].map((k, v) => MapEntry(k, v.id)),
          0: initialFile.id,
          ...results[1].map((k, v) => MapEntry(k, v.id)),
        },
        // is this needed?
        // afIdFileMap: {
        //   ...results[0].map((k, v) => MapEntry(v.id, v)),
        //   ...results[1].map((k, v) => MapEntry(v.id, v)),
        //   initialFile.id: initialFile,
        // },
      ),
    );
    unawaited(
      anyFilesController.queryByAfId([
        ...results[0].values.map((e) => e.id),
        ...results[1].values.map((e) => e.id),
        initialFile.id,
      ]),
    );

    await Future.wait([
      forEach(
        emit,
        anyFilesController.stream,
        onData: (data) => state.copyWith(anyFiles: data.data),
      ),
      forEach(
        emit,
        filesController.errorStream,
        onData:
            (data) => state.copyWith(
              error: ExceptionEvent(data.error, data.stackTrace),
            ),
      ),
    ]);
  }

  void _onSetIndex(_SetIndex ev, _Emitter emit) {
    _log.info(ev);
    if (contentController.needQueryForward(ev.index)) {
      contentController.getForwardContent().then((results) {
        if (results.isNotEmpty) {
          add(_NewPageContent(results));
        } else {
          add(_SetForwardBound(ev.index - 1));
          add(_SetIndex(contentController.lastKnownPage));
        }
      });
    }
    if (contentController.needQueryBackward(ev.index)) {
      contentController.getBackwardContent().then((results) {
        if (results.isNotEmpty) {
          add(_NewPageContent(results));
        } else {
          add(_SetBackwardBound(ev.index + 1));
          add(_SetIndex(contentController.firstKnownPage));
        }
      });
    }
    final afId = state.pageAfIdMap[ev.index];
    if (afId == null) {
      emit(
        state.copyWith(
          index: ev.index,
          currentFile: null,
          currentFileState: null,
          isInitialLoad: false,
        ),
      );
    } else {
      final fileState = state.fileStates[afId] ?? _PageState.create();
      final file = state.mergedAfIdFileMap[afId];
      emit(
        state.copyWith(
          index: ev.index,
          currentFile: file,
          fileStates:
              state.fileStates[afId] == null
                  ? state.fileStates.addedAll({afId: fileState})
                  : null,
          currentFileState: fileState,
          isInitialLoad: false,
        ),
      );
      if (file == null) {
        anyFilesController.queryByAfId([afId]);
      }
    }
  }

  Future<void> _onJumpToLastSlideshow(
    _JumpToLastSlideshow ev,
    _Emitter emit,
  ) async {
    _log.info(ev);
    await contentController.fastJump(page: ev.index, afId: ev.afId);
    emit(
      state.copyWith(
        pageAfIdMap:
            state.pageAfIdMap.containsKey(ev.index)
                ? null
                : state.pageAfIdMap.addedAll({ev.index: ev.afId}),
      ),
    );
    add(_SetIndex(ev.index));
  }

  void _onSetCollection(_SetCollection ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        collection: ev.collection,
        collectionItemsController: ev.itemsController,
      ),
    );
  }

  void _onSetCollectionItems(_SetCollectionItems ev, _Emitter emit) {
    _log.info(ev);
    final itemMap =
        ev.value
            ?.whereType<CollectionFileItem>()
            .map(
              (e) => MapEntry(AnyFileNextcloudProvider.toAfId(e.file.fdId), e),
            )
            .toMap();
    emit(state.copyWith(collectionItems: itemMap));
  }

  void _onMergeFiles(_MergeFiles ev, _Emitter emit) {
    _log.info(ev);
    if (collectionId != null && state.collectionItems == null) {
      // collection not ready
      return;
    }
    var merged = {
      ...state.anyFiles,
      // this is safe because collection does not support local files
      if (collectionId != null)
        ...state.collectionItems!.map(
          (_, e) => e.file.toAnyFile().let((f) => MapEntry(f.id, f)),
        ),
    };
    if (merged.isEmpty) {
      merged = {initialFile.id: initialFile};
    }

    var newState = state.copyWith(
      mergedAfIdFileMap: merged,
      currentFile: merged[state.pageAfIdMap[state.index]],
    );
    final fileId = state.pageAfIdMap[state.index];
    if (state.currentFileState == null && fileId != null) {
      final fileState = state.fileStates[fileId] ?? _PageState.create();
      newState = newState.copyWith(
        fileStates:
            state.fileStates[fileId] == null
                ? state.fileStates.addedAll({fileId: fileState})
                : null,
        currentFileState: fileState,
      );
    }
    emit(newState);
  }

  void _onNewPageContent(_NewPageContent ev, _Emitter emit) {
    _log.info(ev);
    anyFilesController.queryByAfId(ev.value.values.map((e) => e.id));
    emit(
      state.copyWith(
        pageAfIdMap: state.pageAfIdMap.addedAll(
          ev.value.map((k, v) => MapEntry(k, v.id)),
        ),
      ),
    );
  }

  void _onSetForwardBound(_SetForwardBound ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(forwardBound: ev.value));
  }

  void _onSetBackwardBound(_SetBackwardBound ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(backwardBound: ev.value));
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
    _updateFileState(ev.afId, emit, shouldPlayLivePhoto: false);
  }

  void _onPlayLivePhoto(_PlayLivePhoto ev, _Emitter emit) {
    _log.info(ev);
    _updateFileState(ev.afId, emit, shouldPlayLivePhoto: true);
  }

  void _onUnfavorite(_Unfavorite ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onUnfavorite] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.favorite)) {
      _log.severe("[_onUnfavorite] Op not supported: $f");
      return;
    }
    AnyFileWorkerFactory.favorite(
      f,
      filesController: filesController,
    ).unfavorite();
  }

  void _onFavorite(_Favorite ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onFavorite] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.favorite)) {
      _log.severe("[_onFavorite] Op not supported: $f");
      return;
    }
    AnyFileWorkerFactory.favorite(
      f,
      filesController: filesController,
    ).favorite();
  }

  void _onUnarchive(_Unarchive ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onUnarchive] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.archive)) {
      _log.severe("[_onUnarchive] Op not supported: $f");
      return;
    }
    AnyFileWorkerFactory.archive(
      f,
      filesController: filesController,
    ).unarchive();
    _removeFileFromStream(f, emit);
  }

  void _onArchive(_Archive ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onArchive] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.archive)) {
      _log.severe("[_onArchive] Op not supported: $f");
      return;
    }
    AnyFileWorkerFactory.archive(f, filesController: filesController).archive();
    _removeFileFromStream(f, emit);
  }

  void _onShare(_Share ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onShare] file is null: ${ev.afId}");
      return;
    }
    emit(state.copyWith(shareRequest: Unique(_ShareRequest(f))));
  }

  void _onEdit(_Edit ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onEdit] file is null: ${ev.afId}");
      return;
    }
    emit(
      state.copyWith(
        imageEditorRequest: Unique(ImageEditorArguments(account, f)),
      ),
    );
  }

  void _onEnhance(_Enhance ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onEnhance] file is null: ${ev.afId}");
      return;
    }
    emit(
      state.copyWith(
        imageEnhancerRequest: Unique(
          ImageEnhancerArguments(
            account,
            f,
            prefController.isSaveEditResultToServerValue,
          ),
        ),
      ),
    );
  }

  void _onDownload(_Download ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onDownload] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.download)) {
      _log.severe("[_onDownload] Op not supported: $f");
      return;
    }
    AnyFileWorkerFactory.download(f, account: account, c: _c).download();
  }

  void _onDelete(_Delete ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onDelete] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.delete)) {
      _log.severe("[_onDelete] Op not supported: $f");
      return;
    }
    if (f.provider is AnyFileMergedProvider) {
      emit(
        state.copyWith(
          deleteRequest: Unique(_DeleteRequest(account: account, file: f)),
        ),
      );
    } else {
      AnyFileWorkerFactory.delete(
        f,
        filesController: filesController,
        localFilesController: localFilesController,
      ).delete().then((isSuccess) {
        SnackBarManager().showSnackBar(
          buildDeleteResultSnackBar(
            account,
            failureCount: isSuccess ? 0 : 1,
            isMoveToTrash: true,
            isRemoveSingle: true,
          ),
        );
      });
      _removeFileFromStream(f, emit);
    }
  }

  void _onDeleteWithHint(_DeleteWithHint ev, _Emitter emit) {
    _log.info(ev);
    AnyFileWorkerFactory.delete(
      ev.file,
      filesController: filesController,
      localFilesController: localFilesController,
    ).delete(hint: ev.hint).then((isSuccess) {
      SnackBarManager().showSnackBar(
        buildDeleteResultSnackBar(
          account,
          failureCount: isSuccess ? 0 : 1,
          isMoveToTrash: true,
          isRemoveSingle: true,
        ),
      );
    });
    _removeFileFromStream(ev.file, emit);
  }

  void _onRemoveFromCollection(_RemoveFromCollection ev, _Emitter emit) {
    _log.info(ev);
    if (!CollectionAdapter.of(
      _c,
      account,
      state.collection!,
    ).isPermitted(CollectionCapability.manualItem)) {
      throw UnsupportedError("Operation not supported by this collection");
    }
    state.collectionItemsController!.removeItems([ev.value]);
    _removeFileFromStream(
      (ev.value as CollectionFileItem).file.toAnyFile(),
      emit,
    );
  }

  void _onStartSlideshow(_StartSlideshow ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        startSlideshowRequest: Unique(_StartSlideshowRequest(afId: ev.afId)),
      ),
    );
  }

  Future<void> _onStartSlideshowResult(
    _StartSlideshowResult ev,
    _Emitter emit,
  ) async {
    _log.info(ev);
    emit(state.copyWith(isBusy: true));
    try {
      final afIds = await contentProvider.listAfIds();
      var index = afIds.indexOf(ev.request.afId);
      if (index == -1) {
        _log.warning(
          "[_onStartSlideshowResult] Initial id not found: ${ev.request.afId}",
        );
        index = 0;
      }
      final req = _SlideshowRequest(
        afIds: afIds,
        startIndex: afIds.indexOf(ev.request.afId),
        collectionId: collectionId,
        config: ev.config,
      );
      unawaited(prefController.setSlideshowDuration(ev.config.duration));
      unawaited(prefController.setSlideshowShuffle(ev.config.isShuffle));
      unawaited(prefController.setSlideshowRepeat(ev.config.isRepeat));
      unawaited(prefController.setSlideshowReverse(ev.config.isReverse));
      emit(state.copyWith(slideshowRequest: Unique(req)));
    } finally {
      emit(state.copyWith(isBusy: false));
    }
  }

  void _onSetAs(_SetAs ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onSetAs] file is null: ${ev.afId}");
      return;
    }
    final req = _SetAsRequest(account: account, file: f);
    emit(state.copyWith(setAsRequest: Unique(req)));
  }

  void _onUpload(_Upload ev, _Emitter emit) {
    _log.info(ev);
    final f = state.mergedAfIdFileMap[ev.afId];
    if (f == null) {
      _log.severe("[_onUpload] file is null: ${ev.afId}");
      return;
    }
    final capability = AnyFileWorkerFactory.capability(f);
    if (!capability.isPermitted(AnyFileCapability.upload)) {
      _log.severe("[_onUpload] Op not supported: $f");
      return;
    }
    final req = _UploadRequest(account: account, file: f);
    emit(state.copyWith(uploadRequest: Unique(req)));
  }

  void _onOpenDetailPane(_OpenDetailPane ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        openDetailPaneRequest: Unique(_OpenDetailPaneRequest(ev.shouldAnimate)),
      ),
    );
  }

  void _onCloseDetailPane(_CloseDetailPane ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(closeDetailPane: Unique(true), isClosingDetailPane: true),
    );
  }

  void _onDetailPaneClosed(_DetailPaneClosed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isShowDetailPane: false, isClosingDetailPane: false));
  }

  void _onShowDetailPane(_ShowDetailPane ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isShowDetailPane: true, isDetailPaneActive: true));
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
    _updateFileState(ev.afId, emit, itemHeight: ev.value);
  }

  void _onSetIsZoomed(_SetIsZoomed ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isZoomed: ev.value));
  }

  void _onRemoveFile(_RemoveFile ev, _Emitter emit) {
    _log.info(ev);
    final removePage =
        state.pageAfIdMap.entries
            .firstWhereOrNull((e) => e.value == ev.file.id)
            ?.key;
    if (removePage == null) {
      _log.warning("[_onRemoveFile] File id not found: ${ev.file.id}");
      return;
    }
    contentController.notifyFileRemoved(removePage, ev.file.id);
    final nextPageAfIdMap = <int, String>{};
    for (final e in state.pageAfIdMap.entries) {
      if (e.key < removePage) {
        nextPageAfIdMap[e.key] = e.value;
      } else if (e.key > removePage) {
        nextPageAfIdMap[e.key - 1] = e.value;
      }
    }
    final currentPage =
        state.pageAfIdMap.entries
            .firstWhereOrNull((e) => e.value == state.currentFile?.id)
            ?.key;
    emit(
      state.copyWith(
        removedAfIds: state.removedAfIds.added(ev.file.id),
        // if removed file is found first, a page has been removed before us so we
        // need to deduct index by 1
        pageAfIdMap: nextPageAfIdMap,
      ),
    );
    if (currentPage == null || removePage <= currentPage) {
      add(_SetIndex(state.index - 1));
    }
  }

  void _onSetError(_SetError ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  void _updateFileState(
    String afId,
    _Emitter emit, {
    double? itemHeight,
    bool? hasLoaded,
    bool? shouldPlayLivePhoto,
  }) {
    final newStates = Map.of(state.fileStates);
    var newState = state.fileStates[afId] ?? _PageState.create();
    newState = newState.copyWith(
      hasLoaded: hasLoaded,
      shouldPlayLivePhoto: shouldPlayLivePhoto,
    );
    if (itemHeight != null) {
      // we don't support resetting itemHeight to null
      newState = newState.copyWith(itemHeight: itemHeight);
    }
    newStates[afId] = newState;
    if (afId == state.currentFile?.id) {
      emit(state.copyWith(fileStates: newStates, currentFileState: newState));
    } else {
      emit(state.copyWith(fileStates: newStates));
    }
  }

  void _removeFileFromStream(AnyFile file, _Emitter emit) {
    emit(state.copyWith(pendingRemoveFile: Unique(file)));
  }

  final DiContainer _c;
  final Account account;
  final AnyFilesController anyFilesController;
  final FilesController filesController;
  final LocalFilesController localFilesController;
  final CollectionsController collectionsController;
  final PrefController prefController;
  final AccountPrefController accountPrefController;
  final _ViewerContentController contentController;
  final ViewerContentProvider contentProvider;
  final AnyFile initialFile;
  final Brightness brightness;
  final String? collectionId;

  final _subscriptions = <StreamSubscription>[];
  StreamSubscription? _collectionItemsSubscription;
  var _isHandlingError = false;
}
