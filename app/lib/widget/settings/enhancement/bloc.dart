part of '../enhancement_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController})
    : super(
        _State(
          isSaveEditResultToServer:
              prefController.isSaveEditResultToServerValue,
          maxSize: prefController.enhanceMaxSizeValue,
        ),
      ) {
    on<_Init>(_onInit);
    on<_SetSaveEditResultToServer>(_onSetSaveEditResultToServer);
    on<_SetMaxSize>(_onSetMaxSize);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        prefController.isSaveEditResultToServerChange,
        onData: (data) => state.copyWith(isSaveEditResultToServer: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        prefController.enhanceMaxSizeChange,
        onData: (data) => state.copyWith(maxSize: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
    ]);
  }

  void _onSetSaveEditResultToServer(
    _SetSaveEditResultToServer ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    prefController.setSaveEditResultToServer(ev.value);
  }

  void _onSetMaxSize(_SetMaxSize ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setEnhanceMaxSize(ev.value);
  }

  final PrefController prefController;
}
