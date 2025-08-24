part of '../home_photos2.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc(
    this._c, {
    required this.account,
    required this.anyFilesController,
    required this.filesController,
    required this.prefController,
    required this.accountPrefController,
    required this.collectionsController,
    required this.syncController,
    required this.personsController,
    required this.metadataController,
    required this.serverController,
    required this.localFilesController,
    required this.bottomAppBarHeight,
    required this.draggableThumbSize,
  }) : super(
         _State.init(
           zoom: prefController.homePhotosZoomLevelValue,
           isEnableMemoryCollection:
               accountPrefController.isEnableMemoryAlbumValue,
         ),
       ) {
    on<_LoadItems>(_onLoad);
    on<_RequestRefresh>(_onRequestRefresh);
    on<_TransformItems>(_onTransformItems);
    on<_OnItemTransformed>(_onOnItemTransformed);

    on<_SetSelectedItems>(_onSetSelectedItems);
    on<_AddSelectedItemsToCollection>(_onAddSelectedItemsToCollection);
    on<_ArchiveSelectedItems>(_onArchiveSelectedItems);
    on<_DeleteSelectedItems>(_onDeleteSelectedItems);
    on<_DownloadSelectedItems>(_onDownloadSelectedItems);
    on<_ShareSelectedItems>(_onShareSelectedItems);
    on<_UploadSelectedItems>(_onUploadSelectedItems);

    on<_AddVisibleDate>(_onAddVisibleDate);
    on<_RemoveVisibleDate>(_onRemoveVisibleDate);

    on<_SetSyncProgress>(_onSetSyncProgress);

    on<_StartScaling>(_onStartScaling);
    on<_EndScaling>(_onEndScaling);
    on<_SetScale>(_onSetScale);
    on<_SetFinger>(_onSetFinger);

    on<_StartScrolling>(_onStartScrolling);
    on<_EndScrolling>(_onEndScrolling);
    on<_SetLayoutConstraint>(_onSetLayoutConstraint);
    on<_TransformMinimap>(_onTransformMinimap);
    on<_UpdateScrollDate>(_onUpdateScrollDate);

    on<_SetEnableMemoryCollection>(_onSetEnableMemoryCollection);
    on<_UpdateZoom>(_onUpdateZoom);
    on<_UpdateDateTimeGroup>(_onUpdateDateTimeGroup);
    on<_UpdateMemories>(_onUpdateMemories);

    on<_TripMissingVideoPreview>(_onTripMissingVideoPreview);

    on<_SetError>(_onSetError);
    on<_ShowRemoteOnlyWarning>((ev, emit) {
      emit(state.copyWith(shouldShowRemoteOnlyWarning: Unique(true)));
    });
    on<_ShowLocalOnlyWarning>((ev, emit) {
      emit(state.copyWith(shouldShowLocalOnlyWarning: Unique(true)));
    });

    _subscriptions.add(
      accountPrefController.isEnableMemoryAlbumChange.listen((event) {
        add(_SetEnableMemoryCollection(event));
      }),
    );
    _subscriptions.add(
      stream
          .distinct(
            (previous, next) =>
                previous.filesSummary == next.filesSummary &&
                previous.localFilesSummary == next.localFilesSummary &&
                previous.viewHeight == next.viewHeight &&
                previous.itemPerRow == next.itemPerRow &&
                previous.itemSize == next.itemSize,
          )
          .listen((event) {
            add(const _TransformMinimap());
          }),
    );
    _subscriptions.add(
      stream
          .distinct(
            (previous, next) =>
                previous.filesSummary == next.filesSummary &&
                previous.files == next.files &&
                previous.localFilesSummary == next.localFilesSummary &&
                previous.localFiles == next.localFiles,
          )
          .listen((event) {
            add(
              _TransformItems(
                event.files,
                event.filesSummary,
                event.localFiles,
                event.localFilesSummary,
              ),
            );
          }),
    );
    _subscriptions.add(
      localFilesController.summaryErrorStream.listen((event) {
        add(_SetError(event.error, event.stackTrace));
      }),
    );
    _subscriptions.add(
      stream
          .distinctBy((e) => e.visibleDates.map((d) => d.date).sortedBySelf())
          .listen((event) {
            _onVisibleDatesUpdated();
          }),
    );
    _subscriptions.add(
      stream
          .distinct(
            (previous, next) =>
                previous.visibleDates == next.visibleDates &&
                previous.itemPerRow == next.itemPerRow,
          )
          .listen((event) {
            add(const _UpdateScrollDate());
          }),
    );
    _subscriptions.add(
      stream
          .distinct(
            (previous, next) => previous.filesSummary == next.filesSummary,
          )
          .listen((_) {
            add(const _UpdateMemories());
          }),
    );
    _subscriptions.add(
      prefController.memoriesRangeChange.listen((_) {
        add(const _UpdateMemories());
      }),
    );
  }

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _filesQueryTimer?.cancel();
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  @override
  bool Function(dynamic, dynamic)? get shouldLog => (currentState, nextState) {
    currentState = currentState as _State;
    nextState = nextState as _State;
    return currentState.scale == nextState.scale &&
        currentState.visibleDates == nextState.visibleDates &&
        currentState.syncProgress == nextState.syncProgress &&
        currentState.scrollDate == nextState.scrollDate;
  };

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

  Future<void> _onLoad(_LoadItems ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        filesController.summaryStream,
        onData: (data) {
          if (data.summary.items.isEmpty && _isInitialLoad) {
            // no data, initial sync
            _isInitialLoad = false;
            _syncRemote();
          }
          return state.copyWith(filesSummary: data.summary);
        },
        onError: (e, stackTrace) {
          _log.severe("[_onLoad] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        filesController.timelineStream,
        onData: (data) {
          if (!data.isDummy && _isInitialLoad) {
            _isInitialLoad = false;
            _syncRemote();
          }
          return state.copyWith(files: data.data.values.toList());
        },
        onError: (e, stackTrace) {
          _log.severe("[_onLoad] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        filesController.errorStream,
        onData: (data) => state.copyWith(error: data),
      ),
      forEach(
        emit,
        localFilesController.summaryStream2,
        onData: (data) => state.copyWith(localFilesSummary: data.summary),
      ),
      forEach(
        emit,
        localFilesController.timelineStream,
        onData: (data) => state.copyWith(localFiles: data.data.values.toList()),
      ),
      forEach(
        emit,
        anyFilesController.errorStream,
        onData: (data) => state.copyWith(error: data),
      ),
    ]);
  }

  void _onRequestRefresh(_RequestRefresh ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(syncProgress: const Progress(0)));
    _syncRemote();
    metadataController.scheduleNext();
  }

  void _onTransformItems(_TransformItems ev, Emitter<_State> emit) {
    _log.info(ev);
    _transformItems(ev.files, ev.summary, ev.localFiles, ev.localSummary);
    emit(state.copyWith(isLoading: true));
  }

  void _onOnItemTransformed(_OnItemTransformed ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        transformedItems: ev.items,
        isLoading: _itemTransformerQueue.isProcessing,
        queriedDates: ev.dates,
      ),
    );
    // update with the new queriedDates
    _requestMoreFiles();
  }

  void _onSetSelectedItems(_SetSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final canArchive = ev.items.whereType<_FileItem>().any(
      (e) => AnyFileWorkerFactory.capability(
        e.file,
      ).isPermitted(AnyFileCapability.archive),
    );
    final canDownload = ev.items.whereType<_FileItem>().any(
      (e) => AnyFileWorkerFactory.capability(
        e.file,
      ).isPermitted(AnyFileCapability.download),
    );
    final canDelete = ev.items.whereType<_FileItem>().any(
      (e) => AnyFileWorkerFactory.capability(
        e.file,
      ).isPermitted(AnyFileCapability.delete),
    );
    // TODO let collection to make this decision
    final canAddToCollection =
        ev.items.whereType<_NextcloudFileItem>().isNotEmpty;
    final canUpload = ev.items.whereType<_FileItem>().any(
      (e) => AnyFileWorkerFactory.capability(
        e.file,
      ).isPermitted(AnyFileCapability.upload),
    );
    emit(
      state.copyWith(
        selectedItems: ev.items,
        selectedCanArchive: canArchive,
        selectedCanDownload: canDownload,
        selectedCanDelete: canDelete,
        selectedCanAddToCollection: canAddToCollection,
        selectedCanUpload: canUpload,
      ),
    );
  }

  void _onAddSelectedItemsToCollection(
    _AddSelectedItemsToCollection ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected
            .whereType<_NextcloudFileItem>()
            .map((e) => e.remoteFile)
            .toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowRemoteOnlyWarning());
    }
    if (selectedFiles.isNotEmpty) {
      final targetController = collectionsController.stream.value
          .itemsControllerByCollection(ev.collection);
      targetController.addFiles(selectedFiles).onError((e, stackTrace) {
        if (e != null) {
          add(_SetError(e, stackTrace));
        }
      });
    }
  }

  void _onArchiveSelectedItems(_ArchiveSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected
            .whereType<_NextcloudFileItem>()
            .map((e) => e.remoteFile)
            .toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowRemoteOnlyWarning());
    }
    if (selectedFiles.isNotEmpty) {
      filesController.updateProperty(
        selectedFiles,
        isArchived: const OrNull(true),
        errorBuilder: (fileIds) => _ArchiveFailedError(fileIds.length),
      );
    }
  }

  void _onDeleteSelectedItems(_DeleteSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      anyFilesController.remove(
        selectedFiles,
        errorBuilder: (fileIds) => _RemoveFailedError(fileIds.length),
      );
    }
  }

  void _onDownloadSelectedItems(
    _DownloadSelectedItems ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected
            .whereType<_NextcloudFileItem>()
            .map((e) => e.remoteFile)
            .toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowRemoteOnlyWarning());
    }
    if (selectedFiles.isNotEmpty) {
      unawaited(DownloadHandler(_c).downloadFiles(account, selectedFiles));
    }
  }

  void _onShareSelectedItems(_ShareSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      final isRemoteShareOnly = selectedFiles.every((f) {
        final capability = AnyFileWorkerFactory.capability(f);
        return capability.isPermitted(AnyFileCapability.remoteShare);
      });
      final isLocalShareOnly = selectedFiles.every((f) {
        final capability = AnyFileWorkerFactory.capability(f);
        return !capability.isPermitted(AnyFileCapability.remoteShare);
      });
      final req = _ShareRequest(
        files: selectedFiles,
        isRemoteShareOnly: isRemoteShareOnly,
        isLocalShareOnly: isLocalShareOnly,
      );
      emit(state.copyWith(shareRequest: Unique(req)));
    }
  }

  void _onUploadSelectedItems(_UploadSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).where((f) {
          final capability = AnyFileWorkerFactory.capability(f);
          return capability.isPermitted(AnyFileCapability.upload);
        }).toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowLocalOnlyWarning());
    }
    if (selectedFiles.isNotEmpty) {
      final req = _UploadRequest(files: selectedFiles);
      emit(state.copyWith(uploadRequest: Unique(req)));
    }
  }

  void _onAddVisibleDate(_AddVisibleDate ev, Emitter<_State> emit) {
    // _log.info(ev);
    if (state.visibleDates.contains(ev.date)) {
      return;
    }
    emit(state.copyWith(visibleDates: state.visibleDates.added(ev.date)));
  }

  void _onRemoveVisibleDate(_RemoveVisibleDate ev, Emitter<_State> emit) {
    // _log.info(ev);
    if (!state.visibleDates.contains(ev.date)) {
      return;
    }
    emit(state.copyWith(visibleDates: state.visibleDates.removed(ev.date)));
  }

  void _onSetSyncProgress(_SetSyncProgress ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(syncProgress: ev.progress));
  }

  void _onStartScaling(_StartScaling ev, Emitter<_State> emit) {
    _log.info(ev);
  }

  Future<void> _onEndScaling(_EndScaling ev, Emitter<_State> emit) async {
    _log.info(ev);
    if (state.scale == null) {
      return;
    }
    final int newZoom;
    final currZoom = state.zoom;
    if (state.scale! >= 1.25) {
      // scale up
      newZoom = (currZoom + 1).clamp(-1, 2);
    } else if (state.scale! <= 0.75) {
      newZoom = (currZoom - 1).clamp(-1, 2);
    } else {
      newZoom = currZoom;
    }
    emit(state.copyWith(zoom: newZoom, scale: null));
    await prefController.setHomePhotosZoomLevel(newZoom);
    if ((currZoom >= 0) != (newZoom >= 0)) {
      add(const _UpdateDateTimeGroup());
    } else if (newZoom != currZoom) {
      add(const _UpdateZoom());
    }
  }

  void _onStartScrolling(_StartScrolling ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isScrolling: true));
  }

  void _onEndScrolling(_EndScrolling ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isScrolling: false));
  }

  void _onSetScale(_SetScale ev, Emitter<_State> emit) {
    // _log.info(ev);
    emit(state.copyWith(scale: ev.scale));
  }

  void _onSetFinger(_SetFinger ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(finger: ev.value));
  }

  void _onSetLayoutConstraint(_SetLayoutConstraint ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.viewHeight == ev.viewHeight && state.viewWidth == ev.viewWidth) {
      // nothing changed
      return;
    }
    final measurement = _measureItem(
      ev.viewWidth,
      photo_list_util.getThumbSize(state.zoom).toDouble(),
    );
    emit(
      state.copyWith(
        viewWidth: ev.viewWidth,
        viewHeight: ev.viewHeight,
        viewOverlayPadding: ev.viewOverlayPadding,
        itemPerRow: measurement.itemPerRow,
        itemSize: measurement.itemSize,
      ),
    );
  }

  Future<void> _onTransformMinimap(
    _TransformMinimap ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    if (state.itemSize == null ||
        state.itemPerRow == null ||
        state.viewHeight == null ||
        state.viewOverlayPadding == null) {
      _log.warning("[_onTransformMinimap] Layout measurements not ready");
      return;
    }
    // valid content height, this is also the minimap height
    final contentHeight = state.viewHeight! - state.viewOverlayPadding!;
    final maker =
        prefController.homePhotosZoomLevelValue >= 0
            ? _makeMinimapItems
            : _makeMonthGroupMinimapItems;
    final summary = SplayTreeMap<Date, int>((a, b) => b.compareTo(a));
    for (final e in state.filesSummary.items.entries) {
      summary[e.key] = e.value.count;
    }
    for (final e in state.localFilesSummary.items.entries) {
      summary[e.key] = (summary[e.key] ?? 0) + e.value;
    }
    final minimapItems = maker(
      filesSummary: summary,
      itemSize: state.itemSize!,
      itemPerRow: state.itemPerRow!,
      viewHeight: contentHeight,
    );
    var totalHeight =
        minimapItems.map((e) => e.logicalHeight).sum + bottomAppBarHeight;
    if (state.isEnableMemoryCollection && state.memoryCollections.isNotEmpty) {
      totalHeight += _MemoryCollectionItemView.height;
    }
    final ratio =
        (contentHeight - draggableThumbSize) / (totalHeight - contentHeight);
    _log.info(
      "[_onTransformMinimap] content height: $contentHeight, logical height: $totalHeight",
    );
    emit(state.copyWith(minimapItems: minimapItems, minimapYRatio: ratio));
  }

  void _onUpdateScrollDate(_UpdateScrollDate ev, Emitter<_State> emit) {
    // _log.info(ev);
    if (state.itemPerRow == null || state.visibleDates.isEmpty) {
      if (state.scrollDate != null) {
        emit(state.copyWith(scrollDate: null));
      }
      return;
    }
    final dateRows = state.visibleDates
        .map((e) => e.date)
        .sortedBySelf()
        .reversed
        .groupBy(
          key: (e) {
            if (prefController.homePhotosZoomLevelValue >= 0) {
              return e;
            } else {
              // month
              return Date(e.year, e.month);
            }
          },
        )
        .map(
          (key, value) =>
              MapEntry(key, (value.length / state.itemPerRow!).ceil()),
        );
    final totalRows = dateRows.values.sum;
    final midRow = totalRows / 2;
    var x = 0;
    for (final e in dateRows.entries) {
      x += e.value;
      if (x >= midRow) {
        if (state.scrollDate != e.key) {
          emit(state.copyWith(scrollDate: e.key));
        }
        return;
      }
    }
  }

  void _onSetEnableMemoryCollection(
    _SetEnableMemoryCollection ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    emit(state.copyWith(isEnableMemoryCollection: ev.value));
    if (ev.value) {
      add(const _UpdateMemories());
    }
  }

  void _onUpdateZoom(_UpdateZoom ev, _Emitter emit) {
    _log.info(ev);
    if (state.viewWidth != null) {
      final measurement = _measureItem(
        state.viewWidth!,
        photo_list_util.getThumbSize(state.zoom).toDouble(),
      );
      emit(
        state.copyWith(
          itemPerRow: measurement.itemPerRow,
          itemSize: measurement.itemSize,
        ),
      );
    }
    add(const _TransformMinimap());
  }

  void _onUpdateDateTimeGroup(_UpdateDateTimeGroup ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.viewWidth != null) {
      final measurement = _measureItem(
        state.viewWidth!,
        photo_list_util.getThumbSize(state.zoom).toDouble(),
      );
      emit(
        state.copyWith(
          itemPerRow: measurement.itemPerRow,
          itemSize: measurement.itemSize,
        ),
      );
    }
    _transformItems(
      state.files,
      state.filesSummary,
      state.localFiles,
      state.localFilesSummary,
    );
    add(const _TransformMinimap());
  }

  Future<void> _onUpdateMemories(
    _UpdateMemories ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    final localToday = clock.now().toLocal().toDate();
    final dbMemories = await _c.npDb.getFilesMemories(
      account: account.toDb(),
      at: localToday,
      radius: prefController.memoriesRangeValue,
      includeRelativeRoots:
          account.roots
              .map(
                (e) =>
                    File(
                      path: file_util.unstripPath(account, e),
                    ).strippedPathWithEmpty,
              )
              .toList(),
      excludeRelativeRoots: [remote_storage_util.remoteStorageDirRelativePath],
      mimes: file_util.supportedFormatMimes,
    );
    emit(
      state.copyWith(
        memoryCollections:
            dbMemories.memories.entries
                .sorted((a, b) => a.key.compareTo(b.key))
                .reversed
                .map((e) {
                  final center = localToday
                      .copyWith(year: e.key)
                      .toLocalDateTime()
                      .copyWith(hour: 12);
                  return Collection(
                    name: L10n.global().memoryAlbumName(
                      localToday.year - e.key,
                    ),
                    contentProvider: CollectionMemoryProvider(
                      account: account,
                      year: e.key,
                      month: localToday.month,
                      day: localToday.day,
                      cover: e.value
                          .map(
                            (e) => (
                              comparable: e.bestDateTime.difference(center),
                              item: e,
                            ),
                          )
                          .sorted(
                            (a, b) => a.comparable.compareTo(b.comparable),
                          )
                          .firstOrNull
                          ?.let(
                            (e) => DbFileDescriptorConverter.fromDb(
                              account.userId.toString(),
                              e.item,
                            ),
                          ),
                    ),
                  );
                })
                .toList(),
      ),
    );
  }

  void _onTripMissingVideoPreview(
    _TripMissingVideoPreview ev,
    Emitter<_State> emit,
  ) {
    // _log.info(ev);
    if (!state.hasMissingVideoPreview) {
      emit(state.copyWith(hasMissingVideoPreview: true));
    }
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  void _transformItems(
    List<FileDescriptor> files,
    DbFilesSummary summary,
    List<LocalFile> localFiles,
    LocalFilesSummary localSummary,
  ) {
    _log.info(
      "[_transformItems] Queue ${files.length} remote items, ${localFiles.length} local items",
    );
    _itemTransformerQueue.addJob(
      _ItemTransformerArgument(
        account: account,
        files: files,
        summary: summary,
        localFiles: localFiles,
        localSummary: localSummary,
        itemPerRow: state.itemPerRow,
        itemSize: state.itemSize,
        isGroupByDay: prefController.homePhotosZoomLevelValue >= 0,
      ),
      _buildItem,
      (result) {
        if (!isClosed) {
          add(_OnItemTransformed(result.items, result.dates));
        }
      },
    );
  }

  void _syncRemote() {
    final stopwatch = Stopwatch()..start();
    filesController
        .syncRemote(
          onProgressUpdate: (progress) {
            if (!isClosed) {
              add(_SetSyncProgress(progress));
            }
          },
        )
        .whenComplete(() {
          if (!isClosed) {
            add(const _SetSyncProgress(null));
          }
          syncController.requestSync(
            account: account,
            filesController: filesController,
            personsController: personsController,
            personProvider: accountPrefController.personProviderValue,
          );
          metadataController.kickstart();
          _log.info(
            "[_syncRemote] Elapsed time: ${stopwatch.elapsedMilliseconds}ms",
          );
        });
  }

  void _clearSelection(Emitter<_State> emit) {
    emit(state.copyWith(selectedItems: const {}));
  }

  void _onVisibleDatesUpdated() {
    _filesQueryTimer?.cancel();
    _filesQueryTimer = Timer(const Duration(milliseconds: 500), () {
      if (!_isQueryingFiles) {
        _requestMoreFiles();
      }
    });
  }

  void _requestMoreFiles() {
    final queriedDates = state.queriedDates;
    final missingDates =
        state.visibleDates
            .map((e) => e.date)
            .whereNot((d) => queriedDates.contains(d))
            .where(
              (d) =>
                  state.filesSummary.items.containsKey(d) ||
                  state.localFilesSummary.items.containsKey(d),
            )
            .toSet();
    // remove dates no longer missing
    _queryCount.removeWhere((k, v) => !missingDates.contains(k));
    if (missingDates.isNotEmpty && !_isQueryingFiles) {
      final missingDatesSorted = missingDates.sortedBySelf();
      for (final d in missingDatesSorted.reversed) {
        _queryCount[d] = (_queryCount[d] ?? 0) + 1;
        if (_queryCount[d]! > 4) {
          _log.warning(
            "[_requestMoreFiles] Date failed for too many times, ignore: $d",
          );
          continue;
        }
        _requestFilesFrom(missingDates.sortedBySelf().last);
        break;
      }
    }
  }

  /// Query a set number of files taken on or before [at]
  Future<void> _requestFilesFrom(Date at) async {
    const targetFileCount = 100;

    _log.info("[_requestFilesFrom] $at");
    _isQueryingFiles = true;
    try {
      final summary = state.filesSummary;
      final localSummary = state.localFilesSummary;
      var dates = {
        ...summary.items.keys,
        ...localSummary.items.keys,
      }.sorted((a, b) => b.compareTo(a));
      final i = dates.indexWhere((e) => e.isBeforeOrAt(at));
      if (i == -1) {
        _log.info("[_requestFilesFrom] No more files before $at");
        return;
      }
      dates = dates.sublist(i);
      final begin = dates.first;
      _log.info("[_requestFilesFrom] First date of interest: $begin");
      var count = 0;
      Date? end;
      final included = <Date>[];
      for (final d in dates) {
        included.add(d);
        count += (summary.items[d]?.count ?? 0) + (localSummary.items[d] ?? 0);
        end = d;
        if (count >= targetFileCount) {
          break;
        }
      }
      _log.info("[_requestFilesFrom] Query $count files until $end");
      await Future.wait([
        filesController.queryTimelineByDateRange(
          DateRange(from: end, to: at.add(day: 1)),
        ),
        localFilesController.queryTimelineByDateRange(
          DateRange(from: end, to: at.add(day: 1)),
        ),
      ]);
    } finally {
      _isQueryingFiles = false;
    }
  }

  List<_MinimapItem> _makeMonthGroupMinimapItems({
    required Map<Date, int> filesSummary,
    required double itemSize,
    required int itemPerRow,
    required double viewHeight,
  }) {
    _log.info(
      "[_makeMonthGroupMinimapItems] itemSize: $itemSize, itemPerRow: $itemPerRow, viewHeight: $viewHeight",
    );
    double position = 0;
    Date? currentMonth;
    double currentMonthY = 0;
    var currentMonthCount = 0;
    final results = <_MinimapItem>[];
    for (final e in filesSummary.entries) {
      final thisMonth = Date(e.key.year, e.key.month);
      if (currentMonth != thisMonth) {
        if (currentMonth != null) {
          final h = _getLogicalHeightByItemCount(
            itemCount: currentMonthCount,
            rowHeight: itemSize,
            itemPerRow: itemPerRow,
          );
          results.add(
            _MinimapItem(
              date: currentMonth,
              logicalY: currentMonthY,
              logicalHeight: h,
            ),
          );
          position += h;
        }
        currentMonth = thisMonth;
        currentMonthY = position;
        currentMonthCount = e.value;
      } else {
        currentMonthCount += e.value;
      }
    }
    // add the last month
    if (currentMonth != null) {
      final h = _getLogicalHeightByItemCount(
        itemCount: currentMonthCount,
        rowHeight: itemSize,
        itemPerRow: itemPerRow,
      );
      results.add(
        _MinimapItem(
          date: currentMonth,
          logicalY: currentMonthY,
          logicalHeight: h,
        ),
      );
    }
    return results;
  }

  List<_MinimapItem> _makeMinimapItems({
    required Map<Date, int> filesSummary,
    required double itemSize,
    required int itemPerRow,
    required double viewHeight,
  }) {
    _log.info(
      "[_makeMinimapItems] itemSize: $itemSize, itemPerRow: $itemPerRow, viewHeight: $viewHeight",
    );
    double position = 0;
    Date? currentMonth;
    double currentMonthY = 0;
    double currentMonthHeight = 0;
    final results = <_MinimapItem>[];
    for (final e in filesSummary.entries) {
      final thisMonth = Date(e.key.year, e.key.month);
      final h = _getLogicalHeightByItemCount(
        itemCount: e.value,
        rowHeight: itemSize,
        itemPerRow: itemPerRow,
      );
      if (currentMonth != thisMonth) {
        if (currentMonth != null) {
          results.add(
            _MinimapItem(
              date: currentMonth,
              logicalY: currentMonthY,
              logicalHeight: currentMonthHeight,
            ),
          );
        }
        currentMonth = thisMonth;
        currentMonthY = position;
        currentMonthHeight = h;
      } else {
        currentMonthHeight += h;
      }
      position += h;
    }
    // add the last month
    if (currentMonth != null) {
      results.add(
        _MinimapItem(
          date: currentMonth,
          logicalY: currentMonthY,
          logicalHeight: currentMonthHeight,
        ),
      );
    }
    return results;
  }

  final DiContainer _c;
  final Account account;
  final AnyFilesController anyFilesController;
  final FilesController filesController;
  final PrefController prefController;
  final AccountPrefController accountPrefController;
  final CollectionsController collectionsController;
  final SyncController syncController;
  final PersonsController personsController;
  final MetadataController metadataController;
  final ServerController serverController;
  final LocalFilesController localFilesController;
  final double bottomAppBarHeight;
  final double draggableThumbSize;

  final _itemTransformerQueue =
      ComputeQueue<_ItemTransformerArgument, _ItemTransformerResult>();
  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
  var _isInitialLoad = true;
  var _isQueryingFiles = false;
  Timer? _filesQueryTimer;
  final _queryCount = <Date, int>{};
}

