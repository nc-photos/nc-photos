part of '../pref_controller.dart';

extension on Pref {
  Future<bool> setAccounts3(List<Account>? value) {
    if (value == null) {
      return provider.remove(PrefKey.accounts3);
    } else {
      final jsons = value.map((e) => jsonEncode(e.toJson())).toList();
      return provider.setStringList(PrefKey.accounts3, jsons);
    }
  }

  int? getHomeAlbumsSort() => provider.getInt(PrefKey.homeAlbumsSort);
  int getHomeAlbumsSortOr(int def) => getHomeAlbumsSort() ?? def;
  Future<bool> setHomeAlbumsSort(int value) =>
      provider.setInt(PrefKey.homeAlbumsSort, value);

  bool? isEnableClientExif() => isEnableExif();
  Future<bool> setEnableClientExif(bool value) => setEnableExif(value);

  bool? isDarkTheme() => provider.getBool(PrefKey.darkTheme);
  bool isDarkThemeOr(bool def) => isDarkTheme() ?? def;
  Future<bool> setDarkTheme(bool value) =>
      provider.setBool(PrefKey.darkTheme, value);

  bool? isFollowSystemTheme() => provider.getBool(PrefKey.followSystemTheme);
  bool isFollowSystemThemeOr(bool def) => isFollowSystemTheme() ?? def;
  Future<bool> setFollowSystemTheme(bool value) =>
      provider.setBool(PrefKey.followSystemTheme, value);

  bool? isUseBlackInDarkTheme() =>
      provider.getBool(PrefKey.useBlackInDarkTheme);
  bool isUseBlackInDarkThemeOr(bool def) => isUseBlackInDarkTheme() ?? def;
  Future<bool> setUseBlackInDarkTheme(bool value) =>
      provider.setBool(PrefKey.useBlackInDarkTheme, value);

  int? getGpsMapProvider() => provider.getInt(PrefKey.gpsMapProvider);
  int getGpsMapProviderOr(int def) => getGpsMapProvider() ?? def;
  Future<bool> setGpsMapProvider(int value) =>
      provider.setInt(PrefKey.gpsMapProvider, value);

  int? getSeedColor() => provider.getInt(PrefKey.seedColor);
  // int getSeedColorOr(int def) => getSeedColor() ?? def;
  Future<bool> setSeedColor(int? value) {
    if (value == null) {
      return provider.remove(PrefKey.seedColor);
    } else {
      return provider.setInt(PrefKey.seedColor, value);
    }
  }

  int? getSecondarySeedColor() => provider.getInt(PrefKey.secondarySeedColor);
  // int getSecondarySeedColorOr(int def) => getSecondarySeedColor() ?? def;
  Future<bool> setSecondarySeedColor(int? value) {
    if (value == null) {
      return provider.remove(PrefKey.secondarySeedColor);
    } else {
      return provider.setInt(PrefKey.secondarySeedColor, value);
    }
  }

  int? getProtectedPageAuthType() =>
      provider.getInt(PrefKey.protectedPageAuthType);
  // int getProtectedPageAuthTypeOr(int def) => getProtectedPageAuthType() ?? def;
  Future<bool> setProtectedPageAuthType(int? value) {
    if (value == null) {
      return provider.remove(PrefKey.protectedPageAuthType);
    } else {
      return provider.setInt(PrefKey.protectedPageAuthType, value);
    }
  }

  String? getProtectedPageAuthPin() =>
      provider.getString(PrefKey.protectedPageAuthPin);
  // String getProtectedPageAuthPinOr(String def) =>
  //     getProtectedPageAuthPin() ?? def;
  Future<bool> setProtectedPageAuthPin(String? value) {
    if (value == null) {
      return provider.remove(PrefKey.protectedPageAuthPin);
    } else {
      return provider.setString(PrefKey.protectedPageAuthPin, value);
    }
  }

  String? getProtectedPageAuthPassword() =>
      provider.getString(PrefKey.protectedPageAuthPassword);
  // String getProtectedPageAuthPasswordOr(String def) =>
  //     getProtectedPageAuthPassword() ?? def;
  Future<bool> setProtectedPageAuthPassword(String? value) {
    if (value == null) {
      return provider.remove(PrefKey.protectedPageAuthPassword);
    } else {
      return provider.setString(PrefKey.protectedPageAuthPassword, value);
    }
  }

  bool? isDontShowVideoPreviewHint() =>
      provider.getBool(PrefKey.dontShowVideoPreviewHint);
  bool isDontShowVideoPreviewHintOr(bool def) =>
      isDontShowVideoPreviewHint() ?? def;
  Future<bool> setDontShowVideoPreviewHint(bool value) =>
      provider.setBool(PrefKey.dontShowVideoPreviewHint, value);

  String? getMapBrowserPrevPosition() =>
      provider.getString(PrefKey.mapBrowserPrevPosition);
  Future<bool> setMapBrowserPrevPosition(String? value) {
    if (value == null) {
      return provider.remove(PrefKey.mapBrowserPrevPosition);
    } else {
      return provider.setString(PrefKey.mapBrowserPrevPosition, value);
    }
  }

