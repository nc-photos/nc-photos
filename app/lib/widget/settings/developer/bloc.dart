part of '../developer_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc(DiContainer c) : _c = c, super(const _State()) {
    on<_ClearImageCache>(_onClearImageCache);
    on<_VacuumDb>(_onVacuumDb);
    on<_ExportDb>(_onExportDb);
    on<_ClearCertWhitelist>(_onClearCertWhitelist);

    on<_SetError>(_onSetError);
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

  Future<void> _onClearImageCache(
    _ClearImageCache ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    await ThumbnailCacheManager.inst.emptyCache();
    await LargeImageCacheManager.inst.emptyCache();
    await CoverCacheManager.inst.emptyCache();
    await JxlCacheManager.inst.emptyCache();
    await JxlThumbnailCacheManager.inst.emptyCache();
    emit(state.copyWith(message: StateMessage("Finished successfully")));
  }

  Future<void> _onVacuumDb(_VacuumDb ev, Emitter<_State> emit) async {
    _log.info(ev);
    await _c.npDb.sqlVacuum();
    emit(state.copyWith(message: StateMessage("Finished successfully")));
  }

  Future<void> _onExportDb(_ExportDb ev, Emitter<_State> emit) async {
    _log.info(ev);
    await _c.npDb.export(await getApplicationDocumentsDirectory());
    emit(state.copyWith(message: StateMessage("Finished successfully")));
  }

  Future<void> _onClearCertWhitelist(
    _ClearCertWhitelist ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    await SelfSignedCertManager().clearWhitelist();
    emit(state.copyWith(message: StateMessage("Finished successfully")));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final DiContainer _c;

  var _isHandlingError = false;
}