double _getLogicalHeightByItemCount({
  required int itemCount,
  required double rowHeight,
  required int itemPerRow,
}) {
  const dateHeight = 32.0;
  return dateHeight + (itemCount / itemPerRow).ceil() * rowHeight;
}

_ItemTransformerResult _buildItem(_ItemTransformerArgument arg) {
  const sorter = compareFileDescriptorDateTimeDescending;
  const localSorter = compareLocalFileDateTimeDescending;

  final sortedFiles = arg.files
      .where((f) => f.fdIsArchived != true)
      .sorted(sorter);
  final sortedLocalFiles = arg.localFiles.sorted(localSorter);

  final tzOffset = clock.now().timeZoneOffset;
  final fileGroups = groupBy<FileDescriptor, Date>(sortedFiles, (e) {
    // convert to local date
    return e.fdDateTime.add(tzOffset).toDate();
  });
  final localFileGroups = groupBy<LocalFile, Date>(sortedLocalFiles, (e) {
    // convert to local date
    return e.bestDateTime.add(tzOffset).toDate();
  });

  final dateHelper = photo_list_util.DateGroupHelper(
    isMonthOnly: !arg.isGroupByDay,
  );
  final dateTimeSet = SplayTreeSet<Date>.of([
    ...fileGroups.keys,
    ...arg.summary.items.keys,
    ...localFileGroups.keys,
    ...arg.localSummary.items.keys,
  ], (key1, key2) => key2.compareTo(key1));
  final transformed = <List<_Item>>[];
  final dates = <Date>{};
  for (final d in dateTimeSet) {
    final date = dateHelper.onDate(d);
    if (date != null) {
      transformed.add([_DateItem(date: d, isMonthOnly: !arg.isGroupByDay)]);
    }

    final items = <(DateTime, _Item)>[];
    final summaryItems = <_SummaryFileItem>[];
    if (arg.summary.items.containsKey(d)) {
      if (fileGroups.containsKey(d)) {
        items.addAll(
          fileGroups[d]
                  ?.map(
                    (f) => _buildSingleRemoteItem(
                      arg.account,
                      f,
                    )?.let((e) => (f.fdDateTime, e)),
                  )
                  .nonNulls ??
              [],
        );
      } else {
        final summary = arg.summary.items[d]!;
        for (var i = 0; i < summary.count; ++i) {
          summaryItems.add(
            _SummaryFileItem(date: d, index: summaryItems.length),
          );
        }
      }
    }
    if (arg.localSummary.items.containsKey(d)) {
      if (localFileGroups.containsKey(d)) {
        items.addAll(
          localFileGroups[d]
                  ?.map(
                    (f) => _buildSingleLocalItem(
                      f,
                    )?.let((e) => (f.bestDateTime, e)),
                  )
                  .nonNulls ??
              [],
        );
      } else {
        final count = arg.localSummary.items[d]!;
        for (var i = 0; i < count; ++i) {
          summaryItems.add(
            _SummaryFileItem(date: d, index: summaryItems.length),
          );
        }
      }
    }
    items.sort((a, b) => b.$1.compareTo(a.$1));
    transformed.last.addAll(items.map((e) => e.$2));
    transformed.last.addAll(summaryItems);

    if (summaryItems.isEmpty) {
      dates.add(d);
    }
  }
  return _ItemTransformerResult(items: transformed, dates: dates);
}

