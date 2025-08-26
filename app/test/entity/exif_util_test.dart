import 'package:nc_photos/entity/exif_util.dart';
import 'package:np_exiv2/np_exiv2.dart';
import 'package:test/test.dart';

void main() {
  group("exif_util", () {
    group("gpsDmsToDouble", () {
      test("United Nations HQ", () {
        // 40° 44′ 58″ N, 73° 58′ 5″ W
        final lat = gpsDmsToDouble([
          const Rational(40, 1),
          const Rational(44, 1),
          const Rational(58, 1),
        ]);
        final lng = gpsDmsToDouble([
          const Rational(73, 1),
          const Rational(58, 1),
          const Rational(5, 1),
        ]);
        expect(lat, closeTo(40.749444, .00001));
        expect(lng, closeTo(73.968056, .00001));
      });

      test("East Cape Lighthouse", () {
        // 37° 41′ 20.2″ S, 178° 32′ 53.3″ E
        final lat = gpsDmsToDouble([
          const Rational(37, 1),
          const Rational(41, 1),
          const Rational(202, 10),
        ]);
        final lng = gpsDmsToDouble([
          const Rational(178, 1),
          const Rational(32, 1),
          const Rational(533, 10),
        ]);
        expect(lat, closeTo(37.688944, .00001));
        expect(lng, closeTo(178.548139, .00001));
      });
    });

    group("gpsDoubleToDms", () {
      test("United Nations HQ", () {
        // 40.749444, -73.968056
        final lat = gpsDoubleToDms(40.749444);
        final lng = gpsDoubleToDms(-73.968056);
        expect(lat.map((e) => e.toString()), [
          const Rational(40, 1).toString(),
          const Rational(44, 1).toString(),
          const Rational(5799, 100).toString(),
        ]);
        expect(lng.map((e) => e.toString()), [
          const Rational(73, 1).toString(),
          const Rational(58, 1).toString(),
          const Rational(500, 100).toString(),
        ]);
      });

      test("East Cape Lighthouse", () {
        // -37.688944, 178.548139
        final lat = gpsDoubleToDms(-37.688944);
        final lng = gpsDoubleToDms(178.548139);
        expect(lat.map((e) => e.toString()), [
          const Rational(37, 1).toString(),
          const Rational(41, 1).toString(),
          const Rational(2019, 100).toString(),
        ]);
        expect(lng.map((e) => e.toString()), [
          const Rational(178, 1).toString(),
          const Rational(32, 1).toString(),
          const Rational(5330, 100).toString(),
        ]);
      });
    });

    group("doubleToRational", () {
      test("<1000", () {
        expect(
          doubleToRational(123.456789123).toString(),
          const Rational(12345678, 100000).toString(),
        );
      });

      test(">1000 <100000", () {
        expect(
          doubleToRational(12345.6789123).toString(),
          const Rational(12345678, 1000).toString(),
        );
      });

      test(">100000", () {
        expect(
          doubleToRational(12345678.9123).toString(),
          const Rational(12345678, 1).toString(),
        );
      });
    });
  });
}
