import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/url_launcher_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';

part 'changelog.g.dart';
part 'changelog/changelog_550.dart';
part 'changelog/changelog_560.dart';
part 'changelog/changelog_570.dart';
part 'changelog/changelog_580.dart';
part 'changelog/changelog_590.dart';
part 'changelog/changelog_600.dart';
part 'changelog/changelog_610.dart';
part 'changelog/changelog_630.dart';
part 'changelog/changelog_640.dart';
part 'changelog/changelog_650.dart';
part 'changelog/changelog_660.dart';
part 'changelog/changelog_662.dart';
part 'changelog/changelog_663.dart';
part 'changelog/changelog_670.dart';
part 'changelog/changelog_680.dart';
part 'changelog/changelog_690.dart';
part 'changelog/changelog_700.dart';
part 'changelog/changelog_710.dart';
part 'changelog/changelog_720.dart';
part 'changelog/changelog_730.dart';
part 'changelog/changelog_740.dart';
part 'changelog/changelog_750.dart';
part 'changelog/changelog_760.dart';
part 'changelog/changelog_770.dart';
part 'changelog/changelog_780.dart';
part 'changelog/changelog_782.dart';
part 'changelog/changelog_790.dart';
part 'changelog/changelog_800.dart';

class ChangelogArguments {
  const ChangelogArguments(this.fromVersion);

  final int fromVersion;
}

@npLog
class Changelog extends StatelessWidget {
  static const routeName = "/changelog";

  static Route buildRoute(ChangelogArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => Changelog.fromArgs(args),
        settings: settings,
      );

  static bool hasContent(int fromVersion) =>
      _changelogs.keys.first > fromVersion;

  const Changelog({super.key, this.fromVersion});

  Changelog.fromArgs(ChangelogArguments args, {Key? key})
    : this(key: key, fromVersion: args.fromVersion);

  @override
  build(BuildContext context) => Scaffold(
    appBar: _buildAppBar(),
    body: Builder(builder: (context) => _buildContent(context)),
  );

