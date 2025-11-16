part of 'changelog.dart';

class _Changelog550 extends StatelessWidget {
  const _Changelog550();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Reworked app theme for Material 3"), [
          const Text("You can now customize the app color in Settings > Theme"),
        ]),
        _bulletGroup(
          const Text("Optimized startup performance with large libraries"),
          [
            const Text("Completely reworked how the app handles file data"),
            const Text(
              "Loading a large library should take less time, especially on devices with slower storage I/O",
            ),
          ],
        ),
        _bulletGroup(
          const Text("Migrated to Nextcloud login flow (by @steffenmalisi)"),
          [const Text("Great thanks to @steffenmalisi!")],
        ),
        _bulletGroup(const Text("Lots of bug fixes, notably,"), [
          const Text("Unresponsive video player control"),
          const Text(
            "Broken EXIF support for HEIC files created by Samsung devices",
          ),
          const Text("EXIF date time not updating correctly"),
          const Text(
            "Thanks @invario, @luckkmaxx, @wonx1 for their bug reports!",
          ),
        ]),
        _sectionPadding(),
        _subSection("Localization"),
        _bulletGroup(const Text("Updated Finnish (by pHamala)")),
        _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
      ],
    );
  }
}
