part of '../my_app.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.prefController,
  }) : super(_State(
          language: prefController.languageValue,
          isDarkTheme: prefController.isDarkThemeValue,
          isFollowSystemTheme: prefController.isFollowSystemThemeValue,
          isUseBlackInDarkTheme: prefController.isUseBlackInDarkThemeValue,
          seedColor: prefController.seedColorValue?.value,
          secondarySeedColor: prefController.secondarySeedColorValue?.value,
        )) {
    on<_Init>(_onInit);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      emit.forEachIgnoreError<language_util.AppLanguage>(
        prefController.languageChange,
        onData: (data) => state.copyWith(language: data),
      ),
      emit.forEachIgnoreError<bool>(
        prefController.isDarkThemeChange,
        onData: (data) => state.copyWith(isDarkTheme: data),
      ),
      emit.forEachIgnoreError<bool>(
        prefController.isFollowSystemThemeChange,
        onData: (data) => state.copyWith(isFollowSystemTheme: data),
      ),
      emit.forEachIgnoreError<bool>(
        prefController.isUseBlackInDarkThemeChange,
        onData: (data) => state.copyWith(isUseBlackInDarkTheme: data),
      ),
      emit.forEachIgnoreError<ColorInt?>(
        prefController.seedColorChange,
        onData: (data) => state.copyWith(seedColor: data?.value),
      ),
      emit.forEachIgnoreError<ColorInt?>(
        prefController.secondarySeedColorChange,
        onData: (data) => state.copyWith(secondarySeedColor: data?.value),
      ),
    ]);
  }

  final PrefController prefController;
}
