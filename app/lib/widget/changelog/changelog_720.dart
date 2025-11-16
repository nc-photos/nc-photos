part of 'changelog.dart';

class _Changelog720 extends StatelessWidget {
  const _Changelog720();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "\"Album\" and \"Nextcloud album\" are renamed to \"Client side album\" and \"Server side album\"",
          ),
          [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                onTap: () {
                  launch(help_util.collectionTypesUrl);
                },
                child: Text(
                  "Learn more about their differences",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        _bulletGroup(
          const Text("Client side album now supports adding an inline map"),
        ),
        _bulletGroup(
          const Text(
            "On Nextcloud 28+, app will now read metadata from the server instead of extracting it ourselves",
          ),
          [
            const Text(
              "Image formats not yet supported by Nextcloud will continue to use the client side method",
            ),
            const Text(
              "Geolocation is done on client side so the background service will continue to run",
            ),
          ],
        ),
        _bulletGroup(const Text("Updated French, Turkish")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [
            const Text("Ali Yasin Yeşilyaprak"),
            const Text("Choukajohn"),
            const Text("Corentin Noël"),
          ],
        ),
      ],
    );
  }
}
