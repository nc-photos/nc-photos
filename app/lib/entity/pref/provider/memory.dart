import 'package:nc_photos/entity/pref.dart';
import 'package:np_common/type.dart';

/// [Pref] stored in memory, useful in unit tests
class PrefMemoryProvider extends PrefProvider {
  PrefMemoryProvider([
    Map<String, dynamic> initialData = const <String, dynamic>{},
  ]) : _data = Map.of(initialData);

  factory PrefMemoryProvider.fromJson(JsonObj json) => PrefMemoryProvider(json);

  @override
  bool? getBool(PrefKeyInterface key) => _get<bool>(key);
  @override
  Future<bool> setBool(PrefKeyInterface key, bool value) => _set(key, value);

  @override
  int? getInt(PrefKeyInterface key) => _get<int>(key);
  @override
  Future<bool> setInt(PrefKeyInterface key, int value) => _set(key, value);

  @override
  double? getDouble(PrefKeyInterface key) => _get<double>(key);
  @override
  Future<bool> setDouble(PrefKeyInterface key, double value) =>
      _set(key, value);

  @override
  String? getString(PrefKeyInterface key) => _get<String>(key);
  @override
  Future<bool> setString(PrefKeyInterface key, String value) =>
      _set(key, value);

  @override
  List<String>? getStringList(PrefKeyInterface key) => _get<List<String>>(key);
  @override
  Future<bool> setStringList(PrefKeyInterface key, List<String> value) =>
      _set(key, value);

  @override
  List<int>? getIntList(PrefKeyInterface key) => _get<List<int>>(key);
  @override
  Future<bool> setIntList(PrefKeyInterface key, List<int> value) =>
      _set(key, value);

  @override
  Future<bool> remove(PrefKeyInterface key) async {
    _data.remove(key.toStringKey());
    return true;
  }

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  T? _get<T>(PrefKeyInterface key) => _data[key.toStringKey()];

  Future<bool> _set<T>(PrefKeyInterface key, T value) async {
    _data[key.toStringKey()] = value;
    return true;
  }

  final Map<String, dynamic> _data;
}
