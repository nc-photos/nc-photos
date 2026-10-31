part of 'changelog.dart';

class _Changelog940 extends StatelessWidget {
  const _Changelog940();

  @override
  Widget build(BuildContext context) {
    final s = _str(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection(s.sectionChange),
        _bulletGroup(Text(s.sectionChange1)),
        _bulletGroup(Text(s.sectionChange2)),
        _bulletGroup(Text(s.sectionChange3)),
      ],
    );
  }

  _Changelog940Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog940StrJa();
    } else {
      return const _Changelog940Str();
    }
  }
}

class _Changelog940Str {
  const _Changelog940Str();

  String get sectionChange => "Changes";
  String get sectionChange1 => "Added a straighten tool to the image editor";
  String get sectionChange2 =>
      "Fixed a compatibility issue causing the app to crash on Android 9/10";
  String get sectionChange3 => "Various bug fixes and UI tweaks";
}

class _Changelog940StrJa implements _Changelog940Str {
  const _Changelog940StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "画像エディタに傾き補正ツールを追加しました";
  @override
  String get sectionChange2 => "Android 9および10における互換性の問題によるクラッシュを修正しました";
  @override
  String get sectionChange3 => "様々な不具合の修正やUIの調整を行いました";
}
