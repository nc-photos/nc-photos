part of '../language_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController})
    : super(_State.init(selected: prefController.languageValue)) {
    on<_Init>(_onInit);
    on<_SelectLanguage>(_onSelectLanguage);
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

  Future<void> _onInit(_Init ev, Emitter<_State> emit) {
    _log.info(ev);
    return forEach(
      emit,
      prefController.languageChange,
      onData: (data) => state.copyWith(selected: data),
      onError: (e, stackTrace) {
        _log.severe("[_onInit] Uncaught exception", e, stackTrace);
        return state.copyWith(error: ExceptionEvent(e, stackTrace));
      },
    );
  }

  void _onSelectLanguage(_SelectLanguage ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setAppLanguage(ev.lang);
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final PrefController prefController;

  var _isHandlingError = false;
}
