part of 'changelog.dart';

class _Changelog860 extends StatelessWidget {
  const _Changelog860();

  @override
  Widget build(BuildContext context) {
    final s = _str(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_subSection(s.section1), _bulletGroup(Text(s.section1P1))],
    );
  }

  _Changelog860Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog860StrJa();
    } else {
      return const _Changelog860Str();
    }
  }
}

class _Changelog860Str {
  const _Changelog860Str();

  String get section1 => "Changes";
  String get section1P1 =>
      "Updated city database, localized names will now be used if available";
}

class _Changelog860StrJa implements _Changelog860Str {
  const _Changelog860StrJa();

  @override
  String get section1 => "機能の更新";
  @override
  String get section1P1 => "世界都市データベースを更新しました。また、一部の都市名は日本語で表示されるようになりました";
}
