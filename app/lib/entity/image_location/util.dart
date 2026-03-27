import 'package:flutter/material.dart';
import 'package:nc_photos/entity/image_location/image_location.dart';
import 'package:np_common/object_util.dart';

extension ImageLocationExtension on ImageLocation {
  String? localizedNameOf(BuildContext context) {
    String? v;
    v ??= Localizations.localeOf(
      context,
    ).countryCode?.let((cc) => names?[cc.toLowerCase()]?.name);
    v ??= names?["en"]?.name;
    return v;
  }

  String? localizedAdmin1Of(BuildContext context) {
    String? v;
    v ??= Localizations.localeOf(
      context,
    ).countryCode?.let((cc) => names?[cc.toLowerCase()]?.admin1);
    v ??= names?["en"]?.admin1;
    return v;
  }

  String? localizedAdmin2Of(BuildContext context) {
    String? v;
    v ??= Localizations.localeOf(
      context,
    ).countryCode?.let((cc) => names?[cc.toLowerCase()]?.admin2);
    v ??= names?["en"]?.admin2;
    return v;
  }
}
