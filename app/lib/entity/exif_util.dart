import 'package:flutter/foundation.dart';
import 'package:nc_photos/entity/exif.dart';
import 'package:np_exiv2/np_exiv2.dart';

extension ExifExtension on Exif {
  double? get gpsLatitudeDeg {
    if (gpsLatitude == null || gpsLatitudeRef == null) {
      return null;
    } else if (gpsLatitudeRef != "N" && gpsLatitudeRef != "S") {
      // invalid value
      return null;
    } else if (gpsLatitude!.any((e) => e.denominator == 0)) {
      // invalid value
      return null;
    } else {
      return gpsDmsToDouble(gpsLatitude!) * (gpsLatitudeRef == "S" ? -1 : 1);
    }
  }

  double? get gpsLongitudeDeg {
    if (gpsLongitude == null || gpsLongitudeRef == null) {
      return null;
    } else if (gpsLongitudeRef != "E" && gpsLongitudeRef != "W") {
      // invalid value
      return null;
    } else if (gpsLongitude!.any((e) => e.denominator == 0)) {
      // invalid value
      return null;
    } else {
      return gpsDmsToDouble(gpsLongitude!) * (gpsLongitudeRef == "W" ? -1 : 1);
    }
  }
}

List<Rational> gpsDoubleToDms(double src) {
  var tmp = src.abs();
  final d = tmp.floor();
  tmp -= d;
  final ss = (tmp * 3600 * 100).floor();
  final s = ss % (60 * 100);
  final m = (ss / (60 * 100)).floor();
  return [Rational(d, 1), Rational(m, 1), Rational(s, 100)];
}

@visibleForTesting
double gpsDmsToDouble(List<Rational> dms) {
  double product = dms[0].toDouble();
  if (dms.length > 1) {
    product += dms[1].toDouble() / 60;
  }
  if (dms.length > 2) {
    product += dms[2].toDouble() / 3600;
  }
  return product;
}

Rational doubleToRational(double src) {
  final s = src.abs();
  if (s < 1000) {
    return Rational((s * 100000).truncate(), 100000);
  } else if (s < 100000) {
    return Rational((s * 1000).truncate(), 1000);
  } else {
    return Rational(s.truncate(), 1);
  }
}
