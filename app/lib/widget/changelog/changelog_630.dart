part of 'changelog.dart';

class _Changelog630 extends StatelessWidget {
  const _Changelog630();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Various UI tweaks and bug fixes")),
        _bulletGroup(
          const Text("Updated Catalan, German, Italian, Russian, Spanish"),
        ),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [
            const Text("Albe"),
            const Text("ArnyminerZ"),
            const Text("luckkmaxx"),
            const Text("Odious"),
            const Text("RandomRoot"),
            const Text("Sebastian"),
          ],
        ),
      ],
    );
  }
}
