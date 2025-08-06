part of '../archive_browser.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({
    required this.account,
    required this.filesController,
    required this.prefController,
  }) : super(_State.init(zoom: prefController.albumBrowserZoomLevelValue)) {
    on<_LoadItems>(_onLoad);
    on<_TransformItems>(_onTransformItems);
    on<_OnItemTransformed>(_onOnItemTransformed);

    on<_SetSelectedItems>(_onSetSelectedItems);
    on<_UnarchiveSelectedItems>(_onUnarchiveSelectedItems);

    on<_StartScaling>(_onStartScaling);
    on<_EndScaling>(_onEndScaling);
    on<_SetScale>(_onSetScale);

    on<_SetError>(_onSetError);
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
    currentState = currentState as _State;
    nextState = nextState as _State;
    return currentState.scale == nextState.scale &&
        currentState.visibleItems == nextState.visibleItems;
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

  Future<void> _onLoad(_LoadItems ev, Emitter<_State> emit) {
    _log.info(ev);
    unawaited(filesController.queryByArchived());
    return Future.wait([
      forEach(
        emit,
        filesController.stream,
        onData:
            (data) => state.copyWith(
              files: data.data,
              isLoading: data.hasNext || _itemTransformerQueue.isProcessing,
            ),
      ),
      forEach(
        emit,
        filesController.errorStream,
        onData:
            (data) => state.copyWith(
              isLoading: _itemTransformerQueue.isProcessing,
              error: data,
            ),
      ),
    ]);
  }

  void _onTransformItems(_TransformItems ev, Emitter<_State> emit) {
    _log.info(ev);
    _transformItems(ev.items);
    emit(state.copyWith(isLoading: true));
  }

  void _onOnItemTransformed(_OnItemTransformed ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        transformedItems: ev.items,
        isLoading: _itemTransformerQueue.isProcessing,
      ),
    );
  }

  void _onSetSelectedItems(_SetSelectedItems ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(selectedItems: ev.items));
  }

  void _onUnarchiveSelectedItems(
    _UnarchiveSelectedItems ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    final selected = state.selectedItems;
    _clearSelection(emit);
    final selectedFiles =
        selected.whereType<_FileItem>().map((e) => e.file).toList();
    if (selectedFiles.isNotEmpty) {
      filesController.updateProperty(
        selectedFiles,
        isArchived: const OrNull(false),
        errorBuilder: (fileIds) => _UnarchiveFailedError(fileIds.length),
      );
    }
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
    // _log.info(ev);
    emit(state.copyWith(scale: ev.scale));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  Future _transformItems(List<FileDescriptor> files) async {
    _log.info("[_transformItems] Queue ${files.length} items");
    _itemTransformerQueue.addJob(
      _ItemTransformerArgument(account: account, files: files),
      _buildItem,
      (result) {
        safeAdd(_OnItemTransformed(result.items));
      },
    );
  }

  void _clearSelection(Emitter<_State> emit) {
    emit(state.copyWith(selectedItems: const {}));
  }

  final Account account;
  final FilesController filesController;
  final PrefController prefController;

  final _itemTransformerQueue =
      ComputeQueue<_ItemTransformerArgument, _ItemTransformerResult>();
  final _subscriptions = <StreamSubscription>[];
  var _isHandlingError = false;
}

@toString
class _UnarchiveFailedError implements Exception {
  const _UnarchiveFailedError(this.count);

  @override
  String toString() => _$toString();

  final int count;
}

_ItemTransformerResult _buildItem(_ItemTransformerArgument arg) {
  final sortedFiles = arg.files
      .where((f) => f.fdIsArchived == true)
      .sorted(compareFileDescriptorDateTimeDescending);

  final transformed = <_Item>[];
  for (int i = 0; i < sortedFiles.length; ++i) {
    final file = sortedFiles[i];
    final item = _buildSingleItem(arg.account, file);
    if (item == null) {
      continue;
    }
    transformed.add(item);
  }
  return _ItemTransformerResult(items: transformed);
}

_Item? _buildSingleItem(Account account, FileDescriptor file) {
  if (file_util.isSupportedImageFormat(file)) {
    return _PhotoItem(file: file, account: account);
  } else if (file_util.isSupportedVideoFormat(file)) {
    return _VideoItem(file: file, account: account);
  } else {
    _$__NpLog.log.shout(
      "[_buildSingleItem] Unsupported file format: ${file.fdMime}",
    );
    return null;
  }
}
