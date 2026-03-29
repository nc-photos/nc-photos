import 'package:flutter/material.dart';
import 'package:np_common/localized_string.dart';

extension LocalizedStringExtension on LocalizedString {
  String of(BuildContext context) {
    return this[Localizations.localeOf(context).languageCode];
  }
}
