part of 'my_app.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.language,
    required this.isDarkTheme,
    required this.isFollowSystemTheme,
    required this.isUseBlackInDarkTheme,
    required this.seedColor,
    required this.secondarySeedColor,
  });

  @override
  String toString() => _$toString();

  final language_util.AppLanguage language;
  final bool isDarkTheme;
  final bool isFollowSystemTheme;
  final bool isUseBlackInDarkTheme;
  final int? seedColor;
  final int? secondarySeedColor;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}
