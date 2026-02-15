part of 'collection_browser.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({
    required DiContainer container,
    required this.account,
    required this.prefController,
    required this.collectionsController,
    required this.filesController,
    required this.db,
    required Collection collection,
    required this.dateHeight,
  }) : _c = container,
       _isAdHocCollection =
           !collectionsController.stream.value.data.any(
             (e) => e.collection.compareIdentity(collection),
           ),
       super(
         _State.init(
           collection: collection,
           cover: _getCover(collection),
           zoom: prefController.albumBrowserZoomLevelValue,
         ),
       ) {
    _initItemController(collection);

    on<_UpdateCollection>(_onUpdateCollection);
    on<_LoadItems>(_onLoad);
    on<_TransformItems>(_onTransformItems);
    on<_ImportPendingSharedCollection>(_onImportPendingSharedCollection);

    on<_Download>(_onDownload);

    on<_BeginEdit>(_onBeginEdit);
    on<_EditName>(_onEditName);
    on<_RequestAddLabel>(_onRequestAddLabel);
    on<_RequestAddLabel2>(_onRequestAddLabel2);
    on<_AddLabelToCollection>(_onAddLabelToCollection);
    on<_RequestEditLabel>(_onRequestEditLabel);
    on<_EditLabel>(_onEditLabel);
    on<_RequestAddMap>(_onRequestAddMap);
    on<_RequestAddMap2>(_onRequestAddMap2);
    on<_AddMapToCollection>(_onAddMapToCollection);
    on<_RequestEditMap>(_onRequestEditMap);
    on<_EditMap>(_onEditMap);
    on<_EditSort>(_onEditSort);
    on<_EditManualSort>(_onEditManualSort);
    on<_TransformEditItems>(_onTransformEditItems);
    on<_DoneEdit>(_onDoneEdit, transformer: concurrent());
    on<_CancelEdit>(_onCancelEdit);
    on<_CancelEditPickerMode>((ev, emit) {
      _log.info(ev);
      emit(state.copyWith(editPickerMode: null));
    });

    on<_UnsetCover>(_onUnsetCover);

    on<_SetSelectedItems>(_onSetSelectedItems);
    on<_DownloadSelectedItems>(_onDownloadSelectedItems);
    on<_AddSelectedItemsToCollection>(_onAddSelectedItemsToCollection);
    on<_RemoveSelectedItemsFromCollection>(
      _onRemoveSelectedItemsFromCollection,
    );
    on<_ArchiveSelectedItems>(
      _onArchiveSelectedItems,
      transformer: concurrent(),
    );
    on<_DeleteSelectedItems>(_onDeleteSelectedItems);
    on<_ShareSelectedItems>(_onShareSelectedItems);

    on<_SetDragging>(_onSetDragging);

    on<_StartScaling>(_onStartScaling);
    on<_EndScaling>(_onEndScaling);
    on<_SetScale>(_onSetScale);

    on<_SetError>(_onSetError);
    on<_SetMessage>(_onSetMessage);

    if (!_isAdHocCollection) {
      _subscriptions.add(
        collectionsController.stream.listen((event) {
          final c = event.data.firstWhere(
            (d) => state.collection.compareIdentity(d.collection),
          );
          if (!identical(c, state.collection)) {
            add(_UpdateCollection(c.collection));
          }
        }),
      );
    } else {
      _log.info("[_Bloc] Ad hoc collection");
    }

    _subscriptions.add(
      itemsController.stream.listen((event) {
        if (!event.hasNext && _isInitialLoad) {
          _isInitialLoad = false;
          filesController.queryByFileId(
            event.items
                .whereType<CollectionFileItem>()
                .map((e) => e.file.fdId)
                .toList(),
          );
        }
      }),
    );
  }

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  @override
  bool Function(dynamic, dynamic)? get shouldLog => (currentState, nextState) {
    return currentState.scale == nextState.scale;
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

  bool isCollectionCapabilityPermitted(CollectionCapability capability) {
    return CollectionAdapter.of(
      _c,
      account,
      state.collection,
    ).isPermitted(capability);
  }

  bool get isAdHocCollection => _isAdHocCollection;

  void _onUpdateCollection(_UpdateCollection ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(collection: ev.collection));
    _updateCover(emit);
  }

  Future<void> _onLoad(_LoadItems ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        itemsController.stream,
        onData:
            (data) => state.copyWith(
              items: _filterItems(data.items, state.itemsWhitelist),
              rawItems: data.items,
              isLoading: data.hasNext,
            ),
      ),
      forEach(
        emit,
        itemsController.errorStream,
        onData: (data) => state.copyWith(isLoading: false, error: data),
      ),
      // do we need this as we already filter files in filesController?
      forEach(
        emit,
        filesController.stream,
        onData: (data) {
          final whitelist = HashSet.of(data.dataMap.keys);
          return state.copyWith(
            items: _filterItems(state.rawItems, whitelist),
            itemsWhitelist: whitelist,
          );
        },
      ),
      forEach(
        emit,
        filesController.errorStream,
        onData:
            (data) => state.copyWith(
              isLoading: false,
              error: ExceptionEvent(data.error, data.stackTrace),
            ),
      ),
    ]);
  }

  void _onTransformItems(_TransformItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final result = _transformItems(ev.items, state.collection.itemSort);
    emit(state.copyWith(transformedItems: result.transformed));
    _updateCover(emit);
  }

  void _onDownload(_Download ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.items.isNotEmpty) {
      unawaited(
        DownloadHandler(_c).downloadFiles(
          account,
          state.items
              .whereType<CollectionFileItem>()
              .map((e) => e.file)
              .toList(),
          parentDir: state.collection.name,
        ),
      );
    }
  }

  Future<void> _onImportPendingSharedCollection(
    _ImportPendingSharedCollection ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    final newCollection = await collectionsController
        .importPendingSharedCollection(state.collection);
    if (newCollection != null) {
      emit(state.copyWith(importResult: newCollection));
    }
  }

  void _onBeginEdit(_BeginEdit ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isEditMode: true));
  }

  void _onEditName(_EditName ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(editName: ev.name));
  }

  void _onRequestAddLabel(_RequestAddLabel ev, _Emitter emit) {
    _log.info(ev);
    if (state.transformedItems.isNotEmpty) {
      emit(state.copyWith(editPickerMode: _EditPickerMode.label));
    } else {
      add(const _RequestAddLabel2(before: null));
    }
  }

  void _onRequestAddLabel2(_RequestAddLabel2 ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        editPickerMode: null,
        newLabelRequest: Unique(_NewLabelRequest(before: ev.before)),
      ),
    );
  }

  void _onAddLabelToCollection(_AddLabelToCollection ev, Emitter<_State> emit) {
    _log.info(ev);
    assert(isCollectionCapabilityPermitted(CollectionCapability.labelItem));
    var at = 0;
    if (ev.before != null) {
      at = (state.editItems ?? state.items).indexOf(ev.before!.original);
      if (at == -1) {
        at = 0;
      }
    }
    emit(
      state.copyWith(
        editItems: (state.editItems ?? state.items).inserted(
          at,
          NewCollectionLabelItem(ev.label, clock.now().toUtc()),
        ),
      ),
    );
  }

  void _onRequestEditLabel(_RequestEditLabel ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(editLabelRequest: Unique(_EditLabelRequest(ev.item))));
  }

  void _onEditLabel(_EditLabel ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        editItems:
            (state.editItems ?? state.items).map((e) {
              if (e.id == ev.item.id) {
                return NewCollectionLabelItem(ev.newText, clock.now().toUtc());
              } else {
                return e;
              }
            }).toList(),
      ),
    );
  }

  void _onRequestAddMap(_RequestAddMap ev, _Emitter emit) {
    _log.info(ev);
    if (state.transformedItems.isNotEmpty) {
      emit(state.copyWith(editPickerMode: _EditPickerMode.map));
    } else {
      add(const _RequestAddMap2(before: null));
    }
  }

  Future<void> _onRequestAddMap2(_RequestAddMap2 ev, _Emitter emit) async {
    _log.info(ev);
    emit(state.copyWith(isAddMapBusy: true, editPickerMode: null));
    MapCoord? mapCoord;
    try {
      if (ev.before != null) {
        final interest = state.editTransformedItems ?? state.transformedItems;
        final i = interest.indexOf(ev.before!);
        if (i != -1) {
          // take the first gps data from the next 20 files
          final files = await FindFile(_c).call(
            account,
            interest
                .pySlice(i)
                .whereType<_FileItem>()
                .map((e) => e.file.fdId)
                .take(20)
                .toList(),
            onFileNotFound: (_) {},
          );
          final location =
              files
                  .firstWhereOrNull((e) => e.metadata?.gpsCoord != null)
                  ?.metadata
                  ?.gpsCoord;
          mapCoord = location?.let((e) => MapCoord(e.lat, e.lng));
        }
      }
      if (mapCoord == null && state.transformedItems.isNotEmpty) {
        final location = await db.getFirstLocationOfFileIds(
          account: account.toDb(),
          fileIds:
              state.transformedItems
                  .whereType<_FileItem>()
                  .map((e) => e.file.fdId)
                  .toList(),
        );
        mapCoord = location?.let((e) => MapCoord(e.latitude!, e.longitude!));
      }
      emit(
        state.copyWith(
          placePickerRequest: Unique(
            _PlacePickerRequest(initialPosition: mapCoord, before: ev.before),
          ),
        ),
      );
    } catch (e, stackTrace) {
      _log.severe(
        "[_onRequestAddMap2] Failed while getFirstLocationOfFileIds",
        e,
        stackTrace,
      );
      emit(
        state.copyWith(
          placePickerRequest: Unique(_PlacePickerRequest(before: ev.before)),
        ),
      );
    } finally {
      emit(state.copyWith(isAddMapBusy: false));
    }
  }

  void _onAddMapToCollection(_AddMapToCollection ev, Emitter<_State> emit) {
    _log.info(ev);
    assert(isCollectionCapabilityPermitted(CollectionCapability.mapItem));
    var at = 0;
    if (ev.before != null) {
      at = (state.editItems ?? state.items).indexOf(ev.before!.original);
      if (at == -1) {
        at = 0;
      }
    }
    emit(
      state.copyWith(
        editItems: (state.editItems ?? state.items).inserted(
          at,
          NewCollectionMapItem(ev.location, clock.now().toUtc()),
        ),
      ),
    );
  }

  void _onRequestEditMap(_RequestEditMap ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(editMapRequest: Unique(_EditMapRequest(ev.item))));
  }

  void _onEditMap(_EditMap ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        editItems:
            (state.editItems ?? state.items).map((e) {
              if (e.id == ev.item.id) {
                return NewCollectionMapItem(
                  ev.newLocation,
                  clock.now().toUtc(),
                );
              } else {
                return e;
              }
            }).toList(),
      ),
    );
  }

  void _onEditSort(_EditSort ev, Emitter<_State> emit) {
    _log.info(ev);
    final result = _transformItems(state.editItems ?? state.items, ev.sort);
    emit(
      state.copyWith(
        editSort: ev.sort,
        editTransformedItems: result.transformed,
      ),
    );
  }

  void _onEditManualSort(_EditManualSort ev, Emitter<_State> emit) {
    _log.info(ev);
    assert(isCollectionCapabilityPermitted(CollectionCapability.manualSort));
    emit(
      state.copyWith(
        editSort: CollectionItemSort.manual,
        editItems:
            ev.sorted.whereType<_ActualItem>().map((e) => e.original).toList(),
        editTransformedItems: ev.sorted,
      ),
    );
  }

  void _onTransformEditItems(_TransformEditItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final result = _transformItems(
      ev.items,
      state.editSort ?? state.collection.itemSort,
    );
    emit(state.copyWith(editTransformedItems: result.transformed));
  }

  Future<void> _onDoneEdit(_DoneEdit ev, Emitter<_State> emit) async {
    _log.info(ev);
    emit(state.copyWith(isEditBusy: true));
    try {
      if (state.editName != null ||
          state.editItems != null ||
          state.editSort != null) {
        await collectionsController.edit(
          state.collection,
          name: state.editName,
          items: state.editItems,
          itemSort: state.editSort,
        );
      }
      emit(
        state.copyWith(
          isEditMode: false,
          isEditBusy: false,
          editName: null,
          editItems: null,
          editTransformedItems: null,
          editSort: null,
        ),
      );
    } catch (e, stackTrace) {
      _log.severe("[_onDoneEdit] Failed while edit", e, stackTrace);
      emit(
        state.copyWith(error: ExceptionEvent(e, stackTrace), isEditBusy: false),
      );
    }
  }

  void _onCancelEdit(_CancelEdit ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        isEditMode: false,
        editName: null,
        editItems: null,
        editTransformedItems: null,
        editSort: null,
      ),
    );
  }

  void _onUnsetCover(_UnsetCover ev, Emitter<_State> emit) {
    _log.info(ev);
    collectionsController.edit(state.collection, cover: const OrNull(null));
  }

  void _onSetSelectedItems(_SetSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final adapter = CollectionAdapter.of(_c, account, state.collection);
    emit(
      state.copyWith(
        selectedItems: ev.items,
        isSelectionRemovable: ev.items
            .whereType<_ActualItem>()
            .map((e) => e.original)
            .any(adapter.isItemRemovable),
        isSelectionDeletable: ev.items
            .whereType<_ActualItem>()
            .map((e) => e.original)
            .any(adapter.isItemDeletable),
      ),
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
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      unawaited(DownloadHandler(_c).downloadFiles(account, selectedFiles));
    }
  }

  void _onAddSelectedItemsToCollection(
    _AddSelectedItemsToCollection ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
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

  void _onRemoveSelectedItemsFromCollection(
    _RemoveSelectedItemsFromCollection ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final adapter = CollectionAdapter.of(_c, account, state.collection);
    final selectedItems =
        selected
            .whereType<_ActualItem>()
            .map((e) => e.original)
            .where(adapter.isItemRemovable)
            .toList();
    if (selectedItems.isNotEmpty) {
      unawaited(itemsController.removeItems(selectedItems));
    }
  }

  void _onArchiveSelectedItems(_ArchiveSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      filesController.updateProperty(
        selectedFiles,
        isArchived: const OrNull(true),
        errorBuilder: (fileIds) => _ArchiveFailedError(fileIds.length),
      );
    }
  }

  Future<void> _onDeleteSelectedItems(
    _DeleteSelectedItems ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final adapter = CollectionAdapter.of(_c, account, state.collection);
    final selectedItems =
        selected
            .whereType<_ActualItem>()
            .map((e) => e.original)
            .where(adapter.isItemRemovable)
            .toList();
    final selectedFiles =
        selected
            .whereType<_FileItem>()
            .where((e) => adapter.isItemDeletable(e.original))
            .map((e) => e.file)
            .toList();
    if (selectedFiles.isNotEmpty) {
      await filesController.remove(
        selectedFiles,
        errorBuilder: (fileIds) {
          return _RemoveFailedError(fileIds.length);
        },
      );
      // deleting files will also remove them from the collection
      unawaited(itemsController.removeItems(selectedItems));
    }
  }

  void _onShareSelectedItems(_ShareSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file.toAnyFile()).toList();
    if (selectedFiles.isNotEmpty) {
      emit(
        state.copyWith(
          shareRequest: Unique(_ShareRequest(files: selectedFiles)),
        ),
      );
    } else {
      emit(
        state.copyWith(message: L10n.global().shareSelectedEmptyNotification),
      );
    }
  }

  void _onSetDragging(_SetDragging ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isDragging: ev.flag));
  }

  void _onStartScaling(_StartScaling ev, Emitter<_State> emit) {
    _log.info(ev);
  }

  void _onEndScaling(_EndScaling ev, Emitter<_State> emit) {
    _log.info(ev);
    if (state.scale == null) {
      return;
    }
    final int newZoom;
    if (state.scale! >= 1.25) {
      // scale up
      newZoom = (state.zoom + 1).clamp(-1, 2);
    } else if (state.scale! <= 0.75) {
      newZoom = (state.zoom - 1).clamp(-1, 2);
    } else {
      newZoom = state.zoom;
    }
    emit(state.copyWith(zoom: newZoom, scale: null));
    unawaited(prefController.setAlbumBrowserZoomLevel(newZoom));
  }

  void _onSetScale(_SetScale ev, Emitter<_State> emit) {
    emit(state.copyWith(scale: ev.scale));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  void _onSetMessage(_SetMessage ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(message: ev.message));
  }

  void _initItemController(Collection collection) {
    try {
      itemsController = collectionsController.stream.value
          .itemsControllerByCollection(collection);
    } catch (e) {
      _log.info(
        "[_initItemController] Collection not found in global controller, building new ad-hoc item controller",
        e,
      );
      itemsController = CollectionItemsController(
        _c,
        filesController: filesController,
        account: account,
        collection: collection,
        onCollectionUpdated: (_) {},
      );
    }
  }

  void _clearSelection(Emitter<_State> emit) {
    emit(
      state.copyWith(
        selectedItems: const {},
        isSelectionRemovable: true,
        isSelectionManageableFile: true,
      ),
    );
  }

  /// Convert [CollectionItem] to the corresponding [_Item]
  _TransformResult _transformItems(
    List<CollectionItem> items,
    CollectionItemSort sort,
  ) {
    final sorter = CollectionSorter.fromSortType(sort);
    final sortedItems = sorter(items);
    final dateHelper = photo_list_util.DateGroupHelper(isMonthOnly: false);

    final transformed = <_Item>[];
    for (int i = 0; i < sortedItems.length; ++i) {
      final item = sortedItems[i];
      if (item is CollectionFileItem) {
        if (sorter is CollectionTimeSorter &&
            _c.pref.isAlbumBrowserShowDateOr()) {
          final date = dateHelper.onDate(
            item.file.fdDateTime.toLocal().toDate(),
          );
          if (date != null) {
            transformed.add(_DateItem(date: date, height: dateHeight));
          }
        }

        if (file_util.isSupportedImageMime(item.file.fdMime ?? "")) {
          transformed.add(
            _PhotoItem(original: item, file: item.file, account: account),
          );
        } else if (file_util.isSupportedVideoMime(item.file.fdMime ?? "")) {
          transformed.add(
            _VideoItem(original: item, file: item.file, account: account),
          );
        } else {
          _log.shout(
            "[_transformItems] Unsupported file format: ${item.file.fdMime}",
          );
        }
      } else if (item is CollectionLabelItem) {
        transformed.add(
          _LabelItem(
            original: item,
            id: item.id,
            text: item.text,
            onEditPressed: () {
              add(_RequestEditLabel(item));
            },
          ),
        );
      } else if (item is CollectionMapItem) {
        transformed.add(
          _MapItem(
            original: item,
            id: item.id,
            location: item.location,
            onEditPressed: () {
              add(_RequestEditMap(item));
            },
          ),
        );
      }
    }
    return _TransformResult(sorted: sortedItems, transformed: transformed);
  }

  /// Remove file items not recognized by the app
  List<CollectionItem> _filterItems(
    List<CollectionItem> rawItems,
    Set<int>? whitelist,
  ) {
    if (whitelist == null) {
      return rawItems;
    }
    final results =
        rawItems.where((e) {
          if (e is CollectionFileItem) {
            if (file_util.isNcAlbumFile(account, e.file)) {
              // file shared with us are not in our db
              return true;
            } else {
              return whitelist.contains(e.file.fdId);
            }
          } else {
            return true;
          }
        }).toList();
    if (rawItems.length != results.length) {
      _log.fine(
        "[_filterItems] ${rawItems.length - results.length} items filtered out",
      );
    }
    return results;
  }

  CollectionCoverResult? _getCoverByItems() {
    try {
      final firstFile =
          state.transformedItems.whereType<_FileItem>().first.file;
      return CollectionCoverResult(
        url: getStaticViewUrlForImageFile(
          account,
          firstFile,
          size: const SizeInt(k.coverSize, k.coverSize),
          isKeepAspectRatio: false,
        ),
        mime: firstFile.fdMime,
      );
    } catch (_) {
      return null;
    }
  }

  static CollectionCoverResult? _getCover(Collection collection) {
    try {
      return collection.contentProvider.getCoverUrl(k.coverSize, k.coverSize);
    } catch (_) {
      return null;
    }
  }

  void _updateCover(Emitter<_State> emit) {
    var cover = _getCover(state.collection);
    cover ??= _getCoverByItems();
    if (cover != state.cover) {
      emit(state.copyWith(cover: cover));
    }
  }

  final DiContainer _c;
  final Account account;
  final PrefController prefController;
  final CollectionsController collectionsController;
  final FilesController filesController;
  final NpDb db;
  final double dateHeight;
  late final CollectionItemsController itemsController;

  /// Specify if the supplied [collection] is an "inline" one, which means it's
  /// not returned from the collection controller but rather created temporarily
  final bool _isAdHocCollection;
  var _isInitialLoad = true;

  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
}

class _TransformResult {
  const _TransformResult({required this.sorted, required this.transformed});

  final List<CollectionItem> sorted;
  final List<_Item> transformed;
}
