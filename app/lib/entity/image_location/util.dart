import 'package:flutter/material.dart';
import 'package:nc_photos/entity/image_location/image_location.dart';

extension ImageLocationExtension on ImageLocation {
  String? localizedNameOf(BuildContext context) {
    String? v;
    v ??= city?.name.lang(Localizations.localeOf(context).languageCode);
    v ??= city?.name.en;
    return v;
  }

  String? localizedAdmin1Of(BuildContext context) {
    String? v;
    v ??= admin1?.name.lang(Localizations.localeOf(context).languageCode);
    v ??= admin1?.name.en;
    return v;
  }

  String? localizedAdmin2Of(BuildContext context) {
    String? v;
    v ??= admin2?.name.lang(Localizations.localeOf(context).languageCode);
    v ??= admin2?.name.en;
    return v;
  }
}
