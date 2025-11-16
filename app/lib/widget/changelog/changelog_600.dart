part of 'changelog.dart';

class _Changelog600 extends StatelessWidget {
  const _Changelog600();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Now support faces provided by the Recognize app"),
          [const Text("You can switch between providers in Account settings")],
        ),
        _bulletGroup(const Text("Dynamic color theme support (Material You)"), [
          const Text("Please tap USER SYSTEM COLOR in the theme color dialog"),
        ]),
        _bulletGroup(
          const Text(
            "Replace the zoom slider with zoom/pinch gestures when browsing a collection",
          ),
        ),
        _bulletGroup(const Text("Fixed a visual glitch in image viewer")),
        _bulletGroup(const Text("Various UI tweaks and bug fixes")),
        _sectionPadding(),
        _subSection("Localization"),
        _bulletGroup(const Text("Added Dutch (by Micha)")),
        _bulletGroup(const Text("Added Italian (by Albe)")),
        _bulletGroup(const Text("Updated Finnish (by pHamala)")),
        _bulletGroup(const Text("Updated German (by Andreas and Sebastian)")),
        _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
      ],
    );
  }
}
