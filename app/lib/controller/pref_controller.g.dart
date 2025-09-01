// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref_controller.dart';

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$__NpLog on __ {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("controller.pref_controller.__");
}

// **************************************************************************
// NpSubjectAccessorGenerator
// **************************************************************************

extension $PrefControllerNpSubjectAccessor on PrefController {
  // _accountsController
  ValueStream<List<Account>> get accounts => _accountsController.stream;
  Stream<List<Account>> get accountsNew => accounts.skip(1);
  Stream<List<Account>> get accountsChange => accounts.distinct().skip(1);
  List<Account> get accountsValue => _accountsController.value;
  // _currentAccountIndexController
  ValueStream<int?> get currentAccountIndex =>
      _currentAccountIndexController.stream;
  Stream<int?> get currentAccountIndexNew => currentAccountIndex.skip(1);
  Stream<int?> get currentAccountIndexChange =>
      currentAccountIndex.distinct().skip(1);
  int? get currentAccountIndexValue => _currentAccountIndexController.value;
  // _languageController
  ValueStream<AppLanguage> get language => _languageController.stream;
  Stream<AppLanguage> get languageNew => language.skip(1);
  Stream<AppLanguage> get languageChange => language.distinct().skip(1);
  AppLanguage get languageValue => _languageController.value;
  // _homePhotosZoomLevelController
  ValueStream<int> get homePhotosZoomLevel =>
      _homePhotosZoomLevelController.stream;
  Stream<int> get homePhotosZoomLevelNew => homePhotosZoomLevel.skip(1);
  Stream<int> get homePhotosZoomLevelChange =>
      homePhotosZoomLevel.distinct().skip(1);
  int get homePhotosZoomLevelValue => _homePhotosZoomLevelController.value;
  // _albumBrowserZoomLevelController
  ValueStream<int> get albumBrowserZoomLevel =>
      _albumBrowserZoomLevelController.stream;
  Stream<int> get albumBrowserZoomLevelNew => albumBrowserZoomLevel.skip(1);
  Stream<int> get albumBrowserZoomLevelChange =>
      albumBrowserZoomLevel.distinct().skip(1);
  int get albumBrowserZoomLevelValue => _albumBrowserZoomLevelController.value;
  // _homeAlbumsSortController
  ValueStream<CollectionSort> get homeAlbumsSort =>
      _homeAlbumsSortController.stream;
  Stream<CollectionSort> get homeAlbumsSortNew => homeAlbumsSort.skip(1);
  Stream<CollectionSort> get homeAlbumsSortChange =>
      homeAlbumsSort.distinct().skip(1);
  CollectionSort get homeAlbumsSortValue => _homeAlbumsSortController.value;
  // _isEnableClientExifController
  ValueStream<bool> get isEnableClientExif =>
      _isEnableClientExifController.stream;
  Stream<bool> get isEnableClientExifNew => isEnableClientExif.skip(1);
  Stream<bool> get isEnableClientExifChange =>
      isEnableClientExif.distinct().skip(1);
  bool get isEnableClientExifValue => _isEnableClientExifController.value;
  // _shouldProcessExifWifiOnlyController
  ValueStream<bool> get shouldProcessExifWifiOnly =>
      _shouldProcessExifWifiOnlyController.stream;
  Stream<bool> get shouldProcessExifWifiOnlyNew =>
      shouldProcessExifWifiOnly.skip(1);
  Stream<bool> get shouldProcessExifWifiOnlyChange =>
      shouldProcessExifWifiOnly.distinct().skip(1);
  bool get shouldProcessExifWifiOnlyValue =>
      _shouldProcessExifWifiOnlyController.value;
  // _memoriesRangeController
  ValueStream<int> get memoriesRange => _memoriesRangeController.stream;
  Stream<int> get memoriesRangeNew => memoriesRange.skip(1);
  Stream<int> get memoriesRangeChange => memoriesRange.distinct().skip(1);
  int get memoriesRangeValue => _memoriesRangeController.value;
  // _viewerScreenBrightnessController
  ValueStream<int> get viewerScreenBrightness =>
      _viewerScreenBrightnessController.stream;
  Stream<int> get viewerScreenBrightnessNew => viewerScreenBrightness.skip(1);
  Stream<int> get viewerScreenBrightnessChange =>
      viewerScreenBrightness.distinct().skip(1);
  int get viewerScreenBrightnessValue =>
      _viewerScreenBrightnessController.value;
  // _isViewerForceRotationController
  ValueStream<bool> get isViewerForceRotation =>
      _isViewerForceRotationController.stream;
  Stream<bool> get isViewerForceRotationNew => isViewerForceRotation.skip(1);
  Stream<bool> get isViewerForceRotationChange =>
      isViewerForceRotation.distinct().skip(1);
  bool get isViewerForceRotationValue => _isViewerForceRotationController.value;
  // _gpsMapProviderController
  ValueStream<GpsMapProvider> get gpsMapProvider =>
      _gpsMapProviderController.stream;
  Stream<GpsMapProvider> get gpsMapProviderNew => gpsMapProvider.skip(1);
  Stream<GpsMapProvider> get gpsMapProviderChange =>
      gpsMapProvider.distinct().skip(1);
  GpsMapProvider get gpsMapProviderValue => _gpsMapProviderController.value;
  // _isAlbumBrowserShowDateController
  ValueStream<bool> get isAlbumBrowserShowDate =>
      _isAlbumBrowserShowDateController.stream;
  Stream<bool> get isAlbumBrowserShowDateNew => isAlbumBrowserShowDate.skip(1);
  Stream<bool> get isAlbumBrowserShowDateChange =>
      isAlbumBrowserShowDate.distinct().skip(1);
  bool get isAlbumBrowserShowDateValue =>
      _isAlbumBrowserShowDateController.value;
  // _isDoubleTapExitController
  ValueStream<bool> get isDoubleTapExit => _isDoubleTapExitController.stream;
  Stream<bool> get isDoubleTapExitNew => isDoubleTapExit.skip(1);
  Stream<bool> get isDoubleTapExitChange => isDoubleTapExit.distinct().skip(1);
  bool get isDoubleTapExitValue => _isDoubleTapExitController.value;
  // _isSaveEditResultToServerController
  ValueStream<bool> get isSaveEditResultToServer =>
      _isSaveEditResultToServerController.stream;
  Stream<bool> get isSaveEditResultToServerNew =>
      isSaveEditResultToServer.skip(1);
  Stream<bool> get isSaveEditResultToServerChange =>
      isSaveEditResultToServer.distinct().skip(1);
  bool get isSaveEditResultToServerValue =>
      _isSaveEditResultToServerController.value;
  // _enhanceMaxSizeController
  ValueStream<SizeInt> get enhanceMaxSize => _enhanceMaxSizeController.stream;
  Stream<SizeInt> get enhanceMaxSizeNew => enhanceMaxSize.skip(1);
  Stream<SizeInt> get enhanceMaxSizeChange => enhanceMaxSize.distinct().skip(1);
  SizeInt get enhanceMaxSizeValue => _enhanceMaxSizeController.value;
  // _isDarkThemeController
  ValueStream<bool> get isDarkTheme => _isDarkThemeController.stream;
  Stream<bool> get isDarkThemeNew => isDarkTheme.skip(1);
  Stream<bool> get isDarkThemeChange => isDarkTheme.distinct().skip(1);
  bool get isDarkThemeValue => _isDarkThemeController.value;
  // _isFollowSystemThemeController
  ValueStream<bool> get isFollowSystemTheme =>
      _isFollowSystemThemeController.stream;
  Stream<bool> get isFollowSystemThemeNew => isFollowSystemTheme.skip(1);
  Stream<bool> get isFollowSystemThemeChange =>
      isFollowSystemTheme.distinct().skip(1);
  bool get isFollowSystemThemeValue => _isFollowSystemThemeController.value;
  // _isUseBlackInDarkThemeController
  ValueStream<bool> get isUseBlackInDarkTheme =>
      _isUseBlackInDarkThemeController.stream;
  Stream<bool> get isUseBlackInDarkThemeNew => isUseBlackInDarkTheme.skip(1);
  Stream<bool> get isUseBlackInDarkThemeChange =>
      isUseBlackInDarkTheme.distinct().skip(1);
  bool get isUseBlackInDarkThemeValue => _isUseBlackInDarkThemeController.value;
  // _seedColorController
  ValueStream<ColorInt?> get seedColor => _seedColorController.stream;
  Stream<ColorInt?> get seedColorNew => seedColor.skip(1);
  Stream<ColorInt?> get seedColorChange => seedColor.distinct().skip(1);
  ColorInt? get seedColorValue => _seedColorController.value;
  // _secondarySeedColorController
  ValueStream<ColorInt?> get secondarySeedColor =>
      _secondarySeedColorController.stream;
  Stream<ColorInt?> get secondarySeedColorNew => secondarySeedColor.skip(1);
  Stream<ColorInt?> get secondarySeedColorChange =>
      secondarySeedColor.distinct().skip(1);
  ColorInt? get secondarySeedColorValue => _secondarySeedColorController.value;
  // _isDontShowVideoPreviewHintController
  ValueStream<bool> get isDontShowVideoPreviewHint =>
      _isDontShowVideoPreviewHintController.stream;
  Stream<bool> get isDontShowVideoPreviewHintNew =>
      isDontShowVideoPreviewHint.skip(1);
  Stream<bool> get isDontShowVideoPreviewHintChange =>
      isDontShowVideoPreviewHint.distinct().skip(1);
  bool get isDontShowVideoPreviewHintValue =>
      _isDontShowVideoPreviewHintController.value;
  // _mapBrowserPrevPositionController
  ValueStream<MapCoord?> get mapBrowserPrevPosition =>
      _mapBrowserPrevPositionController.stream;
  Stream<MapCoord?> get mapBrowserPrevPositionNew =>
      mapBrowserPrevPosition.skip(1);
  Stream<MapCoord?> get mapBrowserPrevPositionChange =>
      mapBrowserPrevPosition.distinct().skip(1);
  MapCoord? get mapBrowserPrevPositionValue =>
      _mapBrowserPrevPositionController.value;
  // _isNewHttpEngineController
  ValueStream<bool> get isNewHttpEngine => _isNewHttpEngineController.stream;
  Stream<bool> get isNewHttpEngineNew => isNewHttpEngine.skip(1);
  Stream<bool> get isNewHttpEngineChange => isNewHttpEngine.distinct().skip(1);
  bool get isNewHttpEngineValue => _isNewHttpEngineController.value;
  // _firstRunTimeController
  ValueStream<DateTime?> get firstRunTime => _firstRunTimeController.stream;
  Stream<DateTime?> get firstRunTimeNew => firstRunTime.skip(1);
  Stream<DateTime?> get firstRunTimeChange => firstRunTime.distinct().skip(1);
  DateTime? get firstRunTimeValue => _firstRunTimeController.value;
  // _lastVersionController
  ValueStream<int> get lastVersion => _lastVersionController.stream;
  Stream<int> get lastVersionNew => lastVersion.skip(1);
  Stream<int> get lastVersionChange => lastVersion.distinct().skip(1);
  int get lastVersionValue => _lastVersionController.value;
  // _mapDefaultRangeTypeController
  ValueStream<PrefMapDefaultRangeType> get mapDefaultRangeType =>
      _mapDefaultRangeTypeController.stream;
  Stream<PrefMapDefaultRangeType> get mapDefaultRangeTypeNew =>
      mapDefaultRangeType.skip(1);
  Stream<PrefMapDefaultRangeType> get mapDefaultRangeTypeChange =>
      mapDefaultRangeType.distinct().skip(1);
  PrefMapDefaultRangeType get mapDefaultRangeTypeValue =>
      _mapDefaultRangeTypeController.value;
  // _mapDefaultCustomRangeController
  ValueStream<Duration> get mapDefaultCustomRange =>
      _mapDefaultCustomRangeController.stream;
  Stream<Duration> get mapDefaultCustomRangeNew =>
      mapDefaultCustomRange.skip(1);
  Stream<Duration> get mapDefaultCustomRangeChange =>
      mapDefaultCustomRange.distinct().skip(1);
  Duration get mapDefaultCustomRangeValue =>
      _mapDefaultCustomRangeController.value;
  // _slideshowDurationController
  ValueStream<Duration> get slideshowDuration =>
      _slideshowDurationController.stream;
  Stream<Duration> get slideshowDurationNew => slideshowDuration.skip(1);
  Stream<Duration> get slideshowDurationChange =>
      slideshowDuration.distinct().skip(1);
  Duration get slideshowDurationValue => _slideshowDurationController.value;
  // _isSlideshowShuffleController
  ValueStream<bool> get isSlideshowShuffle =>
      _isSlideshowShuffleController.stream;
  Stream<bool> get isSlideshowShuffleNew => isSlideshowShuffle.skip(1);
  Stream<bool> get isSlideshowShuffleChange =>
      isSlideshowShuffle.distinct().skip(1);
  bool get isSlideshowShuffleValue => _isSlideshowShuffleController.value;
  // _isSlideshowRepeatController
  ValueStream<bool> get isSlideshowRepeat =>
      _isSlideshowRepeatController.stream;
  Stream<bool> get isSlideshowRepeatNew => isSlideshowRepeat.skip(1);
  Stream<bool> get isSlideshowRepeatChange =>
      isSlideshowRepeat.distinct().skip(1);
  bool get isSlideshowRepeatValue => _isSlideshowRepeatController.value;
  // _isSlideshowReverseController
  ValueStream<bool> get isSlideshowReverse =>
      _isSlideshowReverseController.stream;
  Stream<bool> get isSlideshowReverseNew => isSlideshowReverse.skip(1);
  Stream<bool> get isSlideshowReverseChange =>
      isSlideshowReverse.distinct().skip(1);
  bool get isSlideshowReverseValue => _isSlideshowReverseController.value;
  // _viewerAppBarButtonsController
  ValueStream<List<ViewerAppBarButtonType>> get viewerAppBarButtons =>
      _viewerAppBarButtonsController.stream;
  Stream<List<ViewerAppBarButtonType>> get viewerAppBarButtonsNew =>
      viewerAppBarButtons.skip(1);
  Stream<List<ViewerAppBarButtonType>> get viewerAppBarButtonsChange =>
      viewerAppBarButtons.distinct().skip(1);
  List<ViewerAppBarButtonType> get viewerAppBarButtonsValue =>
      _viewerAppBarButtonsController.value;
  // _viewerBottomAppBarButtonsController
  ValueStream<List<ViewerAppBarButtonType>> get viewerBottomAppBarButtons =>
      _viewerBottomAppBarButtonsController.stream;
  Stream<List<ViewerAppBarButtonType>> get viewerBottomAppBarButtonsNew =>
      viewerBottomAppBarButtons.skip(1);
  Stream<List<ViewerAppBarButtonType>> get viewerBottomAppBarButtonsChange =>
      viewerBottomAppBarButtons.distinct().skip(1);
  List<ViewerAppBarButtonType> get viewerBottomAppBarButtonsValue =>
      _viewerBottomAppBarButtonsController.value;
  // _homeCollectionsNavBarButtonsController
  ValueStream<List<PrefHomeCollectionsNavButton>>
  get homeCollectionsNavBarButtons =>
      _homeCollectionsNavBarButtonsController.stream;
  Stream<List<PrefHomeCollectionsNavButton>>
  get homeCollectionsNavBarButtonsNew => homeCollectionsNavBarButtons.skip(1);
  Stream<List<PrefHomeCollectionsNavButton>>
  get homeCollectionsNavBarButtonsChange =>
      homeCollectionsNavBarButtons.distinct().skip(1);
  List<PrefHomeCollectionsNavButton> get homeCollectionsNavBarButtonsValue =>
      _homeCollectionsNavBarButtonsController.value;
  // _isFallbackClientExifController
  ValueStream<bool> get isFallbackClientExif =>
      _isFallbackClientExifController.stream;
  Stream<bool> get isFallbackClientExifNew => isFallbackClientExif.skip(1);
  Stream<bool> get isFallbackClientExifChange =>
      isFallbackClientExif.distinct().skip(1);
  bool get isFallbackClientExifValue => _isFallbackClientExifController.value;
  // _isVideoPlayerMuteController
  ValueStream<bool> get isVideoPlayerMute =>
      _isVideoPlayerMuteController.stream;
  Stream<bool> get isVideoPlayerMuteNew => isVideoPlayerMute.skip(1);
  Stream<bool> get isVideoPlayerMuteChange =>
      isVideoPlayerMute.distinct().skip(1);
  bool get isVideoPlayerMuteValue => _isVideoPlayerMuteController.value;
  // _isVideoPlayerLoopController
  ValueStream<bool> get isVideoPlayerLoop =>
      _isVideoPlayerLoopController.stream;
  Stream<bool> get isVideoPlayerLoopNew => isVideoPlayerLoop.skip(1);
  Stream<bool> get isVideoPlayerLoopChange =>
      isVideoPlayerLoop.distinct().skip(1);
  bool get isVideoPlayerLoopValue => _isVideoPlayerLoopController.value;
  // _localDirsController
  ValueStream<List<String>> get localDirs => _localDirsController.stream;
  Stream<List<String>> get localDirsNew => localDirs.skip(1);
  Stream<List<String>> get localDirsChange => localDirs.distinct().skip(1);
  List<String> get localDirsValue => _localDirsController.value;
  // _isEnableUploadConvertController
  ValueStream<bool> get isEnableUploadConvert =>
      _isEnableUploadConvertController.stream;
  Stream<bool> get isEnableUploadConvertNew => isEnableUploadConvert.skip(1);
  Stream<bool> get isEnableUploadConvertChange =>
      isEnableUploadConvert.distinct().skip(1);
  bool get isEnableUploadConvertValue => _isEnableUploadConvertController.value;
  // _uploadConvertFormatController
  ValueStream<ConvertFormat> get uploadConvertFormat =>
      _uploadConvertFormatController.stream;
  Stream<ConvertFormat> get uploadConvertFormatNew =>
      uploadConvertFormat.skip(1);
  Stream<ConvertFormat> get uploadConvertFormatChange =>
      uploadConvertFormat.distinct().skip(1);
  ConvertFormat get uploadConvertFormatValue =>
      _uploadConvertFormatController.value;
  // _uploadConvertQualityController
  ValueStream<int> get uploadConvertQuality =>
      _uploadConvertQualityController.stream;
  Stream<int> get uploadConvertQualityNew => uploadConvertQuality.skip(1);
  Stream<int> get uploadConvertQualityChange =>
      uploadConvertQuality.distinct().skip(1);
  int get uploadConvertQualityValue => _uploadConvertQualityController.value;
  // _uploadConvertDownsizeMpController
  ValueStream<double?> get uploadConvertDownsizeMp =>
      _uploadConvertDownsizeMpController.stream;
  Stream<double?> get uploadConvertDownsizeMpNew =>
      uploadConvertDownsizeMp.skip(1);
  Stream<double?> get uploadConvertDownsizeMpChange =>
      uploadConvertDownsizeMp.distinct().skip(1);
  double? get uploadConvertDownsizeMpValue =>
      _uploadConvertDownsizeMpController.value;
  // _isShowUploadConvertWarningController
  ValueStream<bool> get isShowUploadConvertWarning =>
      _isShowUploadConvertWarningController.stream;
  Stream<bool> get isShowUploadConvertWarningNew =>
      isShowUploadConvertWarning.skip(1);
  Stream<bool> get isShowUploadConvertWarningChange =>
      isShowUploadConvertWarning.distinct().skip(1);
  bool get isShowUploadConvertWarningValue =>
      _isShowUploadConvertWarningController.value;
}

