part of '../changelog.dart';

class _Changelog660 extends StatelessWidget {
  const _Changelog660();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSectionHighlight("CRITICAL"),
        _bulletGroup(const Text("Android 5.0 is no longer supported")),
        _bulletGroup(
          const Text(
            "Sort by name is no longer supported in the new photos timeline, please contact me if you wish to downgrade",
          ),
        ),
        _sectionPadding(),
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Drastically improve performance when dealing with large amount of photos",
          ),
        ),
        _bulletGroup(
          const Text(
            "Rewrite photos timeline and files handling from scratch for better performance",
          ),
        ),
        _bulletGroup(const Text("Support live photos taken with Google Pixel")),
        _bulletGroup(
          const Text("Now it's possible to set a secondary theme color"),
        ),
        _bulletGroup(const Text("App lock"), [
          const Text("Require extra authentication when opening app"),
          const Text(
            "WARNING: This is NOT a security feature, it will NOT make the app more secure against attackers",
          ),
        ]),
        _bulletGroup(const Text("Multiple bug fixes and UI tweaks")),
        _bulletGroup(
          const Text("Updated Chinese (Simplified), Czech, Turkish"),
        ),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [
            const Text("Ali Yasin Yeşilyaprak"),
            const Text("Fjuro"),
            const Text("tenJirka"),
            const Text("老兄"),
          ],
        ),
      ],
    );
  }
}
