part of 'changelog.dart';

class _Changelog580 extends StatelessWidget {
  const _Changelog580();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Themed icon on Android 13+ (contributed by fischer-felix)",
          ),
        ),
        _bulletGroup(const Text("Various bugfixes and UI improvements")),
        _sectionPadding(),
        _subSection("Localization"),
        _bulletGroup(const Text("Updated Czech (by Fjuro)")),
        _bulletGroup(const Text("Updated Portuguese (by fernosan)")),
        _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
      ],
    );
  }
}
