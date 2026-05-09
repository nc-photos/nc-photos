part of 'changelog.dart';

class _Changelog880 extends StatelessWidget {
  const _Changelog880();

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

  _Changelog880Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog880StrJa();
    } else {
      return const _Changelog880Str();
    }
  }
}

class _Changelog880Str {
  const _Changelog880Str();

  String get sectionChange => "Changes";
  String get sectionChange1 => "Fixed abnormal cache handling for JXL files";
  String get sectionChange2 => "Optimized scroll performance in timeline";
  String get sectionChange3 => "Added support for Recognize on Nextcloud 33+";
}

class _Changelog880StrJa implements _Changelog880Str {
  const _Changelog880StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "JXL画像のキャッシュが意図せず削除される不具合を修正しました";
  @override
  String get sectionChange2 => "タイムラインのスクロール性能を改善しました";
  @override
  String get sectionChange3 => "Nextcloud 33以降でもRecognizeアプリとの連携に対応しました";
}
