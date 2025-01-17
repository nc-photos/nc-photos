// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/json_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/language_util.dart';
import 'package:nc_photos/protected_page_handler.dart';
import 'package:nc_photos/size.dart';
import 'package:nc_photos/widget/home_collections.dart';
import 'package:nc_photos/widget/viewer.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/type.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:rxdart/rxdart.dart';

part 'pref_controller.g.dart';
part 'pref_controller/type.dart';
part 'pref_controller/util.dart';

@npSubjectAccessor
class PrefController {
  PrefController(this.pref);

  Future<bool> setAccounts(List<Account>? value) => _setOrRemove<List<Account>>(
        controller: _accountsController,
        setter: (pref, value) => pref.setAccounts3(value),
        remover: (pref) => pref.setAccounts3(null),
        value: value,
        defaultValue: _accountsDefault,
      );

  Future<bool> setCurrentAccountIndex(int? value) => _setOrRemove<int>(
        controller: _currentAccountIndexController,
        setter: (pref, value) => pref.setCurrentAccountIndex(value),
        remover: (pref) => pref.setCurrentAccountIndex(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setAppLanguage(AppLanguage value) => _set<AppLanguage>(
        controller: _languageController,
        setter: (pref, value) => pref.setLanguage(value.langId),
        value: value,
      );

  Future<bool> setHomePhotosZoomLevel(int value) => _set<int>(
        controller: _homePhotosZoomLevelController,
        setter: (pref, value) => pref.setHomePhotosZoomLevel(value),
        value: value,
      );

  Future<bool> setAlbumBrowserZoomLevel(int value) => _set<int>(
        controller: _albumBrowserZoomLevelController,
        setter: (pref, value) => pref.setAlbumBrowserZoomLevel(value),
        value: value,
      );

  Future<bool> setHomeAlbumsSort(CollectionSort value) => _set<CollectionSort>(
        controller: _homeAlbumsSortController,
        setter: (pref, value) => pref.setHomeAlbumsSort(value.index),
        value: value,
      );

  Future<bool> setEnableClientExif(bool value) => _set<bool>(
        controller: _isEnableClientExifController,
        setter: (pref, value) => pref.setEnableClientExif(value),
        value: value,
      );

  Future<bool> setProcessExifWifiOnly(bool value) => _set<bool>(
        controller: _shouldProcessExifWifiOnlyController,
        setter: (pref, value) => pref.setProcessExifWifiOnly(value),
        value: value,
      );

  Future<bool> setMemoriesRange(int value) => _set<int>(
        controller: _memoriesRangeController,
        setter: (pref, value) => pref.setMemoriesRange(value),
        value: value,
      );

  Future<bool> setViewerScreenBrightness(int value) => _set<int>(
        controller: _viewerScreenBrightnessController,
        setter: (pref, value) => pref.setViewerScreenBrightness(value),
        value: value,
      );

  Future<bool> setViewerForceRotation(bool value) => _set<bool>(
        controller: _isViewerForceRotationController,
        setter: (pref, value) => pref.setViewerForceRotation(value),
        value: value,
      );

  Future<bool> setGpsMapProvider(GpsMapProvider value) => _set<GpsMapProvider>(
        controller: _gpsMapProviderController,
        setter: (pref, value) => pref.setGpsMapProvider(value.index),
        value: value,
      );

  Future<bool> setAlbumBrowserShowDate(bool value) => _set<bool>(
        controller: _isAlbumBrowserShowDateController,
        setter: (pref, value) => pref.setAlbumBrowserShowDate(value),
        value: value,
      );

  Future<bool> setDoubleTapExit(bool value) => _set<bool>(
        controller: _isDoubleTapExitController,
        setter: (pref, value) => pref.setDoubleTapExit(value),
        value: value,
      );

  Future<bool> setSaveEditResultToServer(bool value) => _set<bool>(
        controller: _isSaveEditResultToServerController,
        setter: (pref, value) => pref.setSaveEditResultToServer(value),
        value: value,
      );

  Future<bool> setEnhanceMaxSize(SizeInt value) => _set<SizeInt>(
        controller: _enhanceMaxSizeController,
        setter: (pref, value) async {
          return (await Future.wait([
            pref.setEnhanceMaxWidth(value.width),
            pref.setEnhanceMaxHeight(value.height),
          ]))
              .reduce((a, b) => a && b);
        },
        value: value,
      );

  Future<bool> setDarkTheme(bool value) => _set<bool>(
        controller: _isDarkThemeController,
        setter: (pref, value) => pref.setDarkTheme(value),
        value: value,
      );

  Future<bool> setFollowSystemTheme(bool value) => _set<bool>(
        controller: _isFollowSystemThemeController,
        setter: (pref, value) => pref.setFollowSystemTheme(value),
        value: value,
      );

  Future<bool> setUseBlackInDarkTheme(bool value) => _set<bool>(
        controller: _isUseBlackInDarkThemeController,
        setter: (pref, value) => pref.setUseBlackInDarkTheme(value),
        value: value,
      );

  Future<bool> setSeedColor(Color? value) => _setOrRemove<Color>(
        controller: _seedColorController,
        setter: (pref, value) => pref.setSeedColor(value.withAlpha(0xFF).value),
        remover: (pref) => pref.setSeedColor(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setSecondarySeedColor(Color? value) => _setOrRemove<Color>(
        controller: _secondarySeedColorController,
        setter: (pref, value) =>
            pref.setSecondarySeedColor(value.withAlpha(0xFF).value),
        remover: (pref) => pref.setSecondarySeedColor(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setDontShowVideoPreviewHint(bool value) => _set<bool>(
        controller: _isDontShowVideoPreviewHintController,
        setter: (pref, value) => pref.setDontShowVideoPreviewHint(value),
        value: value,
      );

  Future<bool> setMapBrowserPrevPosition(MapCoord? value) =>
      _setOrRemove<MapCoord>(
        controller: _mapBrowserPrevPositionController,
        setter: (pref, value) => pref.setMapBrowserPrevPosition(
            jsonEncode([value.latitude, value.longitude])),
        remover: (pref) => pref.setMapBrowserPrevPosition(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setNewHttpEngine(bool value) => _set<bool>(
        controller: _isNewHttpEngineController,
        setter: (pref, value) => pref.setNewHttpEngine(value),
        value: value,
      );

  Future<bool> setFirstRunTime(DateTime? value) => _setOrRemove<DateTime>(
        controller: _firstRunTimeController,
        setter: (pref, value) =>
            pref.setFirstRunTime(value.millisecondsSinceEpoch),
        remover: (pref) => pref.setFirstRunTime(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setLastVersion(int value) => _set<int>(
        controller: _lastVersionController,
        setter: (pref, value) => pref.setLastVersion(value),
        value: value,
      );

  Future<bool> setMapDefaultRangeType(PrefMapDefaultRangeType value) =>
      _set<PrefMapDefaultRangeType>(
        controller: _mapDefaultRangeTypeController,
        setter: (pref, value) => pref.setMapDefaultRangeType(value),
        value: value,
      );

  Future<bool> setMapDefaultCustomRange(Duration value) => _set<Duration>(
        controller: _mapDefaultCustomRangeController,
        setter: (pref, value) => pref.setMapDefaultCustomRange(value),
        value: value,
      );

  Future<bool> setSlideshowDuration(Duration value) => _set<Duration>(
        controller: _slideshowDurationController,
        setter: (pref, value) => pref.setSlideshowDuration(value),
        value: value,
      );

  Future<bool> setSlideshowShuffle(bool value) => _set<bool>(
        controller: _isSlideshowShuffleController,
        setter: (pref, value) => pref.setSlideshowShuffle(value),
        value: value,
      );

  Future<bool> setSlideshowRepeat(bool value) => _set<bool>(
        controller: _isSlideshowRepeatController,
        setter: (pref, value) => pref.setSlideshowRepeat(value),
        value: value,
      );

  Future<bool> setSlideshowReverse(bool value) => _set<bool>(
        controller: _isSlideshowReverseController,
        setter: (pref, value) => pref.setSlideshowReverse(value),
        value: value,
      );

  Future<bool> setViewerAppBarButtons(List<ViewerAppBarButtonType>? value) =>
      _setOrRemove<List<ViewerAppBarButtonType>>(
        controller: _viewerAppBarButtonsController,
        setter: (pref, value) => pref.setViewerAppBarButtons(value),
        remover: (pref) => pref.setViewerAppBarButtons(null),
        value: value,
        defaultValue: _viewerAppBarButtonsDefault,
      );

  Future<bool> setViewerBottomAppBarButtons(
          List<ViewerAppBarButtonType>? value) =>
      _setOrRemove<List<ViewerAppBarButtonType>>(
        controller: _viewerBottomAppBarButtonsController,
        setter: (pref, value) => pref.setViewerBottomAppBarButtons(value),
        remover: (pref) => pref.setViewerBottomAppBarButtons(null),
        value: value,
        defaultValue: _viewerBottomAppBarButtonsDefault,
      );

  Future<bool> setHomeCollectionsNavBarButtons(
          List<PrefHomeCollectionsNavButton>? value) =>
      _setOrRemove(
        controller: _homeCollectionsNavBarButtonsController,
        setter: (pref, value) => pref.setHomeCollectionsNavBarButtonsJson(
            jsonEncode(value.map((e) => e.toJson()).toList())),
        remover: (pref) => pref.setHomeCollectionsNavBarButtonsJson(null),
        value: value,
        defaultValue: _homeCollectionsNavBarButtonsDefault,
      );

  Future<bool> setFallbackClientExif(bool value) => _set<bool>(
        controller: _isFallbackClientExifController,
        setter: (pref, value) => pref.setFallbackClientExif(value),
        value: value,
      );

  Future<bool> _set<T>({
    required BehaviorSubject<T> controller,
    required Future<bool> Function(Pref pref, T value) setter,
    required T value,
  }) =>
      _doSet(
        pref: pref,
        controller: controller,
        setter: setter,
        value: value,
      );

  Future<bool> _setOrRemove<T>({
    required BehaviorSubject<T?> controller,
    required Future<bool> Function(Pref pref, T value) setter,
    required Future<bool> Function(Pref pref) remover,
    required T? value,
    required T? defaultValue,
  }) =>
      _doSetOrRemove(
        pref: pref,
        controller: controller,
        setter: setter,
        remover: remover,
        value: value,
        defaultValue: defaultValue,
      );

  static AppLanguage _langIdToAppLanguage(int langId) {
    try {
      return supportedLanguages[langId]!;
    } catch (_) {
      return supportedLanguages[0]!;
    }
  }

  final Pref pref;

  @npSubjectAccessor
  late final _accountsController =
      BehaviorSubject.seeded(pref.getAccounts3() ?? _accountsDefault);
  @npSubjectAccessor
  late final _currentAccountIndexController =
      BehaviorSubject.seeded(pref.getCurrentAccountIndex());
  @npSubjectAccessor
  late final _languageController =
      BehaviorSubject.seeded(_langIdToAppLanguage(pref.getLanguageOr(0)));
  @npSubjectAccessor
  late final _homePhotosZoomLevelController =
      BehaviorSubject.seeded(pref.getHomePhotosZoomLevelOr(0));
  @npSubjectAccessor
  late final _albumBrowserZoomLevelController =
      BehaviorSubject.seeded(pref.getAlbumBrowserZoomLevelOr(0));
  @npSubjectAccessor
  late final _homeAlbumsSortController = BehaviorSubject.seeded(
      CollectionSort.values[pref.getHomeAlbumsSortOr(0)]);
  @npSubjectAccessor
  late final _isEnableClientExifController =
      BehaviorSubject.seeded(pref.isEnableClientExif() ?? true);
  @npSubjectAccessor
  late final _shouldProcessExifWifiOnlyController =
      BehaviorSubject.seeded(pref.shouldProcessExifWifiOnlyOr(true));
  @npSubjectAccessor
  late final _memoriesRangeController =
      BehaviorSubject.seeded(pref.getMemoriesRangeOr(2));
  @npSubjectAccessor
  late final _viewerScreenBrightnessController =
      BehaviorSubject.seeded(pref.getViewerScreenBrightnessOr(-1));
  @npSubjectAccessor
  late final _isViewerForceRotationController =
      BehaviorSubject.seeded(pref.isViewerForceRotationOr(false));
  @npSubjectAccessor
  late final _gpsMapProviderController = BehaviorSubject.seeded(
      GpsMapProvider.values[pref.getGpsMapProviderOr(0)]);
  @npSubjectAccessor
  late final _isAlbumBrowserShowDateController =
      BehaviorSubject.seeded(pref.isAlbumBrowserShowDateOr(false));
  @npSubjectAccessor
  late final _isDoubleTapExitController =
      BehaviorSubject.seeded(pref.isDoubleTapExitOr(false));
  @npSubjectAccessor
  late final _isSaveEditResultToServerController =
      BehaviorSubject.seeded(pref.isSaveEditResultToServerOr(true));
  @npSubjectAccessor
  late final _enhanceMaxSizeController = BehaviorSubject.seeded(
      SizeInt(pref.getEnhanceMaxWidthOr(), pref.getEnhanceMaxHeightOr()));
  @npSubjectAccessor
  late final _isDarkThemeController =
      BehaviorSubject.seeded(pref.isDarkThemeOr(false));
  @npSubjectAccessor
  late final _isFollowSystemThemeController =
      BehaviorSubject.seeded(pref.isFollowSystemThemeOr(false));
  @npSubjectAccessor
  late final _isUseBlackInDarkThemeController =
      BehaviorSubject.seeded(pref.isUseBlackInDarkThemeOr(false));
  @NpSubjectAccessor(type: "Color?")
  late final _seedColorController =
      BehaviorSubject<Color?>.seeded(pref.getSeedColor()?.let(Color.new));
  @NpSubjectAccessor(type: "Color?")
  late final _secondarySeedColorController = BehaviorSubject<Color?>.seeded(
      pref.getSecondarySeedColor()?.let(Color.new));
  @npSubjectAccessor
  late final _isDontShowVideoPreviewHintController =
      BehaviorSubject.seeded(pref.isDontShowVideoPreviewHintOr(false));
  @npSubjectAccessor
  late final _mapBrowserPrevPositionController = BehaviorSubject.seeded(pref
      .getMapBrowserPrevPosition()
      ?.let(tryJsonDecode)
      ?.let(_tryMapCoordFromJson));
  @npSubjectAccessor
  late final _isNewHttpEngineController =
      BehaviorSubject.seeded(pref.isNewHttpEngine() ?? false);
  @npSubjectAccessor
  late final _firstRunTimeController = BehaviorSubject.seeded(pref
      .getFirstRunTime()
      ?.let((v) => DateTime.fromMillisecondsSinceEpoch(v).toUtc()));
  @npSubjectAccessor
  late final _lastVersionController =
      BehaviorSubject.seeded(pref.getLastVersion() ??
          // v6 is the last version without saving the version number in pref
          (pref.getSetupProgress() == null ? k.version : 6));
  @npSubjectAccessor
  late final _mapDefaultRangeTypeController = BehaviorSubject.seeded(
      pref.getMapDefaultRangeType() ?? PrefMapDefaultRangeType.thisMonth);
  @npSubjectAccessor
  late final _mapDefaultCustomRangeController = BehaviorSubject.seeded(
      pref.getMapDefaultCustomRange() ?? const Duration(days: 30));
  @npSubjectAccessor
  late final _slideshowDurationController = BehaviorSubject.seeded(
      pref.getSlideshowDuration() ?? const Duration(seconds: 5));
  @npSubjectAccessor
  late final _isSlideshowShuffleController =
      BehaviorSubject.seeded(pref.isSlideshowShuffle() ?? false);
  @npSubjectAccessor
  late final _isSlideshowRepeatController =
      BehaviorSubject.seeded(pref.isSlideshowRepeat() ?? false);
  @npSubjectAccessor
  late final _isSlideshowReverseController =
      BehaviorSubject.seeded(pref.isSlideshowReverse() ?? false);
  @npSubjectAccessor
  late final _viewerAppBarButtonsController = BehaviorSubject.seeded(
      pref.getViewerAppBarButtons() ?? _viewerAppBarButtonsDefault);
  @npSubjectAccessor
  late final _viewerBottomAppBarButtonsController = BehaviorSubject.seeded(
      pref.getViewerBottomAppBarButtons() ?? _viewerBottomAppBarButtonsDefault);
  @npSubjectAccessor
  late final _homeCollectionsNavBarButtonsController = BehaviorSubject.seeded(
      pref.getHomeCollectionsNavBarButtonsJson()?.let((s) =>
              (jsonDecode(s) as List)
                  .cast<JsonObj>()
                  .map(PrefHomeCollectionsNavButton.fromJson)
                  .toList()) ??
          _homeCollectionsNavBarButtonsDefault);
  @npSubjectAccessor
  late final _isFallbackClientExifController =
      BehaviorSubject.seeded(pref.isFallbackClientExif() ?? false);
}

extension PrefControllerExtension on PrefController {
  Account? get currentAccountValue {
    try {
      return accountsValue[currentAccountIndexValue!];
    } catch (_) {
      return null;
    }
  }
}

@npSubjectAccessor
class SecurePrefController {
  SecurePrefController(this.securePref);

  Future<bool> setProtectedPageAuthType(ProtectedPageAuthType? value) =>
      _setOrRemove<ProtectedPageAuthType>(
        controller: _protectedPageAuthTypeController,
        setter: (pref, value) => pref.setProtectedPageAuthType(value.index),
        remover: (pref) => pref.setProtectedPageAuthType(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setProtectedPageAuthPin(CiString? value) =>
      _setOrRemove<CiString>(
        controller: _protectedPageAuthPinController,
        setter: (pref, value) =>
            pref.setProtectedPageAuthPin(value.toCaseInsensitiveString()),
        remover: (pref) => pref.setProtectedPageAuthPin(null),
        value: value,
        defaultValue: null,
      );

  Future<bool> setProtectedPageAuthPassword(CiString? value) =>
      _setOrRemove<CiString>(
        controller: _protectedPageAuthPasswordController,
        setter: (pref, value) =>
            pref.setProtectedPageAuthPassword(value.toCaseInsensitiveString()),
        remover: (pref) => pref.setProtectedPageAuthPassword(null),
        value: value,
        defaultValue: null,
      );

  // ignore: unused_element
  Future<bool> _set<T>({
    required BehaviorSubject<T> controller,
    required Future<bool> Function(Pref pref, T value) setter,
    required T value,
  }) =>
      _doSet(
        pref: securePref,
        controller: controller,
        setter: setter,
        value: value,
      );

  // ignore: unused_element
  Future<bool> _setOrRemove<T>({
    required BehaviorSubject<T?> controller,
    required Future<bool> Function(Pref pref, T value) setter,
    required Future<bool> Function(Pref pref) remover,
    required T? value,
    required T? defaultValue,
  }) =>
      _doSetOrRemove(
        pref: securePref,
        controller: controller,
        setter: setter,
        remover: remover,
        value: value,
        defaultValue: defaultValue,
      );

  final Pref securePref;

  @npSubjectAccessor
  late final _protectedPageAuthTypeController = BehaviorSubject.seeded(
      securePref
          .getProtectedPageAuthType()
          ?.let((e) => ProtectedPageAuthType.values[e]));
  @npSubjectAccessor
  late final _protectedPageAuthPinController =
      BehaviorSubject.seeded(securePref.getProtectedPageAuthPin()?.toCi());
  @npSubjectAccessor
  late final _protectedPageAuthPasswordController =
      BehaviorSubject.seeded(securePref.getProtectedPageAuthPassword()?.toCi());
}

Future<bool> _doSet<T>({
  required Pref pref,
  required BehaviorSubject<T> controller,
  required Future<bool> Function(Pref pref, T value) setter,
  required T value,
}) async {
  final backup = controller.value;
  controller.add(value);
  try {
    if (!await setter(pref, value)) {
      throw StateError("Unknown error");
    }
    return true;
  } catch (e, stackTrace) {
    _$__NpLog.log.severe("[_doSet] Failed setting preference", e, stackTrace);
    controller
      ..addError(e, stackTrace)
      ..add(backup);
    return false;
  }
}

Future<bool> _doSetOrRemove<T>({
  required Pref pref,
  required BehaviorSubject<T?> controller,
  required Future<bool> Function(Pref pref, T value) setter,
  required Future<bool> Function(Pref pref) remover,
  required T? value,
  required T? defaultValue,
}) async {
  final backup = controller.value;
  controller.add(value ?? defaultValue);
  try {
    if (value == null) {
      if (!await remover(pref)) {
        throw StateError("Unknown error");
      }
    } else {
      if (!await setter(pref, value)) {
        throw StateError("Unknown error");
      }
    }
    return true;
  } catch (e, stackTrace) {
    _$__NpLog.log
        .severe("[_doSetOrRemove] Failed setting preference", e, stackTrace);
    controller
      ..addError(e, stackTrace)
      ..add(backup);
    return false;
  }
}

const _accountsDefault = <Account>[];
const _viewerAppBarButtonsDefault = [
  ViewerAppBarButtonType.livePhoto,
  ViewerAppBarButtonType.favorite,
];
const _viewerBottomAppBarButtonsDefault = [
  ViewerAppBarButtonType.share,
  ViewerAppBarButtonType.edit,
  ViewerAppBarButtonType.enhance,
  ViewerAppBarButtonType.download,
  ViewerAppBarButtonType.delete,
];
const _homeCollectionsNavBarButtonsDefault = [
  PrefHomeCollectionsNavButton(
    type: HomeCollectionsNavBarButtonType.map,
    isMinimized: false,
  ),
  PrefHomeCollectionsNavButton(
    type: HomeCollectionsNavBarButtonType.sharing,
    isMinimized: false,
  ),
  PrefHomeCollectionsNavButton(
    type: HomeCollectionsNavBarButtonType.edited,
    isMinimized: false,
  ),
  PrefHomeCollectionsNavButton(
    type: HomeCollectionsNavBarButtonType.archive,
    isMinimized: false,
  ),
  PrefHomeCollectionsNavButton(
    type: HomeCollectionsNavBarButtonType.trash,
    isMinimized: false,
  ),
];

@npLog
// ignore: camel_case_types
class __ {}
