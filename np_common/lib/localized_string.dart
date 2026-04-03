import 'package:equatable/equatable.dart';
import 'package:np_common/type.dart';
import 'package:to_string/to_string.dart';

part 'localized_string.g.dart';

@toString
class LocalizedString with EquatableMixin {
  const LocalizedString(this.value);

  LocalizedString.ofString(String value) : this({"en": value});

  static LocalizedString fromJson(JsonObj json) {
    return LocalizedString((json["value"] as Map).cast<String, String>());
  }

  JsonObj toJson() => {"value": value};

  String get en => value["en"]!;

  String? lang(String lang, [String? scriptCode]) {
    final l = lang.toLowerCase();
    if (l == "zh") {
      final s = scriptCode?.toLowerCase();
      if (s == "hans") {
        return value["zh-hans"] ?? value["zh"] ?? value["zh-hant"];
      } else if (s == "hant") {
        return value["zh-hant"] ?? value["zh"] ?? value["zh-hans"];
      } else {
        return value["zh-hans"] ?? value["zh"] ?? value["zh-hant"];
      }
    } else {
      return value[l];
    }
  }

  /// Return string in [preferredLang] and optionally with [preferredScriptCode],
  /// or en if not available
  String get(String preferredLang, [String? preferredScriptCode]) {
    return lang(preferredLang, preferredScriptCode) ?? en;
  }

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [value];

  final Map<String, String> value;
}
