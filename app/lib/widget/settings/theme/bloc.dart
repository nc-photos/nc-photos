part of '../theme_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.prefController})
    : super(
        _State(
          isFollowSystemTheme: prefController.isFollowSystemThemeValue,
          isUseBlackInDarkTheme: prefController.isUseBlackInDarkThemeValue,
          seedColor: prefController.seedColorValue?.value,
          secondarySeedColor: prefController.secondarySeedColorValue?.value,
        ),
      ) {
    on<_Init>(_onInit);
    on<_SetFollowSystemTheme>(_onSetFollowSystemTheme);
    on<_SetUseBlackInDarkTheme>(_onSetUseBlackInDarkTheme);
    on<_SetThemeColor>(_onSetThemeColor);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      forEach(
        emit,
        prefController.isFollowSystemThemeChange,
        onData: (data) => state.copyWith(isFollowSystemTheme: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        prefController.isUseBlackInDarkThemeChange,
        onData: (data) => state.copyWith(isUseBlackInDarkTheme: data),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        prefController.seedColorChange,
        onData: (data) => state.copyWith(seedColor: data?.value),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
      forEach(
        emit,
        prefController.secondarySeedColorChange,
        onData: (data) => state.copyWith(secondarySeedColor: data?.value),
        onError: (e, stackTrace) {
          _log.severe("[_onInit] Uncaught exception", e, stackTrace);
          return state.copyWith(error: ExceptionEvent(e, stackTrace));
        },
      ),
    ]);
  }

  void _onSetFollowSystemTheme(_SetFollowSystemTheme ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setFollowSystemTheme(ev.value);
  }

  void _onSetUseBlackInDarkTheme(
    _SetUseBlackInDarkTheme ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    prefController.setUseBlackInDarkTheme(ev.value);
  }

  void _onSetThemeColor(_SetThemeColor ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController
      ..setSeedColor(ev.primary)
      ..setSecondarySeedColor(ev.secondary);
  }

  final PrefController prefController;
}
