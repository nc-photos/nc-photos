part of 'changelog.dart';

class _Changelog900 extends StatelessWidget {
  const _Changelog900();

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

  _Changelog900Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog900StrJa();
    } else {
      return const _Changelog900Str();
    }
  }
}

class _Changelog900Str {
  const _Changelog900Str();

  String get sectionChange => "Changes";
  String get sectionChange1 =>
      "Added support for editing metadata in WebP files";
  String get sectionChange2 => "Can now edit GPS metadata in supported files";
  String get sectionChange3 =>
      "Fixed a bug that prevented the face detector in the image editor from working correctly for some photos";
}

class _Changelog900StrJa implements _Changelog900Str {
  const _Changelog900StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "WebP画像のメタデータの編集できるようになりました";
  @override
  String get sectionChange2 => "対応ファイルの位置情報を編集できるようになりました";
  @override
  String get sectionChange3 => "写真を編集するときの顔検出機能が一部の写真で正しく動作しない不具合を修正しました";
}
