part of '../changelog.dart';

class _Changelog710 extends StatelessWidget {
  const _Changelog710();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Now support customizing buttons in the viewer"),
          [
            const Text("Settings > Viewer > Customize app bar"),
            const Text("Settings > Viewer > Customize bottom app bar"),
          ],
        ),
        _bulletGroup(
          const Text(
            "Now support customizing the navigation bar in Collections",
          ),
          [const Text("Settings > Collections > Customize navigation bar")],
        ),
        _bulletGroup(const Text("Relocated Map, it's now inside Collections")),
        _bulletGroup(const Text("Various bug fixes")),
      ],
    );
  }
}
