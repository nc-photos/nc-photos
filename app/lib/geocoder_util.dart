import 'package:nc_photos/entity/image_location/image_location.dart';
import 'package:np_geocoder/np_geocoder.dart';

extension ReverseGeocoderExtension on ReverseGeocoderLocation {
  ImageLocation toImageLocation() {
    return ImageLocation(
      dataRevision: dataRevision,
      latitude: latitude,
      longitude: longitude,
      countryCode: countryCode,
      names: names.map(
        (key, value) => MapEntry(
          key,
          ImageLocationName(
            name: value.name,
            admin1: value.admin1,
            admin2: value.admin2,
          ),
        ),
      ),
    );
  }
}
