part of 'changelog.dart';

class _Changelog590 extends StatelessWidget {
  const _Changelog590();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Now support Nextcloud 25 album"), [
          const Text(
            "Collaborative album is NOT yet supported. It will be added in future updates",
          ),
        ]),
        _bulletGroup(
          const Text(
            "Collections code were largely rewritten. If you encountered any bugs, please report them via Settings > Report issue",
          ),
        ),
        _sectionPadding(),
        _subSection("Localization"),
        _bulletGroup(const Text("Updated Finnish (by pHamala)")),
      ],
    );
  }
}
