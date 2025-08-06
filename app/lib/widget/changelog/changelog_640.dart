part of '../changelog.dart';

class _Changelog640 extends StatelessWidget {
  const _Changelog640();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSectionHighlight("CRITICAL"),
        _bulletGroup(
          const Text(
            "Fixed a crtical bug where removing an image from a Nextcloud Album will in fact delete it",
          ),
          [
            const Text(
              "Please check the Trash if you have removed files from a Nextcloud Album before",
            ),
            const Text("I sincerely apologize for this critical mistake"),
          ],
        ),
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Fixed dynamic color (Material You) not applied correctly",
          ),
        ),
        _bulletGroup(
          const Text(
            "Nextcloud Albums shared with you will now appear in Collections",
          ),
        ),
        _bulletGroup(const Text("Various UI tweaks and bug fixes")),
        _bulletGroup(const Text("Updated Catalan, Italian")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [const Text("Albe"), const Text("ArnyminerZ")],
        ),
      ],
    );
  }
}
