part of 'changelog.dart';

class _Changelog770 extends StatelessWidget {
  const _Changelog770();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Added local files support (Android 11+)"), [
          const Text(
            "Media files on your device will now appear in the photos timeline",
          ),
          const Text(
            "Control which folders to be included in Settings > Photos > Show device media",
          ),
        ]),
        _bulletGroup(const Text("Fixed low refresh rate on some devices")),
        _bulletGroup(const Text("Updated Turkish")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [const Text("Ali Yasin Yeşilyaprak")],
        ),
      ],
    );
  }
}
