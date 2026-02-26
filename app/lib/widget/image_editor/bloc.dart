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
    on<_SetColorFilters>(_onSetColorFilters);
    on<_SetTransformFilters>(_onSetTransformFilters);
    on<_SetCropFilter>(_onSetCropFilter);
    on<_SetDst>(_onSetDst);
    on<_Save>(_onSave);
    on<_RequestQuit>(_onRequestQuit);

    on<_SetError>(_onSetError);

    add(const _InitSrc());
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

  void _onSetColorFilters(_SetColorFilters ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(colorFilters: ev.value));
    _applyFilters();
  }

  void _onSetTransformFilters(_SetTransformFilters ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(transformFilters: ev.value));
    _applyFilters();
  }

  void _onSetCropFilter(_SetCropFilter ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(cropFilter: ev.value));
    _applyFilters();
  }

  void _onSetDst(_SetDst ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(dst: ev.value));
  }

  Future<void> _onSave(_Save ev, _Emitter emit) async {
    try {
      final uriGetter = AnyFileContentGetterFactory.uri(file, account: account);
      await ImageProcessor.filter(
        await uriGetter.get(),
        file.name,
        4096,
        3072,
        [
          if (state.cropFilter != null) state.cropFilter!.toImageFilter()!,
          ...state.transformFilters.map((f) => f.toImageFilter()).nonNulls,
          ...state.colorFilters.map((f) => f.toImageFilter()),
        ],
        headers: {
          "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
        },
        isSaveToServer: prefController.isSaveEditResultToServerValue,
      );
    } catch (e, stackTrace) {
      _log.severe("Failed while filter", e, stackTrace);
      add(_SetError(e, stackTrace));
    }
    emit(state.copyWith(isSaved: true));
  }

  Future<void> _onRequestQuit(_RequestQuit ev, _Emitter emit) async {
    _log.info(ev);
    emit(state.copyWith(quitRequest: Unique(null)));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  Future<void> _applyFilters() async {
    if (state.src == null) {
      return;
    }
    var result = state.src!;
    final legacy = [
      if (state.cropFilter != null) state.cropFilter!.toImageFilter()!,
      ...state.transformFilters.map((f) => f.toImageFilter()).nonNulls,
    ];
    if (legacy.isNotEmpty) {
      result = await ImageProcessor.filterPreview(result, legacy);
    }
    final edits = _buildEditList();
    if (edits.isNotEmpty) {
      result = await image_editor.edit(result, edits);
    }
    add(_SetDst(result));
  }

  List<image_editor.Edit> _buildEditList() {
    return [...state.colorFilters.map((f) => f.toEdit())];
  }

  final Account account;
  final PrefController prefController;
  final AnyFile file;

  var _isHandlingError = false;

  static final _log = Logger("ImageEditorBloc");

  static const _previewWidth = 640;
  static const _previewHeight = 480;
}
