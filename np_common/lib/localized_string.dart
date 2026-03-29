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

  String? lang(String lang) => value[lang.toLowerCase()];

  /// Return string in [preferredLang], or en if not available
  String operator [](String preferredLang) {
    return lang(preferredLang) ?? en;
  }

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [value];

  final Map<String, String> value;
}
