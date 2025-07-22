part of '../pref.dart';

extension PrefExtension on Pref {
  List<Account>? getAccounts3() {
    final jsonObjs = provider.getStringList(PrefKey.accounts3);
    return jsonObjs
        ?.map((e) => Account.fromJson(
              jsonDecode(e),
              upgraderV1: const AccountUpgraderV1(),
            ))
        .where((e) {
          if (e == null) {
            _log.shout("[getAccounts3] Failed upgrading account");
          }
          return true;
        })
        .nonNulls
        .toList();
  }

  List<Account> getAccounts3Or(List<Account> def) => getAccounts3() ?? def;

  int? getHomePhotosZoomLevel() => provider.getInt(PrefKey.homePhotosZoomLevel);
  int getHomePhotosZoomLevelOr(int def) => getHomePhotosZoomLevel() ?? def;
  Future<bool> setHomePhotosZoomLevel(int value) => _set<int>(
      PrefKey.homePhotosZoomLevel,
      value,
      (key, value) => provider.setInt(key, value));

  int? getAlbumBrowserZoomLevel() =>
      provider.getInt(PrefKey.albumBrowserZoomLevel);
  int getAlbumBrowserZoomLevelOr(int def) => getAlbumBrowserZoomLevel() ?? def;
  Future<bool> setAlbumBrowserZoomLevel(int value) => _set<int>(
      PrefKey.albumBrowserZoomLevel,
      value,
      (key, value) => provider.setInt(key, value));

  bool? isEnableExif() => provider.getBool(PrefKey.enableExif);
  bool isEnableExifOr([bool def = true]) => isEnableExif() ?? def;
  Future<bool> setEnableExif(bool value) => _set<bool>(
      PrefKey.enableExif, value, (key, value) => provider.setBool(key, value));

  int? getViewerScreenBrightness() =>
      provider.getInt(PrefKey.viewerScreenBrightness);
  int getViewerScreenBrightnessOr([int def = -1]) =>
      getViewerScreenBrightness() ?? def;
  Future<bool> setViewerScreenBrightness(int value) => _set<int>(
      PrefKey.viewerScreenBrightness,
      value,
      (key, value) => provider.setInt(key, value));

  bool? isViewerForceRotation() =>
      provider.getBool(PrefKey.viewerForceRotation);
  bool isViewerForceRotationOr([bool def = false]) =>
      isViewerForceRotation() ?? def;
  Future<bool> setViewerForceRotation(bool value) => _set<bool>(
      PrefKey.viewerForceRotation,
      value,
      (key, value) => provider.setBool(key, value));

  int? getSetupProgress() => provider.getInt(PrefKey.setupProgress);
  int getSetupProgressOr([int def = 0]) => getSetupProgress() ?? def;
  Future<bool> setSetupProgress(int value) => _set<int>(PrefKey.setupProgress,
      value, (key, value) => provider.setInt(key, value));

  /// Return the version number when the app last ran
  int? getLastVersion() => provider.getInt(PrefKey.lastVersion);
  int getLastVersionOr(int def) => getLastVersion() ?? def;
  Future<bool> setLastVersion(int value) => _set<int>(
      PrefKey.lastVersion, value, (key, value) => provider.setInt(key, value));

  int? getLanguage() => provider.getInt(PrefKey.language);
  int getLanguageOr(int def) => getLanguage() ?? def;
  Future<bool> setLanguage(int value) => _set<int>(
      PrefKey.language, value, (key, value) => provider.setInt(key, value));

  bool? isAlbumBrowserShowDate() =>
      provider.getBool(PrefKey.isAlbumBrowserShowDate);
  bool isAlbumBrowserShowDateOr([bool def = false]) =>
      isAlbumBrowserShowDate() ?? def;
  Future<bool> setAlbumBrowserShowDate(bool value) => _set<bool>(
      PrefKey.isAlbumBrowserShowDate,
      value,
      (key, value) => provider.setBool(key, value));

  bool? hasShownSharedAlbumInfo() =>
      provider.getBool(PrefKey.hasShownSharedAlbumInfo);
  bool hasShownSharedAlbumInfoOr(bool def) => hasShownSharedAlbumInfo() ?? def;
  Future<bool> setHasShownSharedAlbumInfo(bool value) => _set<bool>(
      PrefKey.hasShownSharedAlbumInfo,
      value,
      (key, value) => provider.setBool(key, value));

  int? getEnhanceMaxWidth() => provider.getInt(PrefKey.enhanceMaxWidth);
  int getEnhanceMaxWidthOr([int def = 2048]) => getEnhanceMaxWidth() ?? def;
  Future<bool> setEnhanceMaxWidth(int value) => _set<int>(
      PrefKey.enhanceMaxWidth,
      value,
      (key, value) => provider.setInt(key, value));

  int? getEnhanceMaxHeight() => provider.getInt(PrefKey.enhanceMaxHeight);
  int getEnhanceMaxHeightOr([int def = 1536]) => getEnhanceMaxHeight() ?? def;
  Future<bool> setEnhanceMaxHeight(int value) => _set<int>(
      PrefKey.enhanceMaxHeight,
      value,
      (key, value) => provider.setInt(key, value));

  bool? hasShownEnhanceInfo() => provider.getBool(PrefKey.hasShownEnhanceInfo);
  bool hasShownEnhanceInfoOr([bool def = false]) =>
      hasShownEnhanceInfo() ?? def;
  Future<bool> setHasShownEnhanceInfo(bool value) => _set<bool>(
      PrefKey.hasShownEnhanceInfo,
      value,
      (key, value) => provider.setBool(key, value));

