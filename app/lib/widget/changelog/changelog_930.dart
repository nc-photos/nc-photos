part of 'changelog.dart';

class _Changelog930 extends StatelessWidget {
  const _Changelog930();

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
      ],
    );
  }

  _Changelog930Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog930StrJa();
    } else {
      return const _Changelog930Str();
    }
  }
}

class _Changelog930Str {
  const _Changelog930Str();

  String get sectionChange => "Changes";
  String get sectionChange1 =>
      "Fixed a compatibility issue causing the app to crash on Android 14";
  String get sectionChange2 => "Improved selection UX in the timeline";
}

class _Changelog930StrJa implements _Changelog930Str {
  const _Changelog930StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "Android 14との互換性のバグによるクラッシュを修正しました";
  @override
  String get sectionChange2 => "タイムラインなどでのアイテム選択の操作性を改善しました";
}
