import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/sqlite_table_extension.dart' as sql;
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/mobile/android/android_info.dart';
import 'package:nc_photos/mobile/platform.dart'
    if (dart.library.html) 'package:nc_photos/web/platform.dart' as platform;
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/platform/k.dart' as platform_k;
import 'package:nc_photos/platform/notification.dart';
import 'package:nc_photos/pref.dart';
import 'package:nc_photos/service.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/fancy_option_picker.dart';
import 'package:nc_photos/widget/gps_map.dart';
import 'package:nc_photos/widget/home.dart';
import 'package:nc_photos/widget/list_tile_center_leading.dart';
import 'package:nc_photos/widget/root_picker.dart';
import 'package:nc_photos/widget/share_folder_picker.dart';
import 'package:nc_photos/widget/simple_input_dialog.dart';
import 'package:nc_photos/widget/stateful_slider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:tuple/tuple.dart';

class SettingsArguments {
  SettingsArguments(this.account);

  final Account account;
}

class Settings extends StatefulWidget {
  static const routeName = "/settings";

  static Route buildRoute(SettingsArguments args) => MaterialPageRoute(
        builder: (context) => Settings.fromArgs(args),
      );

  const Settings({
    Key? key,
    required this.account,
  }) : super(key: key);

  Settings.fromArgs(SettingsArguments args, {Key? key})
      : this(
          key: key,
          account: args.account,
        );

  @override
  createState() => _SettingsState();

  final Account account;
}

class _SettingsState extends State<Settings> {
  @override
  initState() {
    super.initState();
    _isEnableExif = Pref().isEnableExifOr();
    _shouldProcessExifWifiOnly = Pref().shouldProcessExifWifiOnlyOr();

    _prefUpdatedListener.begin();
  }

