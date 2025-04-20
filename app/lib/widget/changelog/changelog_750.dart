part of '../changelog.dart';

class _Changelog750 extends StatelessWidget {
  const _Changelog750();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Added JPEG XL support"),
          const [
            Text("JPEG XL is a next generation royalty-free image codec"),
            Text(
                "JXL support is provided solely on the client side, which means that there are some limitations interacting with server side features"),
          ],
        ),
        _bulletGroup(const Text("Now uses exiv2 to parse exif from photos")),
        _bulletGroup(const Text(
            "Fixed a crash when notification permission is not granted")),
      ],
    );
  }
}
