part of '../changelog.dart';

class _Changelog670 extends StatelessWidget {
  const _Changelog670();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Added map view that show your photos on a map"),
        ),
        _bulletGroup(
          const Text(
            "Added new experimental HTTP engine with HTTP/2 and HTTP/3 QUIC support",
          ),
          [const Text("Enable it in Settings > Advanced")],
        ),
        _bulletGroup(
          const Text("Overhaul slideshow viewer with improved control"),
        ),
        _bulletGroup(
          const Text(
            "Can now add new self-signed cert without adding a new account",
          ),
        ),
        _bulletGroup(
          const Text("Added self-signed cert manager to remove old certs"),
          [const Text("Settings > Advanced > Manage trusted certificates")],
        ),
        _bulletGroup(const Text("Multiple UI tweaks")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [const Text("Ali Yasin Yeşilyaprak"), const Text("Niclas H")],
        ),
      ],
    );
  }
}
