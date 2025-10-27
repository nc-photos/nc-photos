part of '../changelog.dart';

class _Changelog800 extends StatelessWidget {
  const _Changelog800();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "If the same photo exists both on your device and server, the app will now merge them into a single item in the timeline",
          ),
          [const Text("Files are merged based on their file name and time")],
        ),
        _bulletGroup(const Text("Fixed app showing UTC time in photo details")),
      ],
    );
  }
}
