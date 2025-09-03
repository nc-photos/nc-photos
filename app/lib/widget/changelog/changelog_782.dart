part of '../changelog.dart';

class _Changelog782 extends StatelessWidget {
  const _Changelog782();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Fixed ICC profile not copied to the converted file"),
        ),
        _bulletGroup(
          const Text("Improved performance working with JXL images"),
        ),
      ],
    );
  }
}