_Item? _buildSingleRemoteItem(Account account, FileDescriptor file) {
  if (file_util.isSupportedImageFormat(file)) {
    return _NextcloudPhotoItem(remoteFile: file, account: account);
  } else if (file_util.isSupportedVideoFormat(file)) {
    return _NextcloudVideoItem(remoteFile: file, account: account);
  } else {
    _$__NpLog.log.shout(
      "[_buildSingleItem] Unsupported file format: ${file.fdMime}",
    );
    return null;
  }
}

_Item? _buildSingleLocalItem(LocalFile file) {
  if (file_util.isSupportedImageMime(file.mime ?? "")) {
    return _LocalPhotoItem(localFile: file);
  } else if (file_util.isSupportedVideoMime(file.mime ?? "")) {
    return _LocalVideoItem(localFile: file);
  } else {
    _$__NpLog.log.shout(
      "[_buildSingleLocalItem] Unsupported file format: ${file.mime}",
    );
    return null;
  }
}

class _ItemMeasurement {
  const _ItemMeasurement({required this.itemPerRow, required this.itemSize});

  final int itemPerRow;
  final double itemSize;
}

_ItemMeasurement _measureItem(double viewWidth, double maxItemWidth) {
  final maxCountPerRow = viewWidth / maxItemWidth;
  final itemPerRow = maxCountPerRow.ceil();
  final size = viewWidth / itemPerRow;
  return _ItemMeasurement(itemPerRow: itemPerRow, itemSize: size);
}
