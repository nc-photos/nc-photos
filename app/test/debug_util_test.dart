import 'package:nc_photos/debug_util.dart';
import 'package:test/test.dart';

void main() {
  group("debug_util", () {
    group("logFilename", () {
      test("null", () {
        expect(logFilename(null, shouldLogFileName: false), "null");
      });
      test("path + name + ext", () {
        expect(
          logFilename("path/to/a/fancy_file.ext", shouldLogFileName: false),
          "***/fan***ile.ext",
        );
      });
      test("path + short name + ext", () {
        expect(
          logFilename("path/to/a/file01.ext", shouldLogFileName: false),
          "***/file01.ext",
        );
      });
      test("path + name", () {
        expect(
          logFilename("path/to/a/fancy_file", shouldLogFileName: false),
          "***/fan***ile",
        );
      });
      test("name + ext", () {
        expect(
          logFilename("fancy_file", shouldLogFileName: false),
          "fan***ile",
        );
      });
      test("name", () {
        expect(
          logFilename("fancy_file.ext", shouldLogFileName: false),
          "fan***ile.ext",
        );
      });
    });
  });
}
