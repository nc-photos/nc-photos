part of 'changelog.dart';

class _Changelog840 extends StatelessWidget {
  const _Changelog840();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Now share the local copy instead of the remote copy when sharing a file",
          ),
        ),
        _bulletGroup(
          const Text(
            "Fixed sharing a file left a copy in the Downloads folder",
          ),
        ),
        _bulletGroup(
          const Text(
            "Added an option to show original image instead of preview",
          ),
          [const Text("Settings > Advanced")],
        ),
        _bulletGroup(const Text("Streamlined backup indicator in timeline"), [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "Photos with cloud backup will show the backup indicator: ",
                ),
                WidgetSpan(child: Icon(Icons.cloud_done_outlined, size: 16)),
              ],
            ),
          ),
          const Text(
            "Nothing will be shown for local files without cloud backup",
          ),
        ]),
        _bulletGroup(
          const Text(
            "Now possible to select all photos taken on the same date at once in timeline",
          ),
          [const Text("Long press the date or tap the check mark")],
        ),
        _bulletGroup(const Text("Fixed OSM support")),
        _bulletGroup(const Text("Improved JXL support")),
        _bulletGroup(const Text("Various UI updates")),
      ],
    );
  }
}
