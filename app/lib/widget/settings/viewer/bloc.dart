part of '../viewer_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController})
    : super(
        _State(
          screenBrightness: prefController.viewerScreenBrightnessValue,
          isForceRotation: prefController.isViewerForceRotationValue,
          gpsMapProvider: prefController.gpsMapProviderValue,
        ),
      ) {
    on<_Init>(_onInit);
    on<_SetScreenBrightness>(_onSetScreenBrightness);
    on<_SetForceRotation>(_onSetForceRotation);
    on<_SetGpsMapProvider>(_onSetGpsMapProvider);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        prefController.viewerScreenBrightnessChange,
        onData: (data) => state.copyWith(screenBrightness: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        prefController.isViewerForceRotationChange,
        onData: (data) => state.copyWith(isForceRotation: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        prefController.gpsMapProviderChange,
        onData: (data) => state.copyWith(gpsMapProvider: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
    ]);
  }

  void _onSetScreenBrightness(_SetScreenBrightness ev, Emitter<_State> emit) {
    _log.info(ev);
    if (ev.value < 0) {
      prefController.setViewerScreenBrightness(-1);
    } else {
      prefController.setViewerScreenBrightness((ev.value * 100).round());
    }
  }

  void _onSetForceRotation(_SetForceRotation ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setViewerForceRotation(ev.value);
  }

  void _onSetGpsMapProvider(_SetGpsMapProvider ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setGpsMapProvider(ev.value);
  }

  final PrefController prefController;
}
