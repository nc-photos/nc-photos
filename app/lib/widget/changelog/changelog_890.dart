part of 'changelog.dart';

class _Changelog890 extends StatelessWidget {
  const _Changelog890();

  @override
  Widget build(BuildContext context) {
    final s = _str(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection(s.sectionChange),
        _bulletGroup(Text(s.sectionChange1)),
      ],
    );
  }

  _Changelog890Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog890StrJa();
    } else {
      return const _Changelog890Str();
    }
  }
}

class _Changelog890Str {
  const _Changelog890Str();

  String get sectionChange => "Changes";
  String get sectionChange1 =>
      "Can now edit EXIF date, time and timezone data for JPEG files";
}

class _Changelog890StrJa implements _Changelog890Str {
  const _Changelog890StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "JPEG画像の撮影日時やタイムゾーンを編集できるようになりました";
}
