part of 'image_editor.dart';

class _IeBloc extends Bloc<_Event, _State> with BlocLogger {
  _IeBloc({
    required this.account,
    required this.fileRepo,
    required this.prefController,
    required this.file,
  }) : super(_State.init()) {
    on<_InitSrc>(_onInitSrc);
    on<_SetActiveTool>(_onSetActiveTool);
    on<_SetFaceSelectionMode>(_onSetFaceSelectionMode);
    on<_SetFaceSelectorImageSize>(_onSetFaceSelectorImageSize);
    on<_SetPixelFilters>(_onSetPixelFilters);
    on<_SetTransformFilters>(_onSetTransformFilters);
    on<_UpdateTransformFilter>(_onUpdateTransformFilter);
    on<_SetActiveTransformTool>(_onSetActiveTransformTool);
    on<_SetTransformPreviewSrc>(_onSetTransformPreviewSrc);
    on<_SetFaceLandmarks>(_onSetFaceLandmarks);
    on<_ToggleFaceSelection>(_onToggleFaceSelection);
    on<_FaceFilterValueChanged>(_onFaceFilterValueChanged);

    // markup
    on<_AddBrushStroke>(_onAddBrushStroke);
    on<_ClearBrushStrokes>(_onClearBrushStrokes);
    on<_UndoBrushStroke>(_onUndoBrushStroke);
    on<_SetBrushColor>(_onSetBrushColor);
    on<_SetBrushRadius>(_onSetBrushRadius);
    on<_SetAppliedStrokeIds>(_onSetAppliedStrokeIds);

    on<_SetDst>(_onSetDst);
    on<_SetIsApplyingFilters>((ev, emit) {
      _log.info(ev);
      emit(state.copyWith(isApplyingFilters: ev.value));
    });
    on<_Save>(_onSave);
    on<_RequestQuit>(_onRequestQuit);

    on<_SetError>(_onSetError);
    on<_SetSaveError>(_onSetSaveError);

    add(const _InitSrc());
  }

  @override
  String get tag => _log.fullName;