  @override
  dispose() {
    _prefUpdatedListener.end();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final translator = L10n.global().translator;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsWidgetTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ListTile(
                leading: const ListTileCenterLeading(
                  child: Icon(Icons.translate_outlined),
                ),
                title: Text(L10n.global().settingsLanguageTitle),
                subtitle: Text(language_util.getSelectedLanguage().nativeName),
                onTap: () => _onLanguageTap(context),
              ),
              SwitchListTile(
                title: Text(L10n.global().settingsExifSupportTitle),
                subtitle: _isEnableExif
                    ? Text(L10n.global().settingsExifSupportTrueSubtitle)
                    : null,
                value: _isEnableExif,
                onChanged: (value) => _onExifSupportChanged(context, value),
              ),
              if (platform_k.isMobile)
                SwitchListTile(
                  title: Text(L10n.global().settingsExifWifiOnlyTitle),
                  subtitle: _shouldProcessExifWifiOnly
                      ? null
                      : Text(L10n.global().settingsExifWifiOnlyFalseSubtitle),
                  value: _shouldProcessExifWifiOnly,
                  onChanged: _isEnableExif ? _onExifWifiOnlyChanged : null,
                ),
              _buildSubSettings(
                context,
                leading: const Icon(Icons.manage_accounts_outlined),
                label: L10n.global().settingsAccountTitle,
                builder: () => AccountSettingsWidget(account: widget.account),
              ),
              _buildSubSettings(
                context,
                leading: const Icon(Icons.image_outlined),
                label: L10n.global().photosTabLabel,
                description: L10n.global().settingsPhotosDescription,
                builder: () => _PhotosSettings(account: widget.account),
              ),
              _buildSubSettings(
                context,
                leading: const Icon(Icons.photo_album_outlined),
                label: L10n.global().settingsAlbumTitle,
                description: L10n.global().settingsAlbumDescription,
                builder: () => _AlbumSettings(),
              ),
              _buildSubSettings(
                context,
                leading: const Icon(Icons.view_carousel_outlined),
                label: L10n.global().settingsViewerTitle,
                description: L10n.global().settingsViewerDescription,
                builder: () => _ViewerSettings(),
              ),
              if (features.isSupportEnhancement)
                _buildSubSettings(
                  context,
                  leading: const Icon(Icons.auto_fix_high_outlined),
                  label: L10n.global().settingsImageEditTitle,
                  description: L10n.global().settingsImageEditDescription,
                  builder: () => const EnhancementSettings(),
                ),
              _buildSubSettings(
                context,
                leading: const Icon(Icons.palette_outlined),
                label: L10n.global().settingsThemeTitle,
                description: L10n.global().settingsThemeDescription,
                builder: () => _ThemeSettings(),
              ),
              _buildSubSettings(
                context,
                leading: const Icon(Icons.emoji_symbols_outlined),
                label: L10n.global().settingsMiscellaneousTitle,
                builder: () => const _MiscSettings(),
              ),
              if (_enabledExperiments.isNotEmpty)
                _buildSubSettings(
                  context,
                  leading: const Icon(Icons.science_outlined),
                  label: L10n.global().settingsExperimentalTitle,
                  description: L10n.global().settingsExperimentalDescription,
                  builder: () => _ExperimentalSettings(),
                ),
              if (_isShowDevSettings)
                _buildSubSettings(
                  context,
                  leading: const Icon(Icons.code_outlined),
                  label: "Developer options",
                  builder: () => _DevSettings(),
                ),
              _buildCaption(context, L10n.global().settingsAboutSectionTitle),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubSettings(
    BuildContext context, {
    Widget? leading,
    required String label,
    String? description,
    required Widget Function() builder,
  }) {
    return ListTile(
      leading: leading == null
          ? null
          : ListTileCenterLeading(
              child: leading,
            ),
      title: Text(label),
      subtitle: description == null ? null : Text(description),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => builder(),
          ),
        );
      },
    );
  }

  void _onLanguageTap(BuildContext context) {
    final selected =
        Pref().getLanguageOr(language_util.supportedLanguages[0]!.langId);
    showDialog(
      context: context,
      builder: (context) => FancyOptionPicker(
        items: language_util.supportedLanguages.values
            .map((lang) => FancyOptionPickerItem(
                  label: lang.nativeName,
                  description: lang.isoName,
                  isSelected: lang.langId == selected,
                  onSelect: () {
                    _log.info(
                        "[_onLanguageTap] Set language: ${lang.nativeName}");
                    Navigator.of(context).pop(lang.langId);
                  },
                  dense: true,
                ))
            .toList(),
      ),
    ).then((value) {
      if (value != null) {
        Pref().setLanguage(value).then((_) {
          KiwiContainer().resolve<EventBus>().fire(LanguageChangedEvent());
        });
      }
    });
  }

  void _onExifSupportChanged(BuildContext context, bool value) {
    if (value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(L10n.global().exifSupportConfirmationDialogTitle),
          content: Text(L10n.global().exifSupportDetails),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(L10n.global().enableButtonLabel),
            ),
          ],
        ),
      ).then((value) {
        if (value == true) {
          _setExifSupport(true);
        }
      });
    } else {
      _setExifSupport(false);
    }
  }

  Future<void> _onExifWifiOnlyChanged(bool value) async {
    _log.info("[_onExifWifiOnlyChanged] New value: $value");
    final oldValue = _shouldProcessExifWifiOnly;
    setState(() {
      _shouldProcessExifWifiOnly = value;
    });
    if (!await Pref().setProcessExifWifiOnly(value)) {
      _log.severe("[_onExifWifiOnlyChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _shouldProcessExifWifiOnly = oldValue;
      });
    } else {
      // this is not very important since the config will be synced during
      // service startup
      ServiceConfig.setProcessExifWifiOnly(value).ignore();
    }
  }

  Future<void> _onCaptureLogChanged(BuildContext context, bool value) async {
    if (value) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
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
      _log.shout("[_onLogSaveSuccessful] Failed showing platform notification",
          e, stacktrace);
    }
  }

  void _onPrefUpdated(PrefUpdatedEvent ev) {
    if (ev.key == PrefKey.isPhotosTabSortByName) {
      setState(() {});
    }
  }

  Future<void> _setExifSupport(bool value) async {
    final oldValue = _isEnableExif;
    setState(() {
      _isEnableExif = value;
    });
    if (!await Pref().setEnableExif(value)) {
      _log.severe("[_setExifSupport] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isEnableExif = oldValue;
      });
    }
  }

  late bool _isEnableExif;
  late bool _shouldProcessExifWifiOnly;

  var _devSettingsUnlockCount = 3;
  var _isShowDevSettings = false;

  late final _prefUpdatedListener =
      AppEventListener<PrefUpdatedEvent>(_onPrefUpdated);

  static final _log = Logger("widget.settings._SettingsState");

  static const String _sourceRepo = "https://bit.ly/3LQerBv";
  static const String _bugReportUrl = "https://bit.ly/3NANrr7";
  static const String _translationUrl = "https://bit.ly/3NwmdSw";
}

class AccountSettingsWidgetArguments {
  const AccountSettingsWidgetArguments(this.account);

  final Account account;
}

class AccountSettingsWidget extends StatefulWidget {
  static const routeName = "/account-settings";

  static Route buildRoute(AccountSettingsWidgetArguments args) =>
      MaterialPageRoute(
        builder: (context) => AccountSettingsWidget.fromArgs(args),
      );

  const AccountSettingsWidget({
    Key? key,
    required this.account,
  }) : super(key: key);

  AccountSettingsWidget.fromArgs(AccountSettingsWidgetArguments args,
      {Key? key})
      : this(
          key: key,
          account: args.account,
        );

  @override
  createState() => _AccountSettingsState();

  final Account account;
}

