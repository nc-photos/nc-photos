import 'package:nc_photos/entity/exif.dart';
import 'package:nc_photos/use_case/compat/v32.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group("CompatV32", () {
    group("isPrefNeedMigration", () {
      test("w/ accounts", () async {
        SharedPreferences.setMockInitialValues({
          "accounts": [
            """{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]}""",
          ],
        });
        expect(await CompatV32.isPrefNeedMigration(), true);
      });

      test("w/o accounts", () async {
        SharedPreferences.setMockInitialValues({"hello": "world"});
        expect(await CompatV32.isPrefNeedMigration(), false);
      });
    });

    test("migratePref", () async {
      SharedPreferences.setMockInitialValues({
        "accounts": [
          """{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]}""",
        ],
      });
      await CompatV32.migratePref();
      final pref = await SharedPreferences.getInstance();
      expect(pref.getStringList("accounts2"), [
        """{"account":{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]},"settings":{"isEnableFaceRecognitionApp":true}}""",
      ]);
      expect(pref.containsKey("accounts"), false);
    });

    group("isExifNeedMigration", () {
      test("w/ UserComment", () async {
        final exif = Exif(<String, dynamic>{
          "UserComment": [1, 2, 3],
        });
        expect(CompatV32.isExifNeedMigration(exif), true);
      });

      test("w/ MakerNote", () async {
        final exif = Exif(<String, dynamic>{
          "MakerNote": [1, 2, 3],
        });
        expect(CompatV32.isExifNeedMigration(exif), true);
      });

      test("w/o migration", () async {
        final exif = Exif(<String, dynamic>{"Maker": "Super"});
        expect(CompatV32.isExifNeedMigration(exif), false);
      });
    });

    group("migrateExif", () {
      test("w/ UserComment", () async {
        final exif = Exif(<String, dynamic>{
          "Maker": "Super",
          "UserComment": [1, 2, 3],
        });
        expect(
          CompatV32.migrateExif(exif, ""),
          Exif(<String, dynamic>{"Maker": "Super"}),
        );
      });

      test("w/ MakerNote", () async {
        final exif = Exif(<String, dynamic>{
          "Maker": "Super",
          "MakerNote": [1, 2, 3],
        });
        expect(
          CompatV32.migrateExif(exif, ""),
          Exif(<String, dynamic>{"Maker": "Super"}),
        );
      });

      test("w/o migration", () async {
        final exif = Exif(<String, dynamic>{"Maker": "Super"});
        expect(
          CompatV32.migrateExif(exif, ""),
          Exif(<String, dynamic>{"Maker": "Super"}),
        );
      });
    });
  });
}
