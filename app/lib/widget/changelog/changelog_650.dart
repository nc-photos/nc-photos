part of '../changelog.dart';

class _Changelog650 extends StatelessWidget {
  const _Changelog650();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Various UI tweaks and bug fixes")),
        _bulletGroup(
          const Text("Updated Catalan, Czech, Finnish, French, German, Polish"),
        ),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [
            const Text("ArnyminerZ"),
            const Text("Fjuro"),
            const Text("Fymyte"),
            const Text("pHamala"),
            const Text("shagn"),
            const Text("Shieldziak"),
          ],
        ),
      ],
    );
  }
}
