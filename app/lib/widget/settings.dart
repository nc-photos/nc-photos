import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/mobile/platform.dart'
    if (dart.library.html) 'package:nc_photos/web/platform.dart'
    as platform;
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/platform/notification.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/list_tile_center_leading.dart';
import 'package:nc_photos/widget/settings/collection_settings.dart';
import 'package:nc_photos/widget/settings/developer_settings.dart';
import 'package:nc_photos/widget/settings/enhancement_settings.dart';
import 'package:nc_photos/widget/settings/expert_settings.dart';
import 'package:nc_photos/widget/settings/language_settings.dart';
import 'package:nc_photos/widget/settings/metadata_settings.dart';
import 'package:nc_photos/widget/settings/misc_settings.dart';
import 'package:nc_photos/widget/settings/photos_settings.dart';
import 'package:nc_photos/widget/settings/settings_list_caption.dart';
import 'package:nc_photos/widget/settings/theme_settings.dart';
import 'package:nc_photos/widget/settings/viewer_settings.dart';
import 'package:nc_photos/widget/update_checker.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';

part 'settings.g.dart';

class Settings extends StatefulWidget {
  static const routeName = "/settings";

  static Route buildRoute(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => const Settings(), settings: settings);

  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

@npLog
class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    _isEnableAutoUpdateCheck = Pref().isEnableAutoUpdateCheckOr();
  }

  @override
  Widget build(BuildContext context) {
    final translator = L10n.global().translator;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(L10n.global().settingsWidgetTitle),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ValueStreamBuilder<language_util.AppLanguage>(
                stream: context.read<PrefController>().language,
                builder:
                    (context, snapshot) => ListTile(
                      leading: const ListTileCenterLeading(
                        child: Icon(Icons.translate_outlined),
                      ),
                      title: Text(L10n.global().settingsLanguageTitle),
                      subtitle: Text(snapshot.requireData.nativeName),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(LanguageSettings.routeName);
                      },
                    ),
              ),
              _SubPageItem(
                leading: const Icon(Icons.palette_outlined),
                label: L10n.global().settingsThemeTitle,
                description: L10n.global().settingsThemeDescription,
                pageBuilder: () => const ThemeSettings(),
              ),
              _SubPageItem(
                leading: const Icon(Icons.local_offer_outlined),
                label: L10n.global().settingsMetadataTitle,
                pageBuilder: () => const MetadataSettings(),
              ),
              _SubPageItem(
                leading: const Icon(Icons.image_outlined),
                label: L10n.global().photosTabLabel,
                description: L10n.global().settingsPhotosDescription,
                pageBuilder: () => const PhotosSettings(),
              ),
              _SubPageItem(
                leading: const Icon(Icons.grid_view_outlined),
                label: L10n.global().collectionsTooltip,
                pageBuilder: () => const CollectionSettings(),
              ),
              _SubPageItem(
                leading: const Icon(Icons.view_carousel_outlined),
                label: L10n.global().settingsViewerTitle,
                description: L10n.global().settingsViewerDescription,
                pageBuilder: () => const ViewerSettings(),
              ),
              if (features.isSupportEnhancement)
                _SubPageItem(
                  leading: const Icon(Icons.auto_fix_high_outlined),
                  label: L10n.global().settingsImageEditTitle,
                  description: L10n.global().settingsImageEditDescription,
                  pageBuilder: () => const EnhancementSettings(),
                ),
              _SubPageItem(
                leading: const Icon(Icons.emoji_symbols_outlined),
                label: L10n.global().settingsMiscellaneousTitle,
                pageBuilder: () => const MiscSettings(),
              ),
              _SubPageItem(
                leading: const Icon(Icons.warning_amber),
                label: L10n.global().settingsExpertTitle,
                pageBuilder: () => const ExpertSettings(),
              ),
              if (_isShowDevSettings)
                _SubPageItem(
                  leading: const Icon(Icons.code_outlined),
                  label: "Developer options",
                  pageBuilder: () => const DeveloperSettings(),
                ),
              SettingsListCaption(
                label: L10n.global().settingsAboutSectionTitle,
              ),
              ListTile(
                title: Text(L10n.global().settingsVersionTitle),
                subtitle: const Text(k.versionStr),
                onTap: () {
                  if (!_isShowDevSettings && --_devSettingsUnlockCount <= 0) {
                    setState(() {
                      _isShowDevSettings = true;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.coffee_outlined),
                title: Text(L10n.global().donationTitle),
                onTap: () {
                  launch(help_util.donateUrl);
                },
              ),
              ListTile(
                trailing:
                    Pref().isAutoUpdateCheckAvailableOr()
                        ? Stack(
                          fit: StackFit.passthrough,
                          children: [
                            const Icon(Icons.upload),
                            Positioned.directional(
                              textDirection: Directionality.of(context),
                              end: 0,
                              top: 0,
                              child: const Icon(
                                Icons.circle,
                                color: Colors.red,
                                size: 8,
                              ),
                            ),
                          ],
                        )
                        : null,
                title: const Text("Check for updates"),
                onTap: () {
                  Navigator.of(context).pushNamed(UpdateChecker.routeName);
                },
              ),
              SwitchListTile(
                title: const Text("Check for updates automatically"),
                value: _isEnableAutoUpdateCheck,
                onChanged: _onEnableAutoUpdateCheckChanged,
              ),
              ListTile(
                title: Text(L10n.global().settingsSourceCodeTitle),
                onTap: () {
                  launch(_sourceRepo);
                },
              ),
              ListTile(
                title: Text(L10n.global().settingsBugReportTitle),
                onTap: () {
                  launch(_bugReportUrl);
                },
              ),
              SwitchListTile(
                title: Text(L10n.global().settingsCaptureLogsTitle),
                subtitle: Text(L10n.global().settingsCaptureLogsDescription),
                value: LogCapturer().isEnable,
                onChanged: (value) => _onCaptureLogChanged(context, value),
              ),
              if (translator.isNotEmpty)
                ListTile(
                  title: Text(L10n.global().settingsTranslatorTitle),
                  subtitle: Text(translator),
                  onTap: () {
                    launch(_translationUrl);
                  },
                )
              else
                ListTile(
                  title: const Text("Improve translation"),
                  subtitle: const Text("Help translating to your language"),
                  onTap: () {
                    launch(_translationUrl);
                  },
                ),
            ]),
          ),
          const SliverSafeBottom(),
        ],
      ),
    );
  }

  Future<void> _onCaptureLogChanged(BuildContext context, bool value) async {
    if (value) {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              content: Text(L10n.global().captureLogDetails),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(L10n.global().enableButtonLabel),
                ),
              ],
            ),
      );
      if (result == true) {
        setState(() {
          LogCapturer().start();
        });
      }
    } else {
      if (LogCapturer().isEnable) {
        setState(() {
          LogCapturer().stop().then((result) {
            _onLogSaveSuccessful(result);
          });
        });
      }
    }
  }

  Future<void> _onLogSaveSuccessful(dynamic result) async {
    final nm = platform.NotificationManager();
    try {
      await nm.notify(LogSaveSuccessfulNotification(result));
    } catch (e, stacktrace) {
      _log.shout(
        "[_onLogSaveSuccessful] Failed showing platform notification",
        e,
        stacktrace,
      );
    }
  }

  Future<void> _onEnableAutoUpdateCheckChanged(bool value) async {
    _log.info("[_onEnableAutoUpdateCheckChanged] New value: $value");
    final oldValue = _isEnableAutoUpdateCheck;
    setState(() {
      _isEnableAutoUpdateCheck = value;
    });
    if (!await Pref().setIsEnableAutoUpdateCheck(value)) {
      _log.severe("[_onEnableAutoUpdateCheckChanged] Failed writing pref");
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().writePreferenceFailureNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      setState(() {
        _isEnableAutoUpdateCheck = oldValue;
      });
    } else {
      if (!value) {
        // reset state after disabling
        if (mounted) {
          setState(() {
            Pref()
              ..setIsAutoUpdateCheckAvailable(false)
              ..setLastAutoUpdateCheckTime(0);
          });
        }
      }
    }
  }

  late bool _isEnableAutoUpdateCheck;

  var _devSettingsUnlockCount = 3;
  var _isShowDevSettings = false;

  static const String _sourceRepo = "https://bit.ly/3LQerBv";
  static const String _bugReportUrl = "https://bit.ly/3NANrr7";
  static const String _translationUrl = "https://bit.ly/3NwmdSw";
}

class _SubPageItem extends StatelessWidget {
  const _SubPageItem({
    this.leading,
    required this.label,
    this.description,
    required this.pageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading == null ? null : ListTileCenterLeading(child: leading!),
      title: Text(label),
      subtitle: description == null ? null : Text(description!),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => pageBuilder()));
      },
    );
  }

  final Widget? leading;
  final String label;
  final String? description;
  final Widget Function() pageBuilder;
}
