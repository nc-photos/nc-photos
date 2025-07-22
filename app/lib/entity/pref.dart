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

  Future<bool> _set<T>(PrefKey key, T value,
          Future<bool> Function(PrefKey key, T value) setFn) =>
      setFn(key, value);

  final PrefProvider provider;

  static Pref? _inst;
}

class AccountPref {
  AccountPref.scoped(this.provider);

  static AccountPref of(Account account) {
    _insts.putIfAbsent(
        account.id, () => AccountPref.scoped(PrefMemoryProvider()));
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

  Future<bool> _set<T>(AccountPrefKey key, T value,
          Future<bool> Function(AccountPrefKey key, T value) setFn) =>
      setFn(key, value);

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
  ;

  @override
  String toStringKey() {
    switch (this) {
      case PrefKey.accounts3:
        return "accounts3";
      case PrefKey.currentAccountIndex:
        return "currentAccountIndex";
      case PrefKey.homePhotosZoomLevel:
        return "homePhotosZoomLevel";
      case PrefKey.albumBrowserZoomLevel:
        return "albumViewerZoomLevel";
      case PrefKey.homeAlbumsSort:
        return "homeAlbumsSort";
      case PrefKey.enableExif:
        return "isEnableExif";
      case PrefKey.viewerScreenBrightness:
        return "viewerScreenBrightness";
      case PrefKey.viewerForceRotation:
        return "viewerForceRotation";
      case PrefKey.setupProgress:
        return "setupProgress";
      case PrefKey.lastVersion:
        return "lastVersion";
      case PrefKey.darkTheme:
        return "isDarkTheme";
      case PrefKey.followSystemTheme:
        return "isFollowSystemTheme";
      case PrefKey.useBlackInDarkTheme:
        return "isUseBlackInDarkTheme";
      case PrefKey.language:
        return "language";
      case PrefKey.labEnableSharedAlbum:
        return "isLabEnableSharedAlbum";
      case PrefKey.slideshowDuration:
        return "slideshowDuration";
      case PrefKey.isSlideshowShuffle:
        return "isSlideshowShuffle";
      case PrefKey.isSlideshowRepeat:
        return "isSlideshowRepeat";
      case PrefKey.isAlbumBrowserShowDate:
        return "isAlbumBrowserShowDate";
      case PrefKey.gpsMapProvider:
        return "gpsMapProvider";
      case PrefKey.hasShownSharedAlbumInfo:
        return "hasShownSharedAlbumInfo";
      case PrefKey.enhanceMaxWidth:
        return "enhanceMaxWidth";
      case PrefKey.enhanceMaxHeight:
        return "enhanceMaxHeight";
      case PrefKey.hasShownEnhanceInfo:
        return "hasShownEnhanceInfo";
      case PrefKey.firstRunTime:
        return "firstRunTime";
      // ignore: deprecated_member_use_from_same_package
      case PrefKey.isPhotosTabSortByName:
        return "isPhotosTabSortByName";
      case PrefKey.shouldProcessExifWifiOnly:
        return "shouldProcessExifWifiOnly";
      case PrefKey.doubleTapExit:
        return "doubleTapExit";
      case PrefKey.memoriesRange:
        return "memoriesRange";
      case PrefKey.saveEditResultToServer:
        return "saveEditResultToServer";
      case PrefKey.hasShownSaveEditResultDialog:
        return "hasShownSaveEditResultDialog";
      case PrefKey.isSlideshowReverse:
        return "isSlideshowReverse";
      case PrefKey.seedColor:
        return "seedColor";
      case PrefKey.isVideoPlayerMute:
        return "isVideoPlayerMute";
      case PrefKey.isVideoPlayerLoop:
        return "isVideoPlayerLoop";
      case PrefKey.secondarySeedColor:
        return "secondarySeedColor";
      case PrefKey.protectedPageAuthType:
        return "protectedPageAuthType";
      case PrefKey.protectedPageAuthPin:
        return "protectedPageAuthPin";
      case PrefKey.protectedPageAuthPassword:
        return "protectedPageAuthPassword";
      case PrefKey.dontShowVideoPreviewHint:
        return "dontShowVideoPreviewHint";
      case PrefKey.mapBrowserPrevPosition:
        return "mapBrowserPrevPosition";
      case PrefKey.isNewHttpEngine:
        return "isNewHttpEngine";
      case PrefKey.mapDefaultRangeType:
        return "mapDefaultRangeType";
      case PrefKey.mapDefaultCustomRange:
        return "mapDefaultCustomRange";
      case PrefKey.viewerAppBarButtons:
        return "viewerAppBarButtons";
      case PrefKey.viewerBottomAppBarButtons:
        return "viewerBottomAppBarButtons";
      case PrefKey.homeCollectionsNavBarButtons:
        return "homeCollectionsNavBarButtons";
      case PrefKey.isFallbackClientExif:
        return "isFallbackClientExif";
    }
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
  ;

  @override
  String toStringKey() {
    switch (this) {
      case AccountPrefKey.shareFolder:
        return "shareFolder";
      case AccountPrefKey.hasNewSharedAlbum:
        return "hasNewSharedAlbum";
      case AccountPrefKey.isEnableMemoryAlbum:
        return "isEnableMemoryAlbum";
      case AccountPrefKey.touchRootEtag:
        return "touchRootEtag";
      case AccountPrefKey.accountLabel:
        return "accountLabel";
      case AccountPrefKey.lastNewCollectionType:
        return "lastNewCollectionType";
      case AccountPrefKey.personProvider:
        return "personProvider";
      case AccountPrefKey.serverStatus:
        return "serverStatus";
    }
  }
}

/// Provide the data for [Pref]
abstract class PrefProvider {
  bool? getBool(PrefKeyInterface key);
  Future<bool> setBool(PrefKeyInterface key, bool value);

  int? getInt(PrefKeyInterface key);
  Future<bool> setInt(PrefKeyInterface key, int value);

  String? getString(PrefKeyInterface key);
  Future<bool> setString(PrefKeyInterface key, String value);

  List<String>? getStringList(PrefKeyInterface key);
  Future<bool> setStringList(PrefKeyInterface key, List<String> value);

  List<int>? getIntList(PrefKeyInterface key);
  Future<bool> setIntList(PrefKeyInterface key, List<int> value);

  Future<bool> remove(PrefKeyInterface key);
  Future<bool> clear();
}
