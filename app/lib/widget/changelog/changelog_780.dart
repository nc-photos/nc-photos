part of '../changelog.dart';

class _Changelog780 extends StatelessWidget {
  const _Changelog780();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "(New) Compress and downscale local files to JPEG/JXL before uploading",
          ),
        ),
        _bulletGroup(const Text("Fixed metadata not showing for local files")),
        _bulletGroup(const Text("Updated Turkish")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [const Text("Ali Yasin Yeşilyaprak")],
        ),
      ],
    );
  }
}