  @override
  bool Function(dynamic, dynamic)? get shouldLog => (currentState, nextState) {
    currentState = currentState as _State;
    nextState = nextState as _State;
    return currentState.downloadProgress == nextState.downloadProgress;
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

  Future<void> _onInitSrc(_InitSrc event, _Emitter emit) async {
    final uriGetter = AnyFileContentGetterFactory.largePreviewuri(
      file,
      account: account,
    );
    try {
      final src = await ImageLoader.loadUri(
        await uriGetter.get(),
        _previewWidth,
        _previewHeight,
        ImageLoaderResizeMethod.fit,
        isAllowSwapSide: true,
        shouldFixOrientation: true,
      );
      emit(state.copyWith(src: src));
    } on FileNotFoundException catch (e, stackTrace) {
      _log.severe("[_onInitSrc] Failed while loadUri", e, stackTrace);
      emit(
        state.copyWith(initError: const ExceptionEvent(io.SocketException(""))),
      );
    } catch (e, stackTrace) {
      _log.severe("[_onInitSrc] Failed while loadUri", e, stackTrace);
      emit(state.copyWith(initError: ExceptionEvent(e, stackTrace)));
    }
  }

  void _onSetActiveTool(_SetActiveTool ev, _Emitter emit) {
    _log.info(ev);
    ++_transformPreviewToken;
    emit(
      state.copyWith(
        activeTool: ev.value,
        activeTransformTool: null,
        transformPreviewSrc: null,
        isFaceSelectionMode: false,
      ),
    );
  }

  void _onSetFaceSelectionMode(_SetFaceSelectionMode ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isFaceSelectionMode: ev.value));
  }

  void _onSetFaceSelectorImageSize(
    _SetFaceSelectorImageSize ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    emit(state.copyWith(faceSelectorImageSize: ev.value));
  }

  void _onSetPixelFilters(_SetPixelFilters ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(pixelFilters: ev.value));
    _updatePreview();
  }

  void _onSetTransformFilters(_SetTransformFilters ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        transformFilters: ev.value,
        markupFilter: state.markupFilter.copyWith(
          strokes: _remapStrokesForCrop(
            state.markupFilter.strokes,
            oldCropFilter: _cropFilterOf(state.transformFilters),
            newCropFilter: _cropFilterOf(ev.value),
          ),
        ),
        // modifying transformation filters resets face detection
        faceLandmarks: null,
        selectedFaces: const [],
        hasSelectedFaceReset: state.selectedFaces.isNotEmpty
            ? Unique(true)
            : null,
      ),
    );
    _updatePreview();
  }

  void _onUpdateTransformFilter(_UpdateTransformFilter ev, _Emitter emit) {
    _log.info(ev);
    final type = ev.value.getToolType();
    final next = state.transformFilters.toList();
    final idx = next.indexWhere((f) => f.getToolType() == type);
    if (idx == -1) {
      next.add(ev.value);
    } else {
      next[idx] = ev.value;
    }
    add(_SetTransformFilters(next));
  }

  void _onSetActiveTransformTool(_SetActiveTransformTool ev, _Emitter emit) {
    _log.info(ev);
    final token = ++_transformPreviewToken;
    emit(
      state.copyWith(activeTransformTool: ev.value, transformPreviewSrc: null),
    );
    if (ev.value != null) {
      _updateTransformPreview(ev.value!, token);
    }
  }

  void _onSetTransformPreviewSrc(_SetTransformPreviewSrc ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(transformPreviewSrc: ev.value));
  }

  void _onSetFaceLandmarks(_SetFaceLandmarks ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        postTransformSrc: ev.postTransformSrc,
        faceLandmarks: ev.landmarks,
        selectedFaces: const [],
      ),
    );
  }

  void _onToggleFaceSelection(_ToggleFaceSelection ev, _Emitter emit) {
    _log.info(ev);
    final next = List.of(state.selectedFaces);
    if (next.contains(ev.value)) {
      next.remove(ev.value);
    } else {
      next.add(ev.value);
    }
    emit(state.copyWith(selectedFaces: next));
    _updatePreview();
  }

  void _onFaceFilterValueChanged(_FaceFilterValueChanged ev, _Emitter emit) {
    _log.info(ev);
    if (state.faceLandmarks?.isNotEmpty == true &&
        state.selectedFaces.isEmpty) {
      emit(state.copyWith(shouldNotifySelectFace: true));
    }
  }

  void _onAddBrushStroke(_AddBrushStroke ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        markupFilter: state.markupFilter.copyWith(
          strokes: [
            ...state.markupFilter.strokes,
            BrushStroke(
              id: _brushStrokeToken++,
              points: ev.value,
              radius: state.markupFilter.radius,
              color: state.markupFilter.color,
            ),
          ],
        ),
      ),
    );
    _updatePreview();
  }

  void _onClearBrushStrokes(_ClearBrushStrokes ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        markupFilter: state.markupFilter.copyWith(strokes: const []),
      ),
    );
    _updatePreview();
  }

  void _onUndoBrushStroke(_UndoBrushStroke ev, _Emitter emit) {
    _log.info(ev);
    if (state.markupFilter.strokes.isEmpty) {
      return;
    }
    emit(
      state.copyWith(
        markupFilter: state.markupFilter.copyWith(
          strokes: state.markupFilter.strokes.removedLast(),
        ),
      ),
    );
    _updatePreview();
  }

  void _onSetBrushColor(_SetBrushColor ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        markupFilter: state.markupFilter.copyWith(color: ev.value),
      ),
    );
    _updatePreview();
  }

  void _onSetBrushRadius(_SetBrushRadius ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        markupFilter: state.markupFilter.copyWith(radius: ev.value),
      ),
    );
    _updatePreview();
  }

  void _onSetDst(_SetDst ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(dst: ev.value));
    // prevent the stroke blink
    WidgetsBinding.instance.addPostFrameCallback((_) {
      add(_SetAppliedStrokeIds(ev.appliedStrokeIds));
    });
  }

  void _onSetAppliedStrokeIds(_SetAppliedStrokeIds ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(appliedStrokeIds: ev.value));
  }

  Future<void> _onSave(_Save ev, _Emitter emit) async {
    emit(state.copyWith(saveState: _SaveState.init, downloadProgress: 0));
    try {
      // download
      final bitmapGetter = AnyFileContentGetterFactory.binaryBitmap(
        file,
        account: account,
      );
      final (:bytes, :bitmap) = await bitmapGetter.get(
        maxWidth: 4096,
        maxHeight: 3072,
        shouldFixOrientation: true,
        onProgress: (progress) {
          emit(
            state.copyWith(
              saveState: _SaveState.download,
              downloadProgress: progress,
            ),
          );
        },
      );

      // do the edits
      emit(state.copyWith(saveState: _SaveState.process));
      const tempFileManager = TempFileManager("image_editor");
      final (:dir, file: jpegFile) = await tempFileManager.createNamedFile(
        pathlib.basenameWithoutExtension(file.name),
        extension: "jpg",
      );
      try {
        final pixelFilters = await _preparePixelFilters();
        await _processFullBitmapToJpeg(
          bitmap,
          srcBytes: bytes,
          dstJpegPath: jpegFile.path,
          pixelFilters: pixelFilters,
          transformFilters: state.transformFilters,
          markupFilter: state.markupFilter,
        );
        emit(state.copyWith(saveState: _SaveState.save));
        await _persistResult(jpegFile);
        emit(state.copyWith(savedFile: jpegFile));
      } catch (e) {
        await dir.delete(recursive: true);
        rethrow;
      }
    } catch (e, stackTrace) {
      _log.severe("Failed while filter", e, stackTrace);
      add(_SetSaveError(e, stackTrace));
    } finally {
      emit(state.copyWith(saveState: null, downloadProgress: 0));
    }
  }

  Future<void> _onRequestQuit(_RequestQuit ev, _Emitter emit) async {
    _log.info(ev);
    emit(state.copyWith(quitRequest: Unique(null)));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  void _onSetSaveError(_SetSaveError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(saveError: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  Future<void> _updatePreview() async {
    if (state.src == null) {
      return;
    }
    final token = await _getProcessorToken();
    await _processorMutex.protect(() async {
      if (token != _processorToken) {
        // outdated
        return;
      }
      add(const _SetIsApplyingFilters(true));
      try {
        final pixelFilters = await _preparePixelFilters();
        final markupFilter = state.markupFilter;
        final result = await _applyFilters(
          state.src!,
          pixelFilters: pixelFilters,
          transformFilters: state.transformFilters,
          markupFilter: markupFilter,
        );
        add(_SetDst(result, markupFilter.strokes.map((s) => s.id).toSet()));
      } finally {
        add(const _SetIsApplyingFilters(false));
      }
    });
  }

  Future<void> _updateTransformPreview(
    TransformToolType tool,
    int token,
  ) async {
    if (state.src == null) {
      return;
    }
    final pos = state.transformFilters.indexWhere(
      (e) => e.getToolType() == tool,
    );
    // only apply filters before this one
    final filters = pos == -1
        ? state.transformFilters
        : state.transformFilters.sublist(0, pos);
    final result = filters.isEmpty
        ? state.src!
        : await _applyFilters(
            state.src!,
            pixelFilters: const [],
            transformFilters: filters,
            markupFilter: null,
          );
    if (isClosed || token != _transformPreviewToken) {
      return;
    }
    add(_SetTransformPreviewSrc(result));
  }

  Future<List<image_editor.Edit>> _preparePixelFilters() async {
    if (state.pixelFilters.any((e) => e is PixelFaceArguments)) {
      var landmarks = state.faceLandmarks;
      if (landmarks == null) {
        var src = state.src!;
        var isTransofrmed = false;
        if (state.transformFilters.isNotEmpty) {
          // apply transformation filters as they will affect face detection
          src = await _applyFilters(
            src,
            pixelFilters: [],
            transformFilters: state.transformFilters,
            markupFilter: null,
          );
          isTransofrmed = true;
        }
        landmarks = await image_editor.FaceDetector().detect(src);
        add(
          _SetFaceLandmarks(
            postTransformSrc: isTransofrmed ? src : null,
            landmarks: landmarks,
          ),
        );
      }
      return state.pixelFilters.map((e) {
        if (e is PixelFaceArguments) {
          return e.toEdit()..setLandmarks(state.selectedFaces);
        } else {
          return e.toEdit();
        }
      }).toList();
    } else {
      return state.pixelFilters.map((e) => e.toEdit()).toList();
    }
  }

  static Future<Rgba8Image> _applyFilters(
    Rgba8Image src, {
    required List<image_editor.Edit> pixelFilters,
    required List<TransformArguments> transformFilters,
    required MarkupArguments? markupFilter,
    bool useIsolate = true,
  }) async {
    Future<Rgba8Image> _do() async {
      final edits = [
        ...transformFilters.map((f) => f.toEdit()),
        ...pixelFilters,
        markupFilter?.toEdit(),
      ].nonNulls.toList();
      if (edits.isNotEmpty) {
        return await image_editor.edit(src, edits);
      } else {
        return src;
      }
    }

    if (useIsolate) {
      return await Isolate.run(() => _do());
    } else {
      return await _do();
    }
  }

  static Future<void> _processFullBitmapToJpeg(
    Rgba8Image src, {
    required Uint8List srcBytes,
    required String dstJpegPath,
    required List<image_editor.Edit> pixelFilters,
    required List<TransformArguments> transformFilters,
    required MarkupArguments? markupFilter,
  }) async {
    await Isolate.run(() async {
      final result = await _applyFilters(
        src,
        pixelFilters: pixelFilters,
        transformFilters: transformFilters,
        markupFilter: markupFilter,
        // already in isolate
        useIsolate: false,
      );

      // jpeg encode and save to internal
      final isEncodeOk = await imagelib.encodeJpgFile(
        dstJpegPath,
        imagelib.Image.fromBytes(
          width: result.width,
          height: result.height,
          bytes: result.pixel.buffer,
          numChannels: 4,
          order: imagelib.ChannelOrder.rgba,
        ),
        quality: 85,
      );
      if (!isEncodeOk) {
        throw StateError("Unable to encode image to JPEG");
      }
      // don't copy orientation as it's applied to the src before processing
      if (!await exiv2.copyMetadata(
        srcBytes,
        io.File(dstJpegPath),
        shouldCopyOrientation: false,
        shouldCopyThumbnail: false,
      )) {
        throw StateError("Unable to copy metadata to JPEG");
      }
    });
  }

  Future<void> _persistResult(io.File jpegFile) async {
    final isRemoteFile = file.provider is AnyFileNextcloudProvider;
    if (isRemoteFile && prefController.isSaveEditResultToServerValue) {
      try {
        final remoteFile = (file.provider as AnyFileNextcloudProvider).file;
        final fileSuffix =
            "edited_${clock.now().millisecondsSinceEpoch / 1000}";
        final path =
            "${pathlib.dirname(remoteFile.fdPath)}/${pathlib.basenameWithoutExtension(remoteFile.fdPath)}_$fileSuffix.jpg";
        await PutFileBinary(
          fileRepo,
        ).call(account, path, await jpegFile.readAsBytes());
        return;
      } catch (e, stackTrace) {
        _log.severe(
          "[_persistResult] Failed while PutFileBinary",
          e,
          stackTrace,
        );
        // fallback to local
      }
    }
    await LocalMedia.copyPrivateFileToPublicDir(
      jpegFile.path,
      srcMime: "image/jpeg",
      dstDir: "Photos (for Nextcloud)/Edited Photos",
    );
  }

  Future<int> _getProcessorToken() async {
    return _processorTokenMutex.protect(() async {
      return ++_processorToken;
    });
  }

  static CropArguments? _cropFilterOf(List<TransformArguments> filters) =>
      filters.whereType<CropArguments>().firstOrNull;

  // Both radius and coords are normalized to the image size. Since crop would
  // change the image size, we need to remap them
  static List<BrushStroke> _remapStrokesForCrop(
    List<BrushStroke> strokes, {
    required CropArguments? oldCropFilter,
    required CropArguments? newCropFilter,
  }) {
    if (strokes.isEmpty) {
      return strokes;
    }
    final from =
        oldCropFilter?.let(
          (e) => Rect.fromLTRB(e.left, e.top, e.right, e.bottom),
        ) ??
        const Rect.fromLTRB(0, 0, 1, 1);
    final to =
        newCropFilter?.let(
          (e) => Rect.fromLTRB(e.left, e.top, e.right, e.bottom),
        ) ??
        const Rect.fromLTRB(0, 0, 1, 1);
    if (from == to) {
      return strokes;
    }
    final radiusScale = from.width / to.width;
    return strokes
        .map(
          (s) => BrushStroke(
            id: s.id,
            points: s.points
                .map((p) => _remapPointForCrop(p, from, to))
                .toList(),
            radius: s.radius * radiusScale,
            color: s.color,
          ),
        )
        .toList();
  }

  static Point<double> _remapPointForCrop(Point<double> p, Rect from, Rect to) {
    final srcX = from.left + p.x * from.width;
    final srcY = from.top + p.y * from.height;
    final newX = to.width == 0 ? 0.0 : (srcX - to.left) / to.width;
    final newY = to.height == 0 ? 0.0 : (srcY - to.top) / to.height;
    return Point(newX, newY);
  }

  final Account account;
  final FileRepo fileRepo;
  final PrefController prefController;
  final AnyFile file;

  var _processorToken = 0;
  final _processorTokenMutex = Mutex();
  final _processorMutex = Mutex();

  var _transformPreviewToken = 0;
  var _brushStrokeToken = 0;

  var _isHandlingError = false;

  static final _log = Logger("ImageEditorBloc");

  static const _previewWidth = 1024;
  static const _previewHeight = 1024;
}
