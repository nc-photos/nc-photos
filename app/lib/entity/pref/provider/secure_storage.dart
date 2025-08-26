import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';

part 'secure_storage.g.dart';

@npLog
class PrefSecureStorageProvider implements PrefProvider {
  Future<void> init() async {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        preferencesKeyPrefix: "com.nkming.nc_photos",
        sharedPreferencesName: "secure_pref",
      ),
      iOptions: IOSOptions(accountName: "com.nkming.nc_photos"),
    );
    _rawData = await _storage.readAll();
  }

  @override
  bool? getBool(PrefKeyInterface key) {
    final value = _rawData[key.toStringKey()];
    return value?.let((e) => bool.tryParse(e, caseSensitive: false));
  }

  @override
  Future<bool> setBool(PrefKeyInterface key, bool value) =>
      setString(key, value.toString());

  @override
  int? getInt(PrefKeyInterface key) {
    final value = _rawData[key.toStringKey()];
    return value?.let(int.tryParse);
  }

  @override
  Future<bool> setInt(PrefKeyInterface key, int value) =>
      setString(key, value.toString());

  @override
  String? getString(PrefKeyInterface key) {
    return _rawData[key.toStringKey()];
  }

  @override
  Future<bool> setString(PrefKeyInterface key, String value) async {
    try {
      await _storage.write(key: key.toStringKey(), value: value);
      _rawData[key.toStringKey()] = value;
      return true;
    } catch (e, stackTrace) {
      _log.severe("[setString] Failed while write", e, stackTrace);
      return false;
    }
  }

  @override
  List<String>? getStringList(PrefKeyInterface key) {
    final value = _rawData[key.toStringKey()];
    return (value?.let(jsonDecode) as List).cast<String>();
  }

  @override
  Future<bool> setStringList(PrefKeyInterface key, List<String> value) =>
      setString(key, jsonEncode(value));

  @override
  List<int>? getIntList(PrefKeyInterface key) {
    final value = _rawData[key.toStringKey()];
    return (value?.let(jsonDecode) as List).cast<int>();
  }

  @override
  Future<bool> setIntList(PrefKeyInterface key, List<int> value) =>
      setString(key, jsonEncode(value));

  @override
  Future<bool> remove(PrefKeyInterface key) async {
    try {
      await _storage.delete(key: key.toStringKey());
      _rawData.remove(key.toStringKey());
      return true;
    } catch (e, stackTrace) {
      _log.severe("[remove] Failed while write", e, stackTrace);
      return false;
    }
  }

  @override
  Future<bool> clear() async {
    try {
      await _storage.deleteAll();
      _rawData.clear();
      return true;
    } catch (e, stackTrace) {
      _log.severe("[clear] Failed while write", e, stackTrace);
      return false;
    }
  }

  late FlutterSecureStorage _storage;
  late Map<String, String> _rawData;
}