class _AccountSettingsState extends State<AccountSettingsWidget> {
  @override
  initState() {
    super.initState();
    _account = widget.account;

    final settings = AccountPref.of(_account);
    _isEnableFaceRecognitionApp = settings.isEnableFaceRecognitionAppOr();
    _shareFolder = settings.getShareFolderOr();
    _label = settings.getAccountLabel();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_shouldReload,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(L10n.global().settingsAccountTitle),
            leading: _shouldReload
                ? IconButton(
                    icon: const Icon(Icons.check),
                    tooltip: L10n.global().doneButtonTooltip,
                    onPressed: () => _onDonePressed(context),
                  )
                : null,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  title: Text(L10n.global().settingsAccountLabelTitle),
                  subtitle: Text(
                      _label ?? L10n.global().settingsAccountLabelDescription),
                  onTap: () => _onLabelPressed(context),
                ),
                ListTile(
                  title: Text(L10n.global().settingsIncludedFoldersTitle),
                  subtitle: Text(_account.roots.map((e) => "/$e").join("; ")),
                  onTap: _onIncludedFoldersPressed,
                ),
                ListTile(
                  title: Text(L10n.global().settingsShareFolderTitle),
                  subtitle: Text("/$_shareFolder"),
                  onTap: () => _onShareFolderPressed(context),
                ),
                _buildCaption(
                    context, L10n.global().settingsServerAppSectionTitle),
                SwitchListTile(
                  title: const Text("Face Recognition"),
                  value: _isEnableFaceRecognitionApp,
                  onChanged: _onEnableFaceRecognitionAppChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDonePressed(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Home.routeName,
      (route) => false,
      arguments: HomeArguments(_account),
    );
  }

  Future<void> _onLabelPressed(BuildContext context) async {
    final result = await showDialog<String>(
        context: context,
        builder: (context) => SimpleInputDialog(
              titleText: L10n.global().settingsAccountLabelTitle,
              buttonText: MaterialLocalizations.of(context).okButtonLabel,
              initialText: _label ?? "",
            ));
    if (result == null) {
      return;
    }
    if (result.isEmpty) {
      return _setLabel(null);
    } else {
      return _setLabel(result);
    }
  }

  Future<void> _onIncludedFoldersPressed() async {
    try {
      final result = await Navigator.of(context).pushNamed<Account>(
          RootPicker.routeName,
          arguments: RootPickerArguments(_account));
      if (result == null) {
        // user canceled
        return;
      }
      // we've got a good account
      if (result == _account) {
        // no changes, do nothing
        _log.fine("[_onIncludedFoldersPressed] No changes");
        return;
      }
      final accounts = Pref().getAccounts3()!;
      if (accounts.contains(result)) {
        // conflict with another account. This normally won't happen because
        // the app passwords are unique to each entry, but just in case
        Navigator.of(context).pop();
        SnackBarManager().showSnackBar(SnackBar(
          content: Text(L10n.global().editAccountConflictFailureNotification),
          duration: k.snackBarDurationNormal,
        ));
        return;
      }

      final index = accounts.indexOf(_account);
      if (index < 0) {
        _log.shout("[_onIncludedFoldersPressed] Account not found: $_account");
        SnackBarManager().showSnackBar(SnackBar(
          content: Text(L10n.global().writePreferenceFailureNotification),
          duration: k.snackBarDurationNormal,
        ));
        return;
      }

      accounts[index] = result;
      if (!await Pref().setAccounts3(accounts)) {
        SnackBarManager().showSnackBar(SnackBar(
          content: Text(L10n.global().writePreferenceFailureNotification),
          duration: k.snackBarDurationNormal,
        ));
        return;
      }
      setState(() {
        _account = result;
        _shouldReload = true;
      });
    } catch (e, stackTrace) {
      _log.shout("[_onIncludedFoldersPressed] Exception", e, stackTrace);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(e)),
        duration: k.snackBarDurationNormal,
      ));
    }
  }

  Future<void> _onShareFolderPressed(BuildContext context) async {
    final path = await showDialog<String>(
      context: context,
      builder: (_) => _ShareFolderDialog(
        account: widget.account,
        initialValue: _shareFolder,
      ),
    );
    if (path == null || path == _shareFolder) {
      return;
    }
    return _setShareFolder(path);
  }

  Future<void> _onEnableFaceRecognitionAppChanged(bool value) async {
    _log.info("[_onEnableFaceRecognitionAppChanged] New value: $value");
    final oldValue = _isEnableFaceRecognitionApp;
    setState(() {
      _isEnableFaceRecognitionApp = value;
    });
    if (!await AccountPref.of(_account).setEnableFaceRecognitionApp(value)) {
      _log.severe("[_onEnableFaceRecognitionAppChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isEnableFaceRecognitionApp = oldValue;
      });
    }
  }

  Future<void> _setLabel(String? value) async {
    _log.info("[_setLabel] New value: $value");
    final oldValue = _label;
    setState(() {
      _label = value;
    });
    if (!await AccountPref.of(_account).setAccountLabel(value)) {
      _log.severe("[_setLabel] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _label = oldValue;
      });
    }
  }

  Future<void> _setShareFolder(String value) async {
    _log.info("[_setShareFolder] New value: $value");
    final oldValue = _shareFolder;
    setState(() {
      _shareFolder = value;
    });
    if (!await AccountPref.of(_account).setShareFolder(value)) {
      _log.severe("[_setShareFolder] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _shareFolder = oldValue;
      });
    }
  }

  bool _shouldReload = false;
  late Account _account;
  late bool _isEnableFaceRecognitionApp;
  late String _shareFolder;
  late String? _label;

  static final _log = Logger("widget.settings._AccountSettingsState");
}