  AppBar _buildAppBar() =>
      AppBar(title: Text(L10n.global().changelogTitle), elevation: 0);

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _ChangelogBanner(
          title: Text(L10n.global().donationShortMessage),
          action: TextButton(
            onPressed: () {
              launch(help_util.donateUrl);
            },
            child: Text(L10n.global().donationButtonLabel),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _changelogs.length,
            itemBuilder: _buildItem,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int i) {
    try {
      final version = _changelogs.keys.elementAt(i);
      final String title;
      if (version > 1000) {
        final major = version ~/ 100;
        final minor = version % 100;
        title = "$major.$minor";
      } else {
        title = (version / 10).toStringAsFixed(1);
      }
      return ExpansionTile(
        key: PageStorageKey(i),
        title: Text(title),
        initiallyExpanded:
            fromVersion == null ? (i == 0) : (version > fromVersion!),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,
        childrenPadding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: _changelogs[version]!(context),
      );
    } catch (e, stackTrace) {
      _log.severe("[_buildItem] Uncaught exception", e, stackTrace);
      return const SizedBox();
    }
  }

  final int? fromVersion;
}

List<Widget> _buildChangelog460(BuildContext context) {
  return [
    _subSectionHighlight("IMPORTANT"),
    _bulletGroup(
      const Text(
        "Completely reworked the cache database, the app will perform a full resync with server from scratch",
      ),
    ),
    _bulletGroup(
      const Text(
        "(LDAP user only) Previously the username is used in place of user ID incorrectly, this is now fixed but albums created before may become broken. Please recreate them if that's the case. Sorry for your inconvenience",
      ),
    ),
    _sectionPadding(),
    _subSection("Improvements"),
    _bulletGroup(
      const Text(
        "Improved performance working with a large collection of photos",
      ),
    ),
    _bulletGroup(const Text("New image editor"), [
      const Text(
        "Adjust image brightness, contrast, white point, black point, saturation, warmth and tint",
      ),
    ]),
    _bulletGroup(const Text("Double tap to exit"), [
      const Text("Settings > Miscellaneous > Double tap to exit"),
    ]),
    _bulletGroup(
      const Text("Replace account info in the app bar with customized label"),
      [const Text("Settings > Account > Label")],
    ),
    _sectionPadding(),
    _subSection("Localization"),
    _bulletGroup(const Text("Updated Finnish (by pHamala)")),
    _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
    _sectionPadding(),
    _subSection("Known issues"),
    _bulletGroup(
      const Text(
        "Google Maps is temporarily disabled due to a bug in the Maps SDK. The app will use OSM as the only map provider until the bug is fixed",
      ),
    ),
  ];
}

List<Widget> _buildChangelog470(BuildContext context) {
  return [
    _subSection("Localization"),
    _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
    _sectionPadding(),
    _subSection("Known issues"),
    _bulletGroup(
      const Text(
        "Google Maps is temporarily disabled due to a bug in the Maps SDK. The app will use OSM as the only map provider until the bug is fixed",
      ),
    ),
  ];
}

List<Widget> _buildChangelog480(BuildContext context) {
  return [
    _subSectionHighlight("IMPORTANT"),
    _bulletGroup(
      const Text("Favorites and People are relocated to the Search tab"),
    ),
    _sectionPadding(),
    _subSection("Improvements"),
    _bulletGroup(const Text("Search")),
    _sectionPadding(),
    _subSection("Localization"),
    _bulletGroup(const Text("Updated Finnish (by pHamala)")),
    _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
    _sectionPadding(),
    _subSection("Known issues"),
    _bulletGroup(
      const Text(
        "Google Maps is temporarily disabled due to a bug in the Maps SDK. The app will use OSM as the only map provider until the bug is fixed",
      ),
    ),
  ];
}

List<Widget> _buildChangelog500(BuildContext context) {
  return [
    _subSection("Changes"),
    _bulletGroup(
      const Text(
        "Search and show places converted from GPS coordinates embedded in EXIF",
      ),
      [const Text("The app will process your photos in the background")],
    ),
    _bulletGroup(const Text("Google Maps is now re-enabled on some devices")),
    _sectionPadding(),
    _subSection("Localization"),
    _bulletGroup(const Text("Updated Finnish (by pHamala)")),
    _sectionPadding(),
    _subSection("Known issues"),
    _bulletGroup(
      const Text(
        "Google Maps is temporarily disabled on some devices due to a bug in the Maps SDK",
      ),
    ),
  ];
}

List<Widget> _buildChangelog510(BuildContext context) {
  return [
    _subSection("Changes"),
    _bulletGroup(const Text("New image editing tools"), [
      const Text("Crop"),
      const Text("Change the orientation (90°, 180°, 270°) of an image"),
    ]),
    _bulletGroup(const Text("Search now returns more relavant results")),
    _bulletGroup(
      const Text("Tweak how many days should be included in Memories"),
      [const Text("Settings > Photos > Memories range")],
    ),
  ];
}

List<Widget> _buildChangelog520(BuildContext context) {
  return [
    _subSection("Changes"),
    _bulletGroup(
      const Text(
        "New option to share a reduced quality preview instead of the original file",
      ),
    ),
    _bulletGroup(
      const Text(
        "Support saving enhanced/edited photos directly on the server",
      ),
    ),
    _bulletGroup(const Text("Image enhancements"), [
      const Text("Added color pop"),
      const Text("Improved portrait blur in scenes with multiple objects"),
    ]),
    _bulletGroup(const Text("Image editor"), [
      const Text("Fixed changing image orientation may flip the image"),
    ]),
  ];
}

List<Widget> _buildChangelog530(BuildContext context) {
  return [
    _subSection("Changes"),
    _bulletGroup(const Text("New enhancement: auto retouch"), [
      const Text(
        "Automatically retouch your photos, improve color and vibrance",
      ),
    ]),
    _bulletGroup(
      const Text(
        "A redesigned enhancement page that is more informative and beautiful",
      ),
    ),
    _sectionPadding(),
    _subSection("Localization"),
    _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
  ];
}

List<Widget> _buildChangelog540(BuildContext context) {
  return [
    _subSection("Changes"),
    _bulletGroup(const Text("Performance tweaks")),
    _sectionPadding(),
    _subSection("Localization"),
    _bulletGroup(const Text("Updated Spanish (by luckkmaxx)")),
  ];
}

// ignore: unused_element
class _ChangelogBanner extends StatelessWidget {
  const _ChangelogBanner({
    required this.title,
    // ignore: unused_element_parameter
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(
        context,
      ).elevate(Theme.of(context).colorScheme.surface, 2),
      child: DefaultTextStyle(
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        child: TextButtonTheme(
          data: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [Expanded(child: title), if (action != null) action!],
          ),
        ),
      ),
    );
  }

  final Widget title;
  final Widget? action;
}

List<Widget> _buildChangelogCompat(BuildContext context, int majorVersion) {
  var change = _oldChangelogs[majorVersion - 1];
  if (change != null) {
    try {
      // remove the 1st line showing the version number repeatedly
      change = change.substring(change.indexOf("\n")).trim();
    } catch (_) {
      change = _oldChangelogs[majorVersion - 1];
    }
  }
  return [Text(change ?? "n/a")];
}

