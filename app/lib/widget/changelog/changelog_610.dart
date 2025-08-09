part of '../changelog.dart';

class _Changelog610 extends StatelessWidget {
  const _Changelog610();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Added \"Set as\" in viewer to set the current opened photo as phone wallpaper",
          ),
        ),
        _bulletGroup(
          const Text(
            "(Recognize) Fixed a bug where changes to faces are not synced correctly",
          ),
        ),
        _bulletGroup(const Text("Various UI tweaks and bug fixes")),
      ],
    );
  }
}