class _ShareFolderDialog extends StatefulWidget {
  const _ShareFolderDialog({
    Key? key,
    required this.account,
    required this.initialValue,
  }) : super(key: key);

  @override
  createState() => _ShareFolderDialogState();

  final Account account;
  final String initialValue;
}

class _ShareFolderDialogState extends State<_ShareFolderDialog> {
  @override
  build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().settingsShareFolderDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.global().settingsShareFolderDialogDescription),
            const SizedBox(height: 8),
            InkWell(
              onTap: _onTextFieldPressed,
              child: TextFormField(
                enabled: false,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onOkPressed,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  Future<void> _onTextFieldPressed() async {
    final pick = await Navigator.of(context).pushNamed<String>(
        ShareFolderPicker.routeName,
        arguments: ShareFolderPickerArguments(widget.account, _path));
    if (pick != null) {
      _path = pick;
      _controller.text = "/$pick";
    }
  }

  void _onOkPressed() {
    Navigator.of(context).pop(_path);
  }

  final _formKey = GlobalKey<FormState>();
  late final _controller =
      TextEditingController(text: "/${widget.initialValue}");
  late String _path = widget.initialValue;
}

class _PhotosSettings extends StatefulWidget {
  const _PhotosSettings({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  createState() => _PhotosSettingsState();

  final Account account;
}

class _PhotosSettingsState extends State<_PhotosSettings> {
  @override
  initState() {
    super.initState();
    _memoriesRange = Pref().getMemoriesRangeOr();

    final settings = AccountPref.of(widget.account);
    _isEnableMemoryAlbum = settings.isEnableMemoryAlbumOr(true);
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().photosTabLabel),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SwitchListTile(
                title: Text(L10n.global().settingsMemoriesTitle),
                subtitle: Text(L10n.global().settingsMemoriesSubtitle),
                value: _isEnableMemoryAlbum,
                onChanged: Pref().isPhotosTabSortByNameOr()
                    ? null
                    : _onEnableMemoryAlbumChanged,
              ),
              ListTile(
                title: Text(L10n.global().settingsMemoriesRangeTitle),
                subtitle: Text(L10n.global()
                    .settingsMemoriesRangeValueText(_memoriesRange)),
                onTap: () => _onMemoriesRangeTap(context),
                enabled:
                    !Pref().isPhotosTabSortByNameOr() && _isEnableMemoryAlbum,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onMemoriesRangeTap(BuildContext context) async {
    var memoriesRange = _memoriesRange;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: _MemoriesRangeSlider(
          initialRange: _memoriesRange,
          onChanged: (value) {
            memoriesRange = value;
          },
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(L10n.global().applyButtonLabel),
          ),
        ],
      ),
    );
    if (result != true || memoriesRange == _memoriesRange) {
      return;
    }

    unawaited(_setMemoriesRange(memoriesRange));
  }

  Future<void> _onEnableMemoryAlbumChanged(bool value) async {
    _log.info("[_onEnableMemoryAlbumChanged] New value: $value");
    final oldValue = _isEnableMemoryAlbum;
    setState(() {
      _isEnableMemoryAlbum = value;
    });
    if (!await AccountPref.of(widget.account).setEnableMemoryAlbum(value)) {
      _log.severe("[_onEnableMemoryAlbumChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isEnableMemoryAlbum = oldValue;
      });
    }
  }

  Future<void> _setMemoriesRange(int value) async {
    _log.info("[_setMemoriesRange] New value: $value");
    final oldValue = _memoriesRange;
    setState(() {
      _memoriesRange = value;
    });
    if (!await Pref().setMemoriesRange(value)) {
      _log.severe("[_setMemoriesRange] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _memoriesRange = oldValue;
      });
    }
  }

  late bool _isEnableMemoryAlbum;
  late int _memoriesRange;

  static final _log = Logger("widget.settings._PhotosSettingsState");
}

class _MemoriesRangeSlider extends StatefulWidget {
  const _MemoriesRangeSlider({
    Key? key,
    required this.initialRange,
    this.onChanged,
  }) : super(key: key);

  @override
  createState() => _MemoriesRangeSliderState();

  final int initialRange;
  final ValueChanged<int>? onChanged;
}

class _MemoriesRangeSliderState extends State<_MemoriesRangeSlider> {
  @override
  initState() {
    super.initState();
    _memoriesRange = widget.initialRange;
  }

  @override
  build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
              L10n.global().settingsMemoriesRangeValueText(_memoriesRange)),
        ),
        StatefulSlider(
          initialValue: _memoriesRange.toDouble(),
          min: 0,
          max: 4,
          divisions: 4,
          onChangeEnd: (value) async {
            setState(() {
              _memoriesRange = value.toInt();
            });
            widget.onChanged?.call(_memoriesRange);
          },
        ),
      ],
    );
  }

  late int _memoriesRange;
}