Widget _sectionPadding() => const SizedBox(height: 16);

Widget _subSection(String label) =>
    Text(label, style: const TextStyle(fontSize: 16));

Widget _subSectionHighlight(String label) =>
    Text(label, style: const TextStyle(fontSize: 16, color: Colors.red));

Widget _bulletGroup(Widget main, [List<Widget> children = const []]) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 2),
  child: Column(
    children: [_bulletPoint(main), ...children.map((s) => _subBulletPoint(s))],
  ),
);

Widget _bulletPoint(Widget child) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(width: 4),
    const Text(_bullet),
    const SizedBox(width: 4),
    Expanded(child: child),
  ],
);

Widget _subBulletPoint(Widget child) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(width: 24),
    const Text(_bullet),
    const SizedBox(width: 4),
    Expanded(child: child),
  ],
);

final _changelogs = <int, List<Widget> Function(BuildContext)>{
  8000: (_) => const [_Changelog800()],
  7900: (_) => const [_Changelog790()],
  7802: (_) => const [_Changelog782()],
  7800: (_) => const [_Changelog780()],
  7700: (_) => const [_Changelog770()],
  760: (_) => const [_Changelog760()],
  750: (_) => const [_Changelog750()],
  740: (_) => const [_Changelog740()],
  730: (_) => const [_Changelog730()],
  720: (_) => const [_Changelog720()],
  710: (_) => const [_Changelog710()],
  700: (_) => const [_Changelog700()],
  690: (_) => const [_Changelog690()],
  680: (_) => const [_Changelog680()],
  670: (_) => const [_Changelog670()],
  663: (_) => const [_Changelog663()],
  662: (_) => const [_Changelog662()],
  660: (_) => const [_Changelog660()],
  650: (_) => const [_Changelog650()],
  640: (_) => const [_Changelog640()],
  630: (_) => const [_Changelog630()],
  610: (_) => const [_Changelog610()],
  600: (_) => const [_Changelog600()],
  590: (_) => const [_Changelog590()],
  580: (_) => const [_Changelog580()],
  570: (_) => const [_Changelog570()],
  560: (_) => const [_Changelog560()],
  550: (_) => const [_Changelog550()],
  540: _buildChangelog540,
  530: _buildChangelog530,
  520: _buildChangelog520,
  510: _buildChangelog510,
  500: _buildChangelog500,
  480: _buildChangelog480,
  470: _buildChangelog470,
  460: _buildChangelog460,
  450: (context) => _buildChangelogCompat(context, 45),
  440: (context) => _buildChangelogCompat(context, 44),
  430: (context) => _buildChangelogCompat(context, 43),
  420: (context) => _buildChangelogCompat(context, 42),
  410: (context) => _buildChangelogCompat(context, 41),
  400: (context) => _buildChangelogCompat(context, 40),
  380: (context) => _buildChangelogCompat(context, 38),
  370: (context) => _buildChangelogCompat(context, 37),
  360: (context) => _buildChangelogCompat(context, 36),
  350: (context) => _buildChangelogCompat(context, 35),
  340: (context) => _buildChangelogCompat(context, 34),
  320: (context) => _buildChangelogCompat(context, 32),
  310: (context) => _buildChangelogCompat(context, 31),
  300: (context) => _buildChangelogCompat(context, 30),
  290: (context) => _buildChangelogCompat(context, 29),
  280: (context) => _buildChangelogCompat(context, 28),
  270: (context) => _buildChangelogCompat(context, 27),
  260: (context) => _buildChangelogCompat(context, 26),
  240: (context) => _buildChangelogCompat(context, 24),
  230: (context) => _buildChangelogCompat(context, 23),
  200: (context) => _buildChangelogCompat(context, 20),
  190: (context) => _buildChangelogCompat(context, 19),
  180: (context) => _buildChangelogCompat(context, 18),
  170: (context) => _buildChangelogCompat(context, 17),
  150: (context) => _buildChangelogCompat(context, 15),
  130: (context) => _buildChangelogCompat(context, 13),
  80: (context) => _buildChangelogCompat(context, 8),
  70: (context) => _buildChangelogCompat(context, 7),
};

const _bullet = "\u2022";

