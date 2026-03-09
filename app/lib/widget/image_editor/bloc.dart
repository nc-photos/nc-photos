part of 'image_editor.dart';

class _IeBloc extends Bloc<_Event, _State> with BlocLogger {
  _IeBloc({
    required this.account,
    required this.prefController,
    required this.file,
  }) : super(_State.init()) {
    on<_InitSrc>(_onInitSrc);
    on<_SetActiveTool>(_onSetActiveTool);
    on<_SetCropMode>(_onSetCropMode);
    on<_SetPixelFilters>(_onSetPixelFilters);
    on<_SetTransformFilters>(_onSetTransformFilters);
    on<_SetCropFilter>(_onSetCropFilter);
    on<_SetDst>(_onSetDst);
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
    // no need to set shouldfixOrientation because the previews are always in
    // the correct orientation
    final src = await ImageLoader.loadUri(
      await uriGetter.get(),
      _previewWidth,
      _previewHeight,
      ImageLoaderResizeMethod.fit,
      isAllowSwapSide: true,
    );
    emit(state.copyWith(src: src));
  }

  void _onSetActiveTool(_SetActiveTool ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(activeTool: ev.value, isCropMode: false));
  }

  void _onSetCropMode(_SetCropMode ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(isCropMode: ev.value));
  }

  void _onSetPixelFilters(_SetPixelFilters ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(pixelFilters: ev.value));
    _updatePreview();
  }

  void _onSetTransformFilters(_SetTransformFilters ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(transformFilters: ev.value));
    _updatePreview();
  }

  void _onSetCropFilter(_SetCropFilter ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(cropFilter: ev.value));
    _updatePreview();
  }

  void _onSetDst(_SetDst ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(dst: ev.value));
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
      final (:dir, file: jpegFile) = await _createTempFile();
      try {
        await _processFullBitmapToJpeg(
          bitmap,
          srcBytes: bytes,
          dstJpegPath: jpegFile.path,
          pixelFilters: state.pixelFilters,
          transformFilters: state.transformFilters,
          cropFilter: state.cropFilter,
        );
        // save to public dir
        if (prefController.isSaveEditResultToServerValue) {
          // TODO save to server
        } else {
          await LocalMedia.copyPrivateFileToPublicDir(
            jpegFile.path,
            srcMime: "image/jpeg",
            dstDir: "Photos (for Nextcloud)/Edited Photos",
          );
        }
      } finally {
        await dir.delete(recursive: true);
      }

      emit(state.copyWith(isSaved: true));
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
    final result = await _applyFilters(
      state.src!,
      pixelFilters: state.pixelFilters,
      transformFilters: state.transformFilters,
      cropFilter: state.cropFilter,
    );
    add(_SetDst(result));
  }

  static Future<Rgba8Image> _applyFilters(
    Rgba8Image src, {
    required List<PixelArguments> pixelFilters,
    required List<TransformArguments> transformFilters,
    required TransformArguments? cropFilter,
  }) async {
    final edits =
        [
          cropFilter?.toEdit(),
          ...transformFilters.map((f) => f.toEdit()),
          ...pixelFilters.map((f) => f.toEdit()),
        ].nonNulls.toList();
    if (edits.isNotEmpty) {
      return await image_editor.edit(src, edits);
    } else {
      return src;
    }
  }

  static Future<void> _processFullBitmapToJpeg(
    Rgba8Image src, {
    required Uint8List srcBytes,
    required String dstJpegPath,
    required List<PixelArguments> pixelFilters,
    required List<TransformArguments> transformFilters,
    required TransformArguments? cropFilter,
  }) async {
    await Isolate.run(() async {
      final result = await _applyFilters(
        src,
        pixelFilters: pixelFilters,
        transformFilters: transformFilters,
        cropFilter: cropFilter,
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
      if (!await exiv2.copyMetadata(srcBytes, io.File(dstJpegPath))) {
        throw StateError("Unable to copy metadata to JPEG");
      }
    });
  }

  Future<io.Directory> _openTempDir() async {
    final root = await getTemporaryDirectory();
    final dir = io.Directory("${root.path}/image_editor");
    if (!await dir.exists()) {
      return dir.create();
    } else {
      return dir;
    }
  }

  Future<({io.Directory dir, io.File file})> _createTempFile() async {
    final dstDir = await _openTempDir();
    while (true) {
      final dirName = const Uuid().v4();
      final dir = io.Directory("${dstDir.path}/$dirName");
      if (await io.FileSystemEntity.type(dir.path) !=
          io.FileSystemEntityType.notFound) {
        continue;
      }
      await dir.create();
      return (
        dir: dir,
        file: io.File(
          "${dir.path}/${pathlib.basenameWithoutExtension(file.name)}.jpg",
        ),
      );
    }
  }

  final Account account;
  final PrefController prefController;
  final AnyFile file;

  var _isHandlingError = false;

  static final _log = Logger("ImageEditorBloc");

  static const _previewWidth = 1280;
  static const _previewHeight = 1280;
}
