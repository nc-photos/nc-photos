import 'package:flutter/material.dart';
import 'package:np_common/localized_string.dart';

extension LocalizedStringExtension on LocalizedString {
  String of(BuildContext context) {
    return ofLocale(Localizations.localeOf(context));
  }

  String ofLocale(Locale locale) {
    return get(locale.languageCode, locale.scriptCode);
  }
}
