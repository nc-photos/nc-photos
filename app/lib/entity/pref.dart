import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/pref/provider/memory.dart';
import 'package:np_log/np_log.dart';

part 'pref.g.dart';
part 'pref/extension.dart';

@npLog
class Pref {
  factory Pref() {
    _inst ??= Pref.scoped(PrefMemoryProvider());
    return _inst!;
  }

  Pref.scoped(this.provider);

  /// Set the global [Pref] instance returned by the default constructor
  static void setGlobalInstance(Pref pref) {
    assert(_inst == null);
    _inst = pref;
  }

  Future<bool> _set<T>(
    PrefKey key,
    T value,
    Future<bool> Function(PrefKey key, T value) setFn,
  ) => setFn(key, value);

  final PrefProvider provider;

  static Pref? _inst;
}

class AccountPref {
  AccountPref.scoped(this.provider);

  static AccountPref of(Account account) {
    _insts.putIfAbsent(
      account.id,
      () => AccountPref.scoped(PrefMemoryProvider()),
    );
    return _insts[account.id]!;
  }

  /// Set the global [AccountPref] instance returned by the default constructor
  static void setGlobalInstance(Account account, AccountPref? pref) {
    if (pref != null) {
      assert(!_insts.containsKey(account.id));
      _insts[account.id] = pref;
    } else {
      assert(_insts.containsKey(account.id));
      _insts.remove(account.id);
    }
  }

  Future<bool> _set<T>(
    AccountPrefKey key,
    T value,
    Future<bool> Function(AccountPrefKey key, T value) setFn,
  ) => setFn(key, value);

  Future<bool> _remove(AccountPrefKey key) => provider.remove(key);

  final PrefProvider provider;

  static final _insts = <String, AccountPref>{};
}

abstract class PrefKeyInterface {
  String toStringKey();
}

enum PrefKey implements PrefKeyInterface {
  accounts3,
  currentAccountIndex,
  homePhotosZoomLevel,
  albumBrowserZoomLevel,
  homeAlbumsSort,
  enableExif,
  viewerScreenBrightness,
  viewerForceRotation,
  setupProgress,
  lastVersion,
  darkTheme,
  followSystemTheme,
  useBlackInDarkTheme,
  language,
  labEnableSharedAlbum,
  slideshowDuration,
  isSlideshowShuffle,
  isSlideshowRepeat,
  isAlbumBrowserShowDate,
  gpsMapProvider,
  hasShownSharedAlbumInfo,
  enhanceMaxWidth,
  enhanceMaxHeight,
  hasShownEnhanceInfo,
  firstRunTime,
  @Deprecated("unused")
  isPhotosTabSortByName,
  shouldProcessExifWifiOnly,
  doubleTapExit,
  memoriesRange,
  saveEditResultToServer,
  hasShownSaveEditResultDialog,
  isSlideshowReverse,
  seedColor,
  isVideoPlayerMute,
  isVideoPlayerLoop,
  secondarySeedColor,
  protectedPageAuthType,
  protectedPageAuthPin,
  protectedPageAuthPassword,
  dontShowVideoPreviewHint,
  mapBrowserPrevPosition,
  isNewHttpEngine,
  mapDefaultRangeType,
  mapDefaultCustomRange,
  viewerAppBarButtons,
  viewerBottomAppBarButtons,
  homeCollectionsNavBarButtons,
  isFallbackClientExif,
  localDirs,
  isEnableUploadConvert,
  uploadConvertFormat,
  uploadConvertQuality,
  uploadConvertDownsizeMp,
  isShowUploadConvertWarning,
  isEnableLocalFile,
  lastAdRewardTime;

