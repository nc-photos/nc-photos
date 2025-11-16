part of 'changelog.dart';

class _Changelog690 extends StatelessWidget {
  const _Changelog690();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Fixed removing photos from server side album would instead delete it",
          ),
        ),
        _bulletGroup(const Text("Improved OSM map UI/UX")),
        _bulletGroup(
          const Text(
            "Fixed Pixel live photos taken with JPG+RAW not playing properly",
          ),
        ),
        _bulletGroup(const Text("Updated Czech, German, Spanish, Turkish")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [
            const Text("Ali Yasin Yeşilyaprak"),
            const Text("Fjuro"),
            const Text("luckkmaxx"),
            const Text("Niclas Heinz"),
          ],
        ),
      ],
    );
  }
}