const _oldChangelogs = [
  // v1
  null,
  // v2
  null,
  // v3
  null,
  // v4
  null,
  // v5
  null,
  // v6
  null,
  // v7
  """1.7.0
Added HEIC support
Fixed a bug that corrupted the albums. Please re-add the photos after upgrading. Sorry for your inconvenience
""",
  // v8
  """1.8.0
Dark theme
""",
  // v9
  null,
  // v10
  null,
  // v11
  null,
  // v12
  null,
  // v13
  """13.0
Added MP4 support (Android only)
""",
  // v14
  null,
  // v15
  """15.0
This version includes changes that are not compatible with older versions. Please also update your other devices if applicable
""",
  // v16
  null,
  // v17
  """17.0
Archive photos to only show them in albums
Link to report issues in Settings
""",
  // v18
  """18.0
Modify date/time of photos
Support GIF
""",
  // v19
  """19.0
- Folder based album to browse photos in an existing folder (read only)
- Batch import folder based albums

This version includes changes that are not compatible with older versions. Please also update your other devices if applicable
""",
  // v20
  """20.0
- Improved albums: sorting, text labels
- Simplify sharing to other apps
- Added WebM support (Android only)
""",
  // v21
  null,
  // v22
  null,
  // v23
  """23.0
- Paid version is now published on Play Store. Head to Settings to learn more if you are interested
""",
  // v24
  """24.0
- Show and manage deleted files in trash bin
""",
  // v25
  null,
  // v26
  """26.0
- Pick album cover (open a photo in an album -> details -> use as cover)
""",
  // v27
  """27.0
- New settings to customize photo viewer
""",
  // v28
  """28.0
- New settings:
  - Follow system dark theme settings (Android 10+)
""",
  // v29
  """29.0
Features:
  - (Experimental) Support the Nextcloud Face Recognition app
  - Slideshow
  - Performance & cache tweaks
    - Due to an overhaul to the cache management, the old cache can't be used and will be cleared. First run after update will thus be slower

Localization (new/update):
  - German (by PhilProg)
  - Spanish (by luckkmaxx)
""",
  // v30
  """30.0
Features:
  - Share a single item using a link
  - Optimize albums: the JSON files are now much smaller
  - Download album/selected items

Localization (new/update):
  - Czech (by Skyhawk)
  - Spanish (by luckkmaxx)
""",
  // v31
  """31.0
Features:
  - Share multiple items using a link
  - Manage shares in Collections > Sharing
  - (Web) Now support share links like Android
  - Group photos by date in albums (enable in Settings > Album)
""",
  // v32
  """32.0
Features:
  - Enable/disable server app integrations in Settings > Account
""",
  // v33
  null,
  // v34
  """34.0
- Add OSM as an alternative map provider (Settings > Viewer)
- (Experimental) Add shared album (Settings > Experimental)
- (UI) Swipe up to show photo details
- (Localization) Update Spanish (by luckkmaxx)
""",
  // v35
  """35.0
- Optimize start up performance
  - Photos should appear more quickly on start up
- (UI) Swipe down to close the photo viewer
- (Localization) Add Finnish (by pHamala)

* The app needs to resync with the server due to changes in the database
""",
  // v36
  """36.0
- Memories
  - Show photos taken in the past
""",
  // v37
  """37.0
- Favorites
  - Browse favorites (Collections > Favorites)
  - Add to or remove from favorites in photo viewer
- Tag
  - Browse photos by specific tags (Collections > New collection > Tag)
- (Localization) Add Polish (by szymok)
- (Localization) Update Finnish (by pHamala)
""",
  // v38
  """38.0
- (Android) Image metadata are now processed in a background service
- (Localization) Update Finnish (by pHamala)
- (Localization) Update Spanish (by luckkmaxx)
""",
  // v39
  null,
  // v40
  """40.0
- (Android) Fixed a race condition causing the app to deadlock
- (Localization) Add Portuguese (by fernosan)
- (Localization) Update Finnish (by pHamala)
- (Localization) Update Russian (by kvasenok)
""",
  // v41
  """41.0
- (Android) Enhance your photo with the new Enhance button in viewer
- (Android) New photo enhancement algorithms:
  - Low-light enhancement
  - Portrait blur
- (Localization) Add Chinese (by zerolin)
- (Localization) Update French (by mgreil)
""",
  // v42
  """42.0
- Add tweakable parameters to low-light enhancement and portrait blur
""",
  // v43
  """43.0
- (Android) Photo enhancements now implemented in C++:
  - Better performance
  - Less restrictions on RAM usage
- (Android) New photo enhancement algorithms:
  - Super-resolution (upscale image to 4x)
- (Localization) Update Finnish (by pHamala)
""",
  // v44
  """44.0
- (Android) New photo enhancement algorithms:
  - Style transfer
""",
  // v45
  """45.0
- Toggle between processing EXIF over Wi-Fi only or any network in Settings
- (Localization) Update Greek (by Chris Karasoulis)
""",
];
