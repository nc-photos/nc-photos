import 'package:nc_photos/entity/xmp.dart';
import 'package:test/test.dart';

void main() {
  group("Xmp", () {
    test("Width", () {
      final xmp = Xmp({"Width": "1920"});
      expect(xmp.width, 1920);
    });
    test("Height", () {
      final xmp = Xmp({"Height": "1080"});
      expect(xmp.height, 1080);
    });
    group("dateUtc", () {
      test("iso8601", () {
        final xmp = Xmp({"DateUTC": "2020-01-02T03:04:05Z"});
        expect(xmp.dateUtc, DateTime.utc(2020, 1, 2, 3, 4, 5));
      });
      test("unix epoch", () {
        final xmp = Xmp({"DateUTC": "1577934245"});
        expect(xmp.dateUtc, DateTime.utc(2020, 1, 2, 3, 4, 5));
      });
      test("mac epoch", () {
        final xmp = Xmp({"DateUTC": "3660779045"});
        expect(xmp.dateUtc, DateTime.utc(2020, 1, 2, 3, 4, 5));
      });
    });
    group("gpsCoordinates", () {
      test("positive", () {
        final xmp = Xmp({"GPSCoordinates": "+12.34+43.21/"});
        expect(xmp.gpsCoordinates, (lat: 12.34, lng: 43.21));
      });
      test("negative", () {
        final xmp = Xmp({"GPSCoordinates": "-12.34-43.21/"});
        expect(xmp.gpsCoordinates, (lat: -12.34, lng: -43.21));
      });
    });
  });
}
