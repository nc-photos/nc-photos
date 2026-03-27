import 'package:nc_photos/entity/image_location/image_location.dart';
import 'package:np_geocoder/np_geocoder.dart';

extension ReverseGeocoderExtension on ReverseGeocoderLocation {
  ImageLocation toImageLocation() {
    return ImageLocation(
      latitude: latitude,
      longitude: longitude,
      countryCode: countryCode,
      name: names["en"]?.name,
      admin1: names["en"]?.admin1,
      admin2: names["en"]?.admin2,
    );
  }
}