class _ViewerSettings extends StatefulWidget {
  @override
  createState() => _ViewerSettingsState();
}

class _ViewerSettingsState extends State<_ViewerSettings> {
  @override
  initState() {
    super.initState();
    _screenBrightness = Pref().getViewerScreenBrightnessOr(-1);
    _isForceRotation = Pref().isViewerForceRotationOr(false);
    _gpsMapProvider = GpsMapProvider.values[Pref().getGpsMapProviderOr(0)];
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsViewerTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              if (platform_k.isMobile)
                SwitchListTile(
                  title: Text(L10n.global().settingsScreenBrightnessTitle),
                  subtitle:
                      Text(L10n.global().settingsScreenBrightnessDescription),
                  value: _screenBrightness >= 0,
                  onChanged: (value) =>
                      _onScreenBrightnessChanged(context, value),
                ),
              if (platform_k.isMobile)
                SwitchListTile(
                  title: Text(L10n.global().settingsForceRotationTitle),
                  subtitle:
                      Text(L10n.global().settingsForceRotationDescription),
                  value: _isForceRotation,
                  onChanged: (value) => _onForceRotationChanged(value),
                ),
              ListTile(
                title: Text(L10n.global().settingsMapProviderTitle),
                subtitle: Text(_gpsMapProvider.toUserString()),
                onTap: () => _onMapProviderTap(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onScreenBrightnessChanged(
      BuildContext context, bool value) async {
    if (value) {
      var brightness = 0.5;
      try {
        await ScreenBrightness().setScreenBrightness(brightness);
        final value = await showDialog<int>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(L10n.global().settingsScreenBrightnessTitle),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(L10n.global().settingsScreenBrightnessDescription),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(Icons.brightness_low),
                    Expanded(
                      child: StatefulSlider(
                        initialValue: brightness,
                        min: 0.01,
                        onChangeEnd: (value) async {
                          brightness = value;
                          try {
                            await ScreenBrightness().setScreenBrightness(value);
                          } catch (e, stackTrace) {
                            _log.severe("Failed while setScreenBrightness", e,
                                stackTrace);
                          }
                        },
                      ),
                    ),
                    const Icon(Icons.brightness_high),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop((brightness * 100).round());
                },
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
              ),
            ],
          ),
        );

        if (value != null) {
          unawaited(_setScreenBrightness(value));
        }
      } finally {
        unawaited(ScreenBrightness().resetScreenBrightness());
      }
    } else {
      unawaited(_setScreenBrightness(-1));
    }
  }

  void _onForceRotationChanged(bool value) => _setForceRotation(value);

  Future<void> _onMapProviderTap(BuildContext context) async {
    final oldValue = _gpsMapProvider;
    final newValue = await showDialog<GpsMapProvider>(
      context: context,
      builder: (context) => FancyOptionPicker(
        items: GpsMapProvider.values
            .map((provider) => FancyOptionPickerItem(
                  label: provider.toUserString(),
                  isSelected: provider == oldValue,
                  onSelect: () {
                    _log.info(
                        "[_onMapProviderTap] Set map provider: ${provider.toUserString()}");
                    Navigator.of(context).pop(provider);
                  },
                ))
            .toList(),
      ),
    );
    if (newValue == null || newValue == oldValue) {
      return;
    }
    setState(() {
      _gpsMapProvider = newValue;
    });
    try {
      await Pref().setGpsMapProvider(newValue.index);
    } catch (e, stackTrace) {
      _log.severe("[_onMapProviderTap] Failed writing pref", e, stackTrace);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _gpsMapProvider = oldValue;
      });
    }
  }

  Future<void> _setScreenBrightness(int value) async {
    final oldValue = _screenBrightness;
    setState(() {
      _screenBrightness = value;
    });
    if (!await Pref().setViewerScreenBrightness(value)) {
      _log.severe("[_setScreenBrightness] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _screenBrightness = oldValue;
      });
    }
  }

  Future<void> _setForceRotation(bool value) async {
    final oldValue = _isForceRotation;
    setState(() {
      _isForceRotation = value;
    });
    if (!await Pref().setViewerForceRotation(value)) {
      _log.severe("[_setForceRotation] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isForceRotation = oldValue;
      });
    }
  }

  late int _screenBrightness;
  late bool _isForceRotation;
  late GpsMapProvider _gpsMapProvider;

  static final _log = Logger("widget.settings._ViewerSettingsState");
}

class _AlbumSettings extends StatefulWidget {
  @override
  createState() => _AlbumSettingsState();
}

