part of 'changelog.dart';

class _Changelog820 extends StatelessWidget {
  const _Changelog820();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Supported mp4/mov metadata via our client side parser"),
        ),
        _bulletGroup(const Text("Optimized how the client side parser work"), [
          const Text(
            "We now only stream the metadata part of the file from your server",
          ),
        ]),
      ],
    );
  }
}
