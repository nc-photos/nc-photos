part of 'changelog.dart';

class _Changelog570 extends StatelessWidget {
  const _Changelog570();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Fixed broken enhancements that did nothing or produced weird results",
          ),
          [
            const Text("Color pop"),
            const Text("Low-light enhancement"),
            const Text("Portrait blur"),
          ],
        ),
      ],
    );
  }
}
