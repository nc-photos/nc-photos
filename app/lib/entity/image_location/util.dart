import 'package:flutter/material.dart';
import 'package:nc_photos/entity/image_location/image_location.dart';

extension ImageLocationExtension on ImageLocation {
  String? localizedNameOf(BuildContext context) {
    String? v;
    final l = Localizations.localeOf(context);
    v ??= city?.name.lang(l.languageCode, l.scriptCode);
    v ??= city?.name.en;
    return v;
  }

  String? localizedAdmin1Of(BuildContext context) {
    String? v;
    final l = Localizations.localeOf(context);
    v ??= admin1?.name.lang(l.languageCode, l.scriptCode);
    v ??= admin1?.name.en;
    return v;
  }

  String? localizedAdmin2Of(BuildContext context) {
    String? v;
    final l = Localizations.localeOf(context);
    v ??= admin2?.name.lang(l.languageCode, l.scriptCode);
    v ??= admin2?.name.en;
    return v;
  }
}
