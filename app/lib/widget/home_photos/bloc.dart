part of 'home_photos.dart';

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
    on<_DeleteItemsWithHint>(_onDeleteItemsWithHint);
    on<_DownloadSelectedItems>(_onDownloadSelectedItems);
    on<_ShareSelectedItems>(_onShareSelectedItems);
    on<_SetShareRequestMethod>(_onSetShareRequestMethod);
    on<_SetShareLinkRequestResult>(_onSetShareLinkRequestResult);
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
                previous.anyFilesSummary == next.anyFilesSummary &&
                previous.viewHeight == next.viewHeight &&
                previous.itemPerRow == next.itemPerRow &&
                previous.itemSize == next.itemSize &&
                mapEquals(previous.mergedCounts, next.mergedCounts),
          )
          .listen((event) {
            add(const _TransformMinimap());
          }),
    );
    _subscriptions.add(
      stream
          .distinct(
            (previous, next) =>
                previous.anyFilesSummary == next.anyFilesSummary &&
                previous.anyFiles == next.anyFiles,
          )
          .listen((event) {
            add(
              _TransformItems(
                event.anyFiles,
                event.mergedCounts,
                event.anyFilesSummary,
              ),
            );
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
            (previous, next) =>
                previous.anyFilesSummary == next.anyFilesSummary,
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
        anyFilesController.summaryStream2,
        onData: (data) {
          if (data.hasRemoteData == false && _isInitialLoad) {
            // no data, first run?
            _isInitialLoad = false;
            _syncRemote();
          }
          return state.copyWith(
            anyFilesSummary: data.summary,
            hasRemoteData: state.hasRemoteData || (data.hasRemoteData ?? false),
          );
        },
        onError: (e, stackTrace) {
          _log.severe("[_onLoad] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        anyFilesController.timelineStream,
        onData: (data) {
          if (!data.isRemoteDummy && _isInitialLoad) {
            _isInitialLoad = false;
            _syncRemote();
          }
          return state.copyWith(
            anyFiles: data.data.values.toList(),
            mergedCounts: data.mergedCounts,
          );
        },
        onError: (e, stackTrace) {
          _log.severe("[_onLoad] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        anyFilesController.errorStream,
        onData: (data) => state.copyWith(error: data),
      ),
      forEach(
        emit,
        anyFilesController.timelineErrorStream,
        onData: (data) => state.copyWith(error: data),
      ),
      forEach(
        emit,
        anyFilesController.summaryErrorStream,
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
    _transformItems(ev.anyFiles, ev.mergedCounts, ev.summary);
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
    final canAddToCollection = ev.items.whereType<_FileItem>().any(
      (e) => AnyFileWorkerFactory.capability(
        e.file,
      ).isPermitted(AnyFileCapability.collection),
    );
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
        selected.whereType<_FileItem>().map((e) => e.file).where((f) {
          final capability = AnyFileWorkerFactory.capability(f);
          return capability.isPermitted(AnyFileCapability.collection);
        }).toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowRemoteOnlyWarning());
    }
    if (selectedFiles.isNotEmpty) {
      // TODO move this away
      final remoteFiles =
          selectedFiles
              .map((e) {
                final provider = e.provider;
                return switch (provider) {
                  AnyFileNextcloudProvider _ => provider.file,
                  AnyFileMergedProvider _ => provider.remote.file,
                  AnyFileLocalProvider _ => null,
                };
              })
              .nonNulls
              .toList();
      final targetController = collectionsController.stream.value
          .itemsControllerByCollection(ev.collection);
      targetController.addFiles(remoteFiles).onError((e, stackTrace) {
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
        selected.whereType<_FileItem>().map((e) => e.file).where((f) {
          final capability = AnyFileWorkerFactory.capability(f);
          return capability.isPermitted(AnyFileCapability.archive);
        }).toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowRemoteOnlyWarning());
    }
    anyFilesController.archive(selectedFiles, isArchived: true);
  }

  void _onDeleteSelectedItems(_DeleteSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      if (selectedFiles.any((e) => e.provider is AnyFileMergedProvider)) {
        final req = _DeleteRequest(files: selectedFiles);
        emit(state.copyWith(deleteRequest: Unique(req)));
      } else {
        anyFilesController.remove(
          selectedFiles,
          errorBuilder: (fileIds) => _RemoveFailedError(fileIds.length),
        );
      }
    }
  }

  void _onDeleteItemsWithHint(_DeleteItemsWithHint ev, Emitter<_State> emit) {
    _log.info(ev);
    anyFilesController.remove(
      ev.files,
      hint: ev.hint,
      errorBuilder: (fileIds) => _RemoveFailedError(fileIds.length),
    );
  }

  void _onDownloadSelectedItems(
    _DownloadSelectedItems ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).where((f) {
          final capability = AnyFileWorkerFactory.capability(f);
          return capability.isPermitted(AnyFileCapability.download);
        }).toList();
    if (selectedFiles.length != selected.length) {
      add(const _ShowRemoteOnlyWarning());
    }
    if (selectedFiles.isNotEmpty) {
      unawaited(DownloadAnyFile(_c, account: account)(selectedFiles));
    }
  }

  void _onShareSelectedItems(_ShareSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      final isAllRemoteShare = selectedFiles.every((f) {
        final capability = AnyFileWorkerFactory.capability(f);
        return capability.isPermitted(AnyFileCapability.remoteShare);
      });
      final isAllLocalShare = selectedFiles.every((f) {
        final capability = AnyFileWorkerFactory.capability(f);
        return capability.isPermitted(AnyFileCapability.localShare);
      });
      if (isAllLocalShare && !isAllRemoteShare) {
        // no more user input needed
        emit(
          state.copyWith(
            doShareRequest: Unique(
              _DoShareRequest(
                ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
                  selectedFiles,
                  account: account,
                  method: ShareAnyFileMethod.file,
                  onProgress: onProgress,
                  onError: onError,
                  cancelSignal: cancelSignal,
                ),
              ),
            ),
          ),
        );
      } else {
        final req = _ShareRequest(
          files: selectedFiles,
          isRemoteShareOnly: isAllRemoteShare,
        );
        emit(state.copyWith(shareRequest: Unique(req)));
      }
    }
  }

  void _onSetShareRequestMethod(_SetShareRequestMethod ev, _Emitter emit) {
    _log.info(ev);
    switch (ev.method) {
      case ShareMethodDialogResult.file:
        emit(
          state.copyWith(
            doShareRequest: Unique(
              _DoShareRequest(
                ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
                  ev.request.files,
                  account: account,
                  method: ShareAnyFileMethod.file,
                  onProgress: onProgress,
                  onError: onError,
                  cancelSignal: cancelSignal,
                ),
              ),
            ),
          ),
        );
        break;

      case ShareMethodDialogResult.preview:
        emit(
          state.copyWith(
            doShareRequest: Unique(
              _DoShareRequest(
                ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
                  ev.request.files,
                  account: account,
                  method: ShareAnyFileMethod.preview,
                  onProgress: onProgress,
                  onError: onError,
                  cancelSignal: cancelSignal,
                ),
              ),
            ),
          ),
        );
        break;

      case ShareMethodDialogResult.publicLink:
        if (ev.request.files.length == 1) {
          emit(
            state.copyWith(
              doShareRequest: Unique(
                _DoShareRequest(
                  ({onProgress, onError, cancelSignal}) =>
                      ShareAnyFile(_c).call(
                        ev.request.files,
                        account: account,
                        method: ShareAnyFileMethod.link,
                        onProgress: onProgress,
                        onError: onError,
                        cancelSignal: cancelSignal,
                      ),
                ),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              shareLinkRequest: Unique(
                _ShareLinkRequest(
                  shareRequest: ev.request,
                  isPasswordProtected: false,
                ),
              ),
            ),
          );
        }
        break;

      case ShareMethodDialogResult.passwordLink:
        emit(
          state.copyWith(
            shareLinkRequest: Unique(
              _ShareLinkRequest(
                shareRequest: ev.request,
                isPasswordProtected: true,
              ),
            ),
          ),
        );
        break;
    }
  }

  void _onSetShareLinkRequestResult(
    _SetShareLinkRequestResult ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    emit(
      state.copyWith(
        doShareRequest: Unique(
          _DoShareRequest(
            ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
              ev.request.shareRequest.files,
              account: account,
              method: ShareAnyFileMethod.link,
              linkName: ev.name,
              linkPassword: ev.password,
              onProgress: onProgress,
              onError: onError,
              cancelSignal: cancelSignal,
            ),
          ),
        ),
      ),
    );
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
    for (final e in state.anyFilesSummary.items.entries) {
      summary[e.key] = e.value;
    }
    for (final e in state.mergedCounts.entries) {
      summary[e.key] = max((summary[e.key] ?? 0) - e.value, 0);
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
    _transformItems(state.anyFiles, state.mergedCounts, state.anyFilesSummary);
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
    List<AnyFile> anyFiles,
    Map<Date, int> mergedCounts,
    AnyFilesSummary summary,
  ) {
    _log.info("[_transformItems] Queue ${anyFiles.length} items");
    final stopwatch = Stopwatch();
    _itemTransformerQueue.addJob(
      _ItemTransformerArgument(
        account: account,
        anyFiles: anyFiles,
        summary: summary,
        mergedCounts: mergedCounts,
        itemPerRow: state.itemPerRow,
        itemSize: state.itemSize,
        isGroupByDay: prefController.homePhotosZoomLevelValue >= 0,
      ),
      _buildItem,
      (result) {
        _log.info(
          "[_transformItems] Elapsed ${stopwatch.elapsedMilliseconds}ms for ${anyFiles.length} files",
        );
        if (!isClosed) {
          add(_OnItemTransformed(result.items, result.dates));
        }
      },
      onBeforeCompute: () {
        stopwatch.start();
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
            .where(state.anyFilesSummary.items.containsKey)
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
      final summary = state.anyFilesSummary;
      var dates = summary.items.keys.sorted((a, b) => b.compareTo(a));
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
        count += summary.items[d]!;
        end = d;
        if (count >= targetFileCount) {
          break;
        }
      }
      _log.info("[_requestFilesFrom] Query $count files until $end");
      await anyFilesController.queryTimelineByDateRange(
        DateRange(from: end, to: at.add(day: 1)),
      );
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
  final sortedFiles = arg.anyFiles
      .where(
        (f) =>
            f.provider is! ArchivableAnyFile ||
            (f.provider as ArchivableAnyFile).isArchived != true,
      )
      .sorted(anyFileDateTimeDescSorter);

  final tzOffset = clock.now().timeZoneOffset;
  final fileGroups = groupBy<AnyFile, Date>(sortedFiles, (e) {
    // convert to local date
    return e.dateTime.add(tzOffset).toDate();
  });

  final dateHelper = photo_list_util.DateGroupHelper(
    isMonthOnly: !arg.isGroupByDay,
  );
  final dateTimeSet = SplayTreeSet<Date>.of([
    ...fileGroups.keys,
    ...arg.summary.items.keys,
  ], (key1, key2) => key2.compareTo(key1));
  final transformed = <List<_Item>>[];
  final dates = <Date>{};
  for (final d in dateTimeSet) {
    final date = dateHelper.onDate(d);
    if (date != null) {
      transformed.add([_DateItem(date: d, isMonthOnly: !arg.isGroupByDay)]);
    }

    var items = <_FileItem>[];
    final summaryItems = <_SummaryFileItem>[];
    if (arg.summary.items.containsKey(d)) {
      final newItems =
          fileGroups[d]
              ?.map((f) => _buildSingleItem(f, account: arg.account))
              .nonNulls
              .toList() ??
          [];
      items.addAll(newItems);
      final summaryCount =
          (arg.summary.items[d] ?? 0) -
          newItems.length -
          (arg.mergedCounts[d] ?? 0);
      for (var i = 0; i < summaryCount; ++i) {
        summaryItems.add(_SummaryFileItem(date: d, index: summaryItems.length));
      }
    }
    transformed.last.addAll(items);
    transformed.last.addAll(summaryItems);

    if (summaryItems.isEmpty) {
      dates.add(d);
    }
  }
  return _ItemTransformerResult(items: transformed, dates: dates);
}

_FileItem? _buildSingleItem(AnyFile file, {required Account account}) {
  if (file_util.isSupportedImageMime(file.mime ?? "")) {
    return _PhotoItem(file: file, account: account);
  } else if (file_util.isSupportedVideoMime(file.mime ?? "")) {
    return _VideoItem(file: file, account: account);
  } else {
    _$__NpLog.log.shout(
      "[_buildSingleItem] Unsupported file format: ${file.mime}",
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