class _AlbumSettingsState extends State<_AlbumSettings> {
  @override
  initState() {
    super.initState();
    _isBrowserShowDate = Pref().isAlbumBrowserShowDateOr();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsAlbumTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SwitchListTile(
                title: Text(L10n.global().settingsShowDateInAlbumTitle),
                subtitle:
                    Text(L10n.global().settingsShowDateInAlbumDescription),
                value: _isBrowserShowDate,
                onChanged: (value) => _onBrowserShowDateChanged(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onBrowserShowDateChanged(bool value) async {
    final oldValue = _isBrowserShowDate;
    setState(() {
      _isBrowserShowDate = value;
    });
    if (!await Pref().setAlbumBrowserShowDate(value)) {
      _log.severe("[_onBrowserShowDateChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isBrowserShowDate = oldValue;
      });
    }
  }

  late bool _isBrowserShowDate;

  static final _log = Logger("widget.settings._AlbumSettingsState");
}

class EnhancementSettings extends StatefulWidget {
  static const routeName = "/enhancement-settings";

  static Route buildRoute() => MaterialPageRoute(
        builder: (_) => const EnhancementSettings(),
      );

  const EnhancementSettings({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _EnhancementSettingsState();
}

class _EnhancementSettingsState extends State<EnhancementSettings> {
  @override
  initState() {
    super.initState();
    _maxWidth = Pref().getEnhanceMaxWidthOr();
    _maxHeight = Pref().getEnhanceMaxHeightOr();
    _isSaveEditResultToServer = Pref().isSaveEditResultToServerOr();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsImageEditTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SwitchListTile(
                title: Text(
                    L10n.global().settingsImageEditSaveResultsToServerTitle),
                subtitle: Text(_isSaveEditResultToServer
                    ? L10n.global()
                        .settingsImageEditSaveResultsToServerTrueDescription
                    : L10n.global()
                        .settingsImageEditSaveResultsToServerFalseDescription),
                value: _isSaveEditResultToServer,
                onChanged: _onSaveEditResultToServerChanged,
              ),
              ListTile(
                title: Text(L10n.global().settingsEnhanceMaxResolutionTitle2),
                subtitle: Text("${_maxWidth}x$_maxHeight"),
                onTap: () => _onMaxResolutionTap(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onMaxResolutionTap(BuildContext context) async {
    var width = _maxWidth;
    var height = _maxHeight;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(L10n.global().settingsEnhanceMaxResolutionTitle2),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.global().settingsEnhanceMaxResolutionDescription),
            const SizedBox(height: 16),
            _EnhanceResolutionSlider(
              initialWidth: _maxWidth,
              initialHeight: _maxHeight,
              onChanged: (value) {
                width = value.item1;
                height = value.item2;
              },
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (result != true || (width == _maxWidth && height == _maxHeight)) {
      return;
    }

    unawaited(_setMaxResolution(width, height));
  }

  Future<void> _setMaxResolution(int width, int height) async {
    _log.info(
        "[_setMaxResolution] ${_maxWidth}x$_maxHeight -> ${width}x$height");
    final oldWidth = _maxWidth;
    final oldHeight = _maxHeight;
    setState(() {
      _maxWidth = width;
      _maxHeight = height;
    });
    if (!await Pref().setEnhanceMaxWidth(width) ||
        !await Pref().setEnhanceMaxHeight(height)) {
      _log.severe("[_setMaxResolution] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      await Pref().setEnhanceMaxWidth(oldWidth);
      setState(() {
        _maxWidth = oldWidth;
        _maxHeight = oldHeight;
      });
    }
  }

  Future<void> _onSaveEditResultToServerChanged(bool value) async {
    final oldValue = _isSaveEditResultToServer;
    setState(() {
      _isSaveEditResultToServer = value;
    });
    if (!await Pref().setSaveEditResultToServer(value)) {
      _log.severe("[_onSaveEditResultToServerChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isSaveEditResultToServer = oldValue;
      });
    }
  }

  late int _maxWidth;
  late int _maxHeight;
  late bool _isSaveEditResultToServer;

  static final _log = Logger("widget.settings._EnhancementSettingsState");
}

class _EnhanceResolutionSlider extends StatefulWidget {
  const _EnhanceResolutionSlider({
    Key? key,
    required this.initialWidth,
    required this.initialHeight,
    this.onChanged,
  }) : super(key: key);

  @override
  createState() => _EnhanceResolutionSliderState();

  final int initialWidth;
  final int initialHeight;
  final ValueChanged<Tuple2<int, int>>? onChanged;
}

class _EnhanceResolutionSliderState extends State<_EnhanceResolutionSlider> {
  @override
  initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;
  }

  @override
  build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text("${_width}x$_height"),
        ),
        StatefulSlider(
          initialValue: resolutionToSliderValue(_width).toDouble(),
          min: -3,
          max: 3,
          divisions: 6,
          onChangeEnd: (value) async {
            final resolution = sliderValueToResolution(value.toInt());
            setState(() {
              _width = resolution.item1;
              _height = resolution.item2;
            });
            widget.onChanged?.call(resolution);
          },
        ),
      ],
    );
  }

  static Tuple2<int, int> sliderValueToResolution(int value) {
    switch (value) {
      case -3:
        return const Tuple2(1024, 768);
      case -2:
        return const Tuple2(1280, 960);
      case -1:
        return const Tuple2(1600, 1200);
      case 1:
        return const Tuple2(2560, 1920);
      case 2:
        return const Tuple2(3200, 2400);
      case 3:
        return const Tuple2(4096, 3072);
      default:
        return const Tuple2(2048, 1536);
    }
  }

  static int resolutionToSliderValue(int width) {
    switch (width) {
      case 1024:
        return -3;
      case 1280:
        return -2;
      case 1600:
        return -1;
      case 2560:
        return 1;
      case 3200:
        return 2;
      case 4096:
        return 3;
      default:
        return 0;
    }
  }

  late int _width;
  late int _height;
}

class _ThemeSettings extends StatefulWidget {
  @override
  createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<_ThemeSettings> {
  @override
  initState() {
    super.initState();
    _isFollowSystemTheme = Pref().isFollowSystemThemeOr(false);
    _isUseBlackInDarkTheme = Pref().isUseBlackInDarkThemeOr(false);
    _seedColor = getSeedColor();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsThemeTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ListTile(
                title: Text(L10n.global().settingsSeedColorTitle),
                trailing: Icon(
                  Icons.circle,
                  size: 32,
                  color: _seedColor,
                ),
                onTap: () => _onSeedColorPressed(context),
              ),
              if (platform_k.isAndroid &&
                  AndroidInfo().sdkInt >= AndroidVersion.Q)
                SwitchListTile(
                  title: Text(L10n.global().settingsFollowSystemThemeTitle),
                  value: _isFollowSystemTheme,
                  onChanged: (value) => _onFollowSystemThemeChanged(value),
                ),
              SwitchListTile(
                title: Text(L10n.global().settingsUseBlackInDarkThemeTitle),
                subtitle: Text(_isUseBlackInDarkTheme
                    ? L10n.global().settingsUseBlackInDarkThemeTrueDescription
                    : L10n.global()
                        .settingsUseBlackInDarkThemeFalseDescription),
                value: _isUseBlackInDarkTheme,
                onChanged: (value) =>
                    _onUseBlackInDarkThemeChanged(context, value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onFollowSystemThemeChanged(bool value) async {
    final oldValue = _isFollowSystemTheme;
    setState(() {
      _isFollowSystemTheme = value;
    });
    if (await Pref().setFollowSystemTheme(value)) {
      KiwiContainer().resolve<EventBus>().fire(ThemeChangedEvent());
    } else {
      _log.severe("[_onFollowSystemThemeChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isFollowSystemTheme = oldValue;
      });
    }
  }

  Future<void> _onUseBlackInDarkThemeChanged(
      BuildContext context, bool value) async {
    final oldValue = _isUseBlackInDarkTheme;
    setState(() {
      _isUseBlackInDarkTheme = value;
    });
    if (await Pref().setUseBlackInDarkTheme(value)) {
      if (Theme.of(context).brightness == Brightness.dark) {
        KiwiContainer().resolve<EventBus>().fire(ThemeChangedEvent());
      }
    } else {
      _log.severe("[_onUseBlackInDarkThemeChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isUseBlackInDarkTheme = oldValue;
      });
    }
  }

  Future<void> _onSeedColorPressed(BuildContext context) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (context) => const _SeedColorPicker(),
    );
    if (result == null) {
      return;
    }

    final oldValue = _seedColor;
    setState(() {
      _seedColor = result;
    });
    if (await Pref().setSeedColor(result.withAlpha(0xFF).value)) {
      KiwiContainer().resolve<EventBus>().fire(ThemeChangedEvent());
    } else {
      _log.severe("[_onSeedColorPressed] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _seedColor = oldValue;
      });
    }
  }

  late bool _isFollowSystemTheme;
  late bool _isUseBlackInDarkTheme;
  late Color _seedColor;

  static final _log = Logger("widget.settings._ThemeSettingsState");
}

class _SeedColorPicker extends StatefulWidget {
  const _SeedColorPicker();

