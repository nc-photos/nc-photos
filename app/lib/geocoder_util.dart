import 'package:nc_photos/entity/image_location/image_location.dart';
import 'package:np_geocoder/np_geocoder.dart';

extension ReverseGeocoderExtension on ReverseGeocoderLocation {
  ImageLocation toImageLocation() {
    return ImageLocation(
      name: name,
      latitude: latitude,
      longitude: longitude,
      countryCode: countryCode,
      admin1: admin1,
      admin2: admin2,
    );
  }
}