  bool? shouldProcessExifWifiOnly() =>
      provider.getBool(PrefKey.shouldProcessExifWifiOnly);
  bool shouldProcessExifWifiOnlyOr([bool def = true]) =>
      shouldProcessExifWifiOnly() ?? def;
  Future<bool> setProcessExifWifiOnly(bool value) => _set<bool>(
      PrefKey.shouldProcessExifWifiOnly,
      value,
      (key, value) => provider.setBool(key, value));

  bool? isDoubleTapExit() => provider.getBool(PrefKey.doubleTapExit);
  bool isDoubleTapExitOr([bool def = false]) => isDoubleTapExit() ?? def;
  Future<bool> setDoubleTapExit(bool value) => _set<bool>(PrefKey.doubleTapExit,
      value, (key, value) => provider.setBool(key, value));

  int? getMemoriesRange() => provider.getInt(PrefKey.memoriesRange);
  int getMemoriesRangeOr([int def = 2]) => getMemoriesRange() ?? def;
  Future<bool> setMemoriesRange(int value) => _set<int>(PrefKey.memoriesRange,
      value, (key, value) => provider.setInt(key, value));

  bool? isSaveEditResultToServer() =>
      provider.getBool(PrefKey.saveEditResultToServer);
  bool isSaveEditResultToServerOr([bool def = true]) =>
      isSaveEditResultToServer() ?? def;
  Future<bool> setSaveEditResultToServer(bool value) => _set<bool>(
      PrefKey.saveEditResultToServer,
      value,
      (key, value) => provider.setBool(key, value));

  bool? hasShownSaveEditResultDialog() =>
      provider.getBool(PrefKey.hasShownSaveEditResultDialog);
  bool hasShownSaveEditResultDialogOr([bool def = false]) =>
      hasShownSaveEditResultDialog() ?? def;
  Future<bool> setHasShownSaveEditResultDialog(bool value) => _set<bool>(
      PrefKey.hasShownSaveEditResultDialog,
      value,
      (key, value) => provider.setBool(key, value));

  bool? isVideoPlayerMute() => provider.getBool(PrefKey.isVideoPlayerMute);
  bool isVideoPlayerMuteOr([bool def = false]) => isVideoPlayerMute() ?? def;
  Future<bool> setVideoPlayerMute(bool value) => _set<bool>(
      PrefKey.isVideoPlayerMute,
      value,
      (key, value) => provider.setBool(key, value));

  bool? isVideoPlayerLoop() => provider.getBool(PrefKey.isVideoPlayerLoop);
  bool isVideoPlayerLoopOr([bool def = false]) => isVideoPlayerLoop() ?? def;
  Future<bool> setVideoPlayerLoop(bool value) => _set<bool>(
      PrefKey.isVideoPlayerLoop,
      value,
      (key, value) => provider.setBool(key, value));

  bool? isNewHttpEngine() => provider.getBool(PrefKey.isNewHttpEngine);
}

extension AccountPrefExtension on AccountPref {
  String? getShareFolder() => provider.getString(AccountPrefKey.shareFolder);
  String getShareFolderOr([String def = ""]) => getShareFolder() ?? def;
  Future<bool> setShareFolder(String value) => _set<String>(
      AccountPrefKey.shareFolder,
      value,
      (key, value) => provider.setString(key, value));

  Future<bool> setNewSharedAlbum(bool value) => _set<bool>(
      AccountPrefKey.hasNewSharedAlbum,
      value,
      (key, value) => provider.setBool(key, value));

  bool? isEnableMemoryAlbum() =>
      provider.getBool(AccountPrefKey.isEnableMemoryAlbum);
  bool isEnableMemoryAlbumOr([bool def = true]) => isEnableMemoryAlbum() ?? def;
  Future<bool> setEnableMemoryAlbum(bool value) => _set<bool>(
      AccountPrefKey.isEnableMemoryAlbum,
      value,
      (key, value) => provider.setBool(key, value));

  String? getTouchRootEtag() =>
      provider.getString(AccountPrefKey.touchRootEtag);
  String getTouchRootEtagOr([String def = ""]) => getTouchRootEtag() ?? def;
  Future<bool> setTouchRootEtag(String value) => _set<String>(
      AccountPrefKey.touchRootEtag,
      value,
      (key, value) => provider.setString(key, value));
  Future<bool> removeTouchRootEtag() => _remove(AccountPrefKey.touchRootEtag);

  String? getAccountLabel() => provider.getString(AccountPrefKey.accountLabel);
  String getAccountLabelOr([String def = ""]) => getAccountLabel() ?? def;
  Future<bool> setAccountLabel(String? value) {
    if (value == null) {
      return _remove(AccountPrefKey.accountLabel);
    } else {
      return _set<String>(AccountPrefKey.accountLabel, value,
          (key, value) => provider.setString(key, value));
    }
  }

  int? getLastNewCollectionType() =>
      provider.getInt(AccountPrefKey.lastNewCollectionType);
  int getLastNewCollectionTypeOr(int def) => getLastNewCollectionType() ?? def;
  Future<bool> setLastNewCollectionType(int? value) {
    if (value == null) {
      return _remove(AccountPrefKey.lastNewCollectionType);
    } else {
      return _set<int>(AccountPrefKey.lastNewCollectionType, value,
          (key, value) => provider.setInt(key, value));
    }
  }

  int? getPersonProvider() => provider.getInt(AccountPrefKey.personProvider);
  int getPersonProviderOr([int def = 1]) => getPersonProvider() ?? def;
  Future<bool> setPersonProvider(int value) => _set<int>(
      AccountPrefKey.personProvider,
      value,
      (key, value) => provider.setInt(key, value));
}