  @override
  State<StatefulWidget> createState() => _SeedColorPickerState();
}

class _SeedColorPickerState extends State<_SeedColorPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().settingsSeedColorPickerTitle),
      content: Wrap(
        children: const [
          Color(0xFFF44336),
          Color(0xFF9C27B0),
          Color(0xFF2196F3),
          Color(0xFF4CAF50),
          Color(0xFFFFC107),
        ]
            .map((c) => _SeedColorPickerItem(
                  seedColor: c,
                  onSelected: () => _onItemSelected(context, c),
                ))
            .toList(),
      ),
    );
  }

  void _onItemSelected(BuildContext context, Color seedColor) {
    Navigator.of(context).pop(seedColor);
  }
}

class _SeedColorPickerItem extends StatelessWidget {
  const _SeedColorPickerItem({
    required this.seedColor,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final content = SizedBox.square(
      dimension: _size,
      child: Center(
        child: Icon(
          Icons.circle,
          size: _size - _size * .1,
          color: seedColor,
        ),
      ),
    );
    if (onSelected != null) {
      return InkWell(
        customBorder: const CircleBorder(),
        onTap: onSelected,
        child: content,
      );
    } else {
      return content;
    }
  }

  final Color seedColor;
  final VoidCallback? onSelected;

  static const _size = 56.0;
}

class _MiscSettings extends StatefulWidget {
  const _MiscSettings({Key? key}) : super(key: key);

