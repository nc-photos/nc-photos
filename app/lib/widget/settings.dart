import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/mobile/platform.dart'
    if (dart.library.html) 'package:nc_photos/web/platform.dart'
    as platform;
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/platform/notification.dart';
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
                leading: const Icon(Icons.privacy_tip_outlined),
                label: L10n.global().settingsPrivacyTitle,
                description: L10n.global().settingsPrivacyDescription,
                pageBuilder: () => _PrivacySettings(),
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

class _PrivacySettings extends StatefulWidget {
  @override
  createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<_PrivacySettings> {
  @override
  initState() {
    super.initState();
    if (features.isSupportCrashlytics) {
      _isEnableAnalytics =
          FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
    }
    if (features.isSupportAds) {
      _isEnablePersonalizedAds = Pref().isPersonalizedAdsOr(false);
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) => _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsPrivacyPageTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            if (features.isSupportCrashlytics)
              SwitchListTile(
                title: Text(L10n.global().settingsAnalyticsTitle),
                subtitle: Text(L10n.global().settingsAnalyticsSubtitle),
                value: _isEnableAnalytics,
                onChanged: (value) => _onAnalyticsChanged(value),
              ),
            if (features.isSupportAds)
              SwitchListTile(
                title: Text(L10n.global().settingsPersonalizedAdsTitle),
                subtitle: Text(L10n.global().settingsPersonalizedAdsSubtitle),
                value: _isEnablePersonalizedAds,
                onChanged: (value) => _onPersonalizedAdsChanged(value),
              ),
            ListTile(
              title: Text(L10n.global().settingsPrivacyPolicyTitle),
              onTap: () {
                launch(k.privacyPolicyUrl);
              },
            ),
          ]),
        ),
      ],
    );
  }

  void _onAnalyticsChanged(bool value) {
    setState(() {
      _isEnableAnalytics = value;
    });
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(value);
  }

  void _onPersonalizedAdsChanged(bool value) {
    Pref().setPersonalizedAds(value);
    setState(() {
      _isEnablePersonalizedAds = value;
    });
  }

  late bool _isEnableAnalytics;
  late bool _isEnablePersonalizedAds;
}
