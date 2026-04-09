import 'package:nc_photos/entity/image_location/image_location.dart';
import 'package:np_common/object_util.dart';
import 'package:np_geocoder/np_geocoder.dart';

extension ReverseGeocoderExtension on ReverseGeocoderLocation {
  ImageLocation toImageLocation() {
    return ImageLocation(
      dataRevision: dataRevision,
      latitude: latitude,
      longitude: longitude,
      countryCode: countryCode,
      city: city?.let(
        (e) => ImageLocationName(geonameId: e.geonameId, name: e.name),
      ),
      admin1: admin1?.let(
        (e) => ImageLocationName(geonameId: e.geonameId, name: e.name),
      ),
      admin2: admin2?.let(
        (e) => ImageLocationName(geonameId: e.geonameId, name: e.name),
      ),
    );
  }
}