extension $SecurePrefControllerNpSubjectAccessor on SecurePrefController {
  // _protectedPageAuthTypeController
  ValueStream<ProtectedPageAuthType?> get protectedPageAuthType =>
      _protectedPageAuthTypeController.stream;
  Stream<ProtectedPageAuthType?> get protectedPageAuthTypeNew =>
      protectedPageAuthType.skip(1);
  Stream<ProtectedPageAuthType?> get protectedPageAuthTypeChange =>
      protectedPageAuthType.distinct().skip(1);
  ProtectedPageAuthType? get protectedPageAuthTypeValue =>
      _protectedPageAuthTypeController.value;
  // _protectedPageAuthPinController
  ValueStream<CiString?> get protectedPageAuthPin =>
      _protectedPageAuthPinController.stream;
  Stream<CiString?> get protectedPageAuthPinNew => protectedPageAuthPin.skip(1);
  Stream<CiString?> get protectedPageAuthPinChange =>
      protectedPageAuthPin.distinct().skip(1);
  CiString? get protectedPageAuthPinValue =>
      _protectedPageAuthPinController.value;
  // _protectedPageAuthPasswordController
  ValueStream<CiString?> get protectedPageAuthPassword =>
      _protectedPageAuthPasswordController.stream;
  Stream<CiString?> get protectedPageAuthPasswordNew =>
      protectedPageAuthPassword.skip(1);
  Stream<CiString?> get protectedPageAuthPasswordChange =>
      protectedPageAuthPassword.distinct().skip(1);
  CiString? get protectedPageAuthPasswordValue =>
      _protectedPageAuthPasswordController.value;
}
