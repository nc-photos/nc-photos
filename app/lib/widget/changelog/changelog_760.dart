part of '../changelog.dart';

class _Changelog760 extends StatelessWidget {
  const _Changelog760();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Improved scrolling performance")),
        _bulletGroup(const Text("Fixed various bugs")),
        _bulletGroup(const Text("Added Japanese")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [const Text("yoking")],
        ),
      ],
    );
  }
}