  @override
  String toStringKey() {
    return switch (this) {
      PrefKey.accounts3 => "accounts3",
      PrefKey.currentAccountIndex => "currentAccountIndex",
      PrefKey.homePhotosZoomLevel => "homePhotosZoomLevel",
      PrefKey.albumBrowserZoomLevel => "albumViewerZoomLevel",
      PrefKey.homeAlbumsSort => "homeAlbumsSort",
      PrefKey.enableExif => "isEnableExif",
      PrefKey.viewerScreenBrightness => "viewerScreenBrightness",
      PrefKey.viewerForceRotation => "viewerForceRotation",
      PrefKey.setupProgress => "setupProgress",
      PrefKey.lastVersion => "lastVersion",
      PrefKey.darkTheme => "isDarkTheme",
      PrefKey.followSystemTheme => "isFollowSystemTheme",
      PrefKey.useBlackInDarkTheme => "isUseBlackInDarkTheme",
      PrefKey.language => "language",
      PrefKey.labEnableSharedAlbum => "isLabEnableSharedAlbum",
      PrefKey.slideshowDuration => "slideshowDuration",
      PrefKey.isSlideshowShuffle => "isSlideshowShuffle",
      PrefKey.isSlideshowRepeat => "isSlideshowRepeat",
      PrefKey.isAlbumBrowserShowDate => "isAlbumBrowserShowDate",
      PrefKey.gpsMapProvider => "gpsMapProvider",
      PrefKey.hasShownSharedAlbumInfo => "hasShownSharedAlbumInfo",
      PrefKey.enhanceMaxWidth => "enhanceMaxWidth",
      PrefKey.enhanceMaxHeight => "enhanceMaxHeight",
      PrefKey.hasShownEnhanceInfo => "hasShownEnhanceInfo",
      PrefKey.firstRunTime => "firstRunTime",
      // ignore: deprecated_member_use_from_same_package
      PrefKey.isPhotosTabSortByName => "isPhotosTabSortByName",
      PrefKey.shouldProcessExifWifiOnly => "shouldProcessExifWifiOnly",
      PrefKey.doubleTapExit => "doubleTapExit",
      PrefKey.memoriesRange => "memoriesRange",
      PrefKey.saveEditResultToServer => "saveEditResultToServer",
      PrefKey.hasShownSaveEditResultDialog => "hasShownSaveEditResultDialog",
      PrefKey.isSlideshowReverse => "isSlideshowReverse",
      PrefKey.seedColor => "seedColor",
      PrefKey.isVideoPlayerMute => "isVideoPlayerMute",
      PrefKey.isVideoPlayerLoop => "isVideoPlayerLoop",
      PrefKey.secondarySeedColor => "secondarySeedColor",
      PrefKey.protectedPageAuthType => "protectedPageAuthType",
      PrefKey.protectedPageAuthPin => "protectedPageAuthPin",
      PrefKey.protectedPageAuthPassword => "protectedPageAuthPassword",
      PrefKey.dontShowVideoPreviewHint => "dontShowVideoPreviewHint",
      PrefKey.mapBrowserPrevPosition => "mapBrowserPrevPosition",
      PrefKey.isNewHttpEngine => "isNewHttpEngine",
      PrefKey.mapDefaultRangeType => "mapDefaultRangeType",
      PrefKey.mapDefaultCustomRange => "mapDefaultCustomRange",
      PrefKey.viewerAppBarButtons => "viewerAppBarButtons",
      PrefKey.viewerBottomAppBarButtons => "viewerBottomAppBarButtons",
      PrefKey.homeCollectionsNavBarButtons => "homeCollectionsNavBarButtons",
      PrefKey.isFallbackClientExif => "isFallbackClientExif",
      PrefKey.localDirs => "localDirs",
      PrefKey.isEnableUploadConvert => "isEnableUploadConvert",
      PrefKey.uploadConvertFormat => "uploadConvertFormat",
      PrefKey.uploadConvertQuality => "uploadConvertQuality",
      PrefKey.uploadConvertDownsizeMp => "uploadConvertDownsizeMp",
      PrefKey.isShowUploadConvertWarning => "isShowUploadConvertWarning",
      PrefKey.isEnableLocalFile => "isEnableLocalFile",
      PrefKey.lastAdRewardTime => "lastAdRewardTime",
    };
  }
}

enum AccountPrefKey implements PrefKeyInterface {
  shareFolder,
  hasNewSharedAlbum,
  isEnableMemoryAlbum,
  touchRootEtag,
  accountLabel,
  lastNewCollectionType,
  personProvider,
  serverStatus,
  uploadRelativePath;

  @override
  String toStringKey() {
    return switch (this) {
      AccountPrefKey.shareFolder => "shareFolder",
      AccountPrefKey.hasNewSharedAlbum => "hasNewSharedAlbum",
      AccountPrefKey.isEnableMemoryAlbum => "isEnableMemoryAlbum",
      AccountPrefKey.touchRootEtag => "touchRootEtag",
      AccountPrefKey.accountLabel => "accountLabel",
      AccountPrefKey.lastNewCollectionType => "lastNewCollectionType",
      AccountPrefKey.personProvider => "personProvider",
      AccountPrefKey.serverStatus => "serverStatus",
      AccountPrefKey.uploadRelativePath => "uploadRelativePath",
    };
  }
}

/// Provide the data for [Pref]
abstract class PrefProvider {
  bool? getBool(PrefKeyInterface key);
  Future<bool> setBool(PrefKeyInterface key, bool value);

  int? getInt(PrefKeyInterface key);
  Future<bool> setInt(PrefKeyInterface key, int value);

  double? getDouble(PrefKeyInterface key);
  Future<bool> setDouble(PrefKeyInterface key, double value);

  String? getString(PrefKeyInterface key);
  Future<bool> setString(PrefKeyInterface key, String value);

  List<String>? getStringList(PrefKeyInterface key);
  Future<bool> setStringList(PrefKeyInterface key, List<String> value);

  List<int>? getIntList(PrefKeyInterface key);
  Future<bool> setIntList(PrefKeyInterface key, List<int> value);

  Future<bool> remove(PrefKeyInterface key);
  Future<bool> clear();
}