  @override
  createState() => _MiscSettingsState();
}

class _MiscSettingsState extends State<_MiscSettings> {
  @override
  initState() {
    super.initState();
    _isPhotosTabSortByName = Pref().isPhotosTabSortByNameOr();
    _isDoubleTapExit = Pref().isDoubleTapExitOr();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsMiscellaneousTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SwitchListTile(
                title: Text(L10n.global().settingsDoubleTapExitTitle),
                value: _isDoubleTapExit,
                onChanged: (value) => _onDoubleTapExitChanged(value),
              ),
              SwitchListTile(
                title: Text(L10n.global().settingsPhotosTabSortByNameTitle),
                value: _isPhotosTabSortByName,
                onChanged: (value) => _onPhotosTabSortByNameChanged(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onDoubleTapExitChanged(bool value) async {
    final oldValue = _isDoubleTapExit;
    setState(() {
      _isDoubleTapExit = value;
    });
    if (!await Pref().setDoubleTapExit(value)) {
      _log.severe("[_onDoubleTapExitChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isDoubleTapExit = oldValue;
      });
    }
  }

  Future<void> _onPhotosTabSortByNameChanged(bool value) async {
    final oldValue = _isPhotosTabSortByName;
    setState(() {
      _isPhotosTabSortByName = value;
    });
    if (!await Pref().setPhotosTabSortByName(value)) {
      _log.severe("[_onPhotosTabSortByNameChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isPhotosTabSortByName = oldValue;
      });
    }
  }

  late bool _isPhotosTabSortByName;
  late bool _isDoubleTapExit;

  static final _log = Logger("widget.settings._MiscSettingsState");
}

class _ExperimentalSettings extends StatefulWidget {
  @override
  createState() => _ExperimentalSettingsState();
}

class _ExperimentalSettingsState extends State<_ExperimentalSettings> {
  @override
  initState() {
    super.initState();
    _isEnableSharedAlbum = Pref().isLabEnableSharedAlbumOr(false);
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(L10n.global().settingsExperimentalTitle),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              if (_enabledExperiments.contains(_Experiment.sharedAlbum))
                SwitchListTile(
                  title: const Text("Shared album"),
                  subtitle:
                      const Text("Share albums with users on the same server"),
                  value: _isEnableSharedAlbum,
                  onChanged: (value) => _onEnableSharedAlbumChanged(value),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onEnableSharedAlbumChanged(bool value) async {
    final oldValue = _isEnableSharedAlbum;
    setState(() {
      _isEnableSharedAlbum = value;
    });
    if (!await Pref().setLabEnableSharedAlbum(value)) {
      _log.severe("[_onEnableSharedAlbumChanged] Failed writing pref");
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().writePreferenceFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
      setState(() {
        _isEnableSharedAlbum = oldValue;
      });
    }
  }

  late bool _isEnableSharedAlbum;

  static final _log = Logger("widget.settings._ExperimentalSettingsState");
}

class _DevSettings extends StatefulWidget {
  @override
  createState() => _DevSettingsState();
}

class _DevSettingsState extends State<_DevSettings> {
  @override
  build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text("Developer options"),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ListTile(
                title: const Text("Clear cache database"),
                onTap: () => _clearCacheDb(),
              ),
              ListTile(
                title: const Text("SQL:VACUUM"),
                onTap: () => _runSqlVacuum(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _clearCacheDb() async {
    try {
      final c = KiwiContainer().resolve<DiContainer>();
      await c.sqliteDb.use((db) async {
        await db.truncate();
        final accounts = Pref().getAccounts3Or([]);
        for (final a in accounts) {
          await db.insertAccountOf(a);
        }
      });
      SnackBarManager().showSnackBar(const SnackBar(
        content: Text("Database cleared"),
        duration: k.snackBarDurationShort,
      ));
    } catch (e, stackTrace) {
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(e)),
        duration: k.snackBarDurationNormal,
      ));
      _log.shout("[_clearCacheDb] Uncaught exception", e, stackTrace);
    }
  }

  Future<void> _runSqlVacuum() async {
    try {
      final c = KiwiContainer().resolve<DiContainer>();
      await c.sqliteDb.useNoTransaction((db) async {
        await db.customStatement("VACUUM;");
      });
      SnackBarManager().showSnackBar(const SnackBar(
        content: Text("Finished successfully"),
        duration: k.snackBarDurationShort,
      ));
    } catch (e, stackTrace) {
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(e)),
        duration: k.snackBarDurationNormal,
      ));
      _log.shout("[_runSqlVacuum] Uncaught exception", e, stackTrace);
    }
  }

  static final _log = Logger("widget.settings._DevSettingsState");
}

Widget _buildCaption(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      label,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    ),
  );
}

enum _Experiment {
  sharedAlbum,
}

final _enabledExperiments = [
  _Experiment.sharedAlbum,
];
