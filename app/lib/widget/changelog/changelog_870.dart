part of 'changelog.dart';

class _Changelog870 extends StatelessWidget {
  const _Changelog870();

  @override
  Widget build(BuildContext context) {
    final s = _str(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSectionHighlight(s.sectionImportant),
        _bulletGroup(Text(s.sectionImportant1)),
        _subSection(s.sectionChange),
        _bulletGroup(Text(s.sectionChange1)),
        _bulletGroup(Text(s.sectionChange2)),
      ],
    );
  }

  _Changelog870Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog870StrJa();
    } else {
      return const _Changelog870Str();
    }
  }
}

class _Changelog870Str {
  const _Changelog870Str();

  String get sectionChange => "Changes";
  String get sectionChange1 => "Fixed DST handling in the timeline";
  String get sectionChange2 =>
      "Fixed a sync issue when using the alternative HTTP engine";

  String get sectionImportant => "Important";
  String get sectionImportant1 => "Android 6.0 is no longer supported";
}

class _Changelog870StrJa implements _Changelog870Str {
  const _Changelog870StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "タイムラインでの夏時間処理の不具合を修正しました";
  @override
  String get sectionChange2 => "新しいHTTPエンジン使用時のデータ同期の不具合を修正しました";

  @override
  String get sectionImportant => "重要";
  @override
  String get sectionImportant1 => "Android 6.0のサポートを終了しました";
}
