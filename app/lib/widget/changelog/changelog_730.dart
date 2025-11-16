part of 'changelog.dart';

class _Changelog730 extends StatelessWidget {
  const _Changelog730();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Improve scrolling performance in Photos tab")),
        _bulletGroup(
          const Text(
            "Option to enable client side EXIF fallback for files not processed by server",
          ),
          [const Text("Settings > File metadata")],
        ),
        _bulletGroup(
          const Text("Added Slovak, updated French, German, Spanish, Turkish"),
        ),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [
            const Text("Ali Yasin Yeşilyaprak"),
            const Text("Choukajohn"),
            const Text("luckkmaxx"),
            const Text("MrNobody"),
            const Text("Števob"),
          ],
        ),
      ],
    );
  }
}
