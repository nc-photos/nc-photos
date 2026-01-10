part of 'changelog.dart';

class _Changelog832 extends StatelessWidget {
  const _Changelog832();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("Brand new app icon!")),
        _bulletGroup(
          const Text("Fixed crash when reading metadata of some mp4 files"),
        ),
        _bulletGroup(const Text("Reenabled metadata processing of mp4 files")),
      ],
    );
  }
}
