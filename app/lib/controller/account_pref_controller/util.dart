part of '../account_pref_controller.dart';

extension on AccountPref {
  bool? hasNewSharedAlbum() =>
      provider.getBool(AccountPrefKey.hasNewSharedAlbum);
  // Future<bool> setNewSharedAlbum(bool value) =>
  //     provider.setBool(AccountPrefKey.hasNewSharedAlbum, value);

  String? getServerStatus() => provider.getString(AccountPrefKey.serverStatus);
  Future<bool> setServerStatus(String? value) {
    if (value == null) {
      return provider.remove(AccountPrefKey.serverStatus);
    } else {
      return provider.setString(AccountPrefKey.serverStatus, value);
    }
  }

  String? getUploadRelativePath() =>
      provider.getString(AccountPrefKey.uploadRelativePath);
  Future<bool> setUploadRelativePath(String value) =>
      provider.setString(AccountPrefKey.uploadRelativePath, value);
}
