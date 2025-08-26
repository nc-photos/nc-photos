part of '../misc_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController, required this.securePrefController})
    : super(
        _State(
          isDoubleTapExit: prefController.isDoubleTapExitValue,
          appLockType: securePrefController.protectedPageAuthTypeValue,
        ),
      ) {
    on<_Init>(_onInit);
    on<_SetDoubleTapExit>(_onSetDoubleTapExit);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        prefController.isDoubleTapExitChange,
        onData: (data) => state.copyWith(isDoubleTapExit: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        securePrefController.protectedPageAuthTypeChange,
        onData: (data) => state.copyWith(appLockType: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
    ]);
  }

  void _onSetDoubleTapExit(_SetDoubleTapExit ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setDoubleTapExit(ev.value);
  }

  final PrefController prefController;
  final SecurePrefController securePrefController;
}
