part of 'changelog.dart';

class _Changelog931 extends StatelessWidget {
  const _Changelog931();

  @override
  Widget build(BuildContext context) {
    final s = _str(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection(s.sectionChange),
        _bulletGroup(Text(s.sectionChange1)),
        _subSection(s.sectionContributor),
        _bulletGroup(Text("${s.sectionContributor1} \u{1f44f}"), [
          const Text("David"),
        ]),
      ],
    );
  }

  _Changelog931Str _str(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return const _Changelog931StrJa();
    } else {
      return const _Changelog931Str();
    }
  }
}

class _Changelog931Str {
  const _Changelog931Str();

  String get sectionChange => "Changes";
  String get sectionChange1 => "Updated French translations";

  String get sectionContributor => "Contributors";
  String get sectionContributor1 =>
      "Special thanks to the following contributors";
}

class _Changelog931StrJa implements _Changelog931Str {
  const _Changelog931StrJa();

  @override
  String get sectionChange => "主な更新内容";
  @override
  String get sectionChange1 => "Frenchのローカライズを更新しました";

  @override
  String get sectionContributor => "貢献者";
  @override
  String get sectionContributor1 =>
      "このバージョンは下記の貢献者の皆さまのご協力により、無事リリースできました。ありがとうございました";
}
