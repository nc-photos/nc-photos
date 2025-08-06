part of '../collection_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController})
    : super(
        _State(isBrowserShowDate: prefController.isAlbumBrowserShowDateValue),
      ) {
    on<_Init>(_onInit);
    on<_SetBrowserShowDate>(_onSetBrowserShowDate);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    return forEach(
      emit,
      prefController.isAlbumBrowserShowDateChange,
      onData: (data) => state.copyWith(isBrowserShowDate: data),
      onError: (e, stackTrace) {
        _log.severe("[_onInit] Uncaught exception", e, stackTrace);
        return state.copyWith(error: ExceptionEvent(e, stackTrace));
      },
    );
  }

  void _onSetBrowserShowDate(_SetBrowserShowDate ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setAlbumBrowserShowDate(ev.value);
  }

  final PrefController prefController;
}
