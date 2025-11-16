part of 'changelog.dart';

class _Changelog560 extends StatelessWidget {
  const _Changelog560();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Fixed files moved on server are sometimes not indexed by the app",
          ),
          [
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        "If you were affected by this, please clear the corrupted local database in ",
                  ),
                  TextSpan(
                    text: "Settings > Advanced > Clear file database",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _bulletGroup(const Text("Added a loop button to the video player")),
      ],
    );
  }
}
