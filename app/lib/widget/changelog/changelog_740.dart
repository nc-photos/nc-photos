part of '../changelog.dart';

class _Changelog740 extends StatelessWidget {
  const _Changelog740();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Client side EXIF fallback is now defaulted to true"),
          [const Text("Can be disabled in Settings > File metadata")],
        ),
        _bulletGroup(
          const Text(
            "Fixed image viewer and slideshow not showing all files when opened from the photos timeline",
          ),
        ),
        _bulletGroup(const Text("Updated Czech, Turkish")),
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