  Future<bool> setNewHttpEngine(bool value) =>
      provider.setBool(PrefKey.isNewHttpEngine, value);

  int? getFirstRunTime() => provider.getInt(PrefKey.firstRunTime);
  Future<bool> setFirstRunTime(int? value) {
    if (value == null) {
      return provider.remove(PrefKey.firstRunTime);
    } else {
      return provider.setInt(PrefKey.firstRunTime, value);
    }
  }

  int? getCurrentAccountIndex() => provider.getInt(PrefKey.currentAccountIndex);
  Future<bool> setCurrentAccountIndex(int? value) {
    if (value == null) {
      return provider.remove(PrefKey.currentAccountIndex);
    } else {
      return provider.setInt(PrefKey.currentAccountIndex, value);
    }
  }

  PrefMapDefaultRangeType? getMapDefaultRangeType() => provider
      .getInt(PrefKey.mapDefaultRangeType)
      ?.let(PrefMapDefaultRangeType.fromValue);
  Future<bool> setMapDefaultRangeType(PrefMapDefaultRangeType value) =>
      provider.setInt(PrefKey.mapDefaultRangeType, value.value);

  Duration? getMapDefaultCustomRange() => provider
      .getInt(PrefKey.mapDefaultCustomRange)
      ?.let((v) => Duration(days: v));
  Future<bool> setMapDefaultCustomRange(Duration value) =>
      provider.setInt(PrefKey.mapDefaultCustomRange, value.inDays);

  Duration? getSlideshowDuration() => provider
      .getInt(PrefKey.slideshowDuration)
      ?.let((v) => Duration(seconds: v));
  Future<bool> setSlideshowDuration(Duration value) =>
      provider.setInt(PrefKey.slideshowDuration, value.inSeconds);

  bool? isSlideshowShuffle() => provider.getBool(PrefKey.isSlideshowShuffle);
  Future<bool> setSlideshowShuffle(bool value) =>
      provider.setBool(PrefKey.isSlideshowShuffle, value);

  bool? isSlideshowRepeat() => provider.getBool(PrefKey.isSlideshowRepeat);
  Future<bool> setSlideshowRepeat(bool value) =>
      provider.setBool(PrefKey.isSlideshowRepeat, value);

  bool? isSlideshowReverse() => provider.getBool(PrefKey.isSlideshowReverse);
  Future<bool> setSlideshowReverse(bool value) =>
      provider.setBool(PrefKey.isSlideshowReverse, value);

  List<ViewerAppBarButtonType>? getViewerAppBarButtons() =>
      provider
          .getIntList(PrefKey.viewerAppBarButtons)
          ?.map(ViewerAppBarButtonType.fromValue)
          .toList();
  Future<bool> setViewerAppBarButtons(List<ViewerAppBarButtonType>? value) {
    if (value == null) {
      return provider.remove(PrefKey.viewerAppBarButtons);
    } else {
      return provider.setIntList(
        PrefKey.viewerAppBarButtons,
        value.map((e) => e.index).toList(),
      );
    }
  }

  List<ViewerAppBarButtonType>? getViewerBottomAppBarButtons() =>
      provider
          .getIntList(PrefKey.viewerBottomAppBarButtons)
          ?.map(ViewerAppBarButtonType.fromValue)
          .toList();
  Future<bool> setViewerBottomAppBarButtons(
    List<ViewerAppBarButtonType>? value,
  ) {
    if (value == null) {
      return provider.remove(PrefKey.viewerBottomAppBarButtons);
    } else {
      return provider.setIntList(
        PrefKey.viewerBottomAppBarButtons,
        value.map((e) => e.index).toList(),
      );
    }
  }

  String? getHomeCollectionsNavBarButtonsJson() =>
      provider.getString(PrefKey.homeCollectionsNavBarButtons);
  Future<bool> setHomeCollectionsNavBarButtonsJson(String? value) {
    if (value == null) {
      return provider.remove(PrefKey.homeCollectionsNavBarButtons);
    } else {
      return provider.setString(PrefKey.homeCollectionsNavBarButtons, value);
    }
  }

  bool? isFallbackClientExif() =>
      provider.getBool(PrefKey.isFallbackClientExif);
  Future<bool> setFallbackClientExif(bool value) =>
      provider.setBool(PrefKey.isFallbackClientExif, value);

  List<String>? getLocalDirs() => provider.getStringList(PrefKey.localDirs);
  Future<bool> setLocalDirs(List<String> value) =>
      provider.setStringList(PrefKey.localDirs, value);
}

MapCoord? _tryMapCoordFromJson(dynamic json) {
  try {
    final j = (json as List).cast<double>();
    return MapCoord(j[0], j[1]);
  } catch (e, stackTrace) {
    _$__NpLog.log.severe(
      "[_tryMapCoordFromJson] Failed to parse json",
      e,
      stackTrace,
    );
    return null;
  }
}
