// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_app.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    language_util.AppLanguage? language,
    bool? isDarkTheme,
    bool? isFollowSystemTheme,
    bool? isUseBlackInDarkTheme,
    int? seedColor,
    int? secondarySeedColor,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic language,
    dynamic isDarkTheme,
    dynamic isFollowSystemTheme,
    dynamic isUseBlackInDarkTheme,
    dynamic seedColor = copyWithNull,
    dynamic secondarySeedColor = copyWithNull,
  }) {
    return _State(
      language: language as language_util.AppLanguage? ?? that.language,
      isDarkTheme: isDarkTheme as bool? ?? that.isDarkTheme,
      isFollowSystemTheme:
          isFollowSystemTheme as bool? ?? that.isFollowSystemTheme,
      isUseBlackInDarkTheme:
          isUseBlackInDarkTheme as bool? ?? that.isUseBlackInDarkTheme,
      seedColor: seedColor == copyWithNull ? that.seedColor : seedColor as int?,
      secondarySeedColor:
          secondarySeedColor == copyWithNull
              ? that.secondarySeedColor
              : secondarySeedColor as int?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_WrappedAppStateNpLog on _WrappedAppState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.my_app._WrappedAppState");
}

extension _$_AppLockMyAppStateNpLog on _AppLockMyAppState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.my_app._AppLockMyAppState");
}

extension _$_AppLockOverlayPageStateNpLog on _AppLockOverlayPageState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.my_app._AppLockOverlayPageState");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.my_app._Bloc");
}

extension _$_NavigatorLoggerNpLog on _NavigatorLogger {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.my_app._NavigatorLogger");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {language: $language, isDarkTheme: $isDarkTheme, isFollowSystemTheme: $isFollowSystemTheme, isUseBlackInDarkTheme: $isUseBlackInDarkTheme, seedColor: $seedColor, secondarySeedColor: $secondarySeedColor}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}
