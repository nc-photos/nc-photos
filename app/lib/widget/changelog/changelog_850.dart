part of 'changelog.dart';

class _Changelog850 extends StatelessWidget {
  const _Changelog850();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Rewrote image editor with improved performance and memory management",
          ),
        ),
        _bulletGroup(
          const Text("Added various new effect filters to the image editor"),
        ),
        _bulletGroup(const Text("Fixed JXL converter")),
        _bulletGroup(const Text("Various bug fixes and UI updates")),
        _bulletGroup(const Text("Updated Japanese")),
      ],
    );
  }
}
