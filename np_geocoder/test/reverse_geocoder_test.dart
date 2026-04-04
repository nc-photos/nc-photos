import 'package:np_geocoder/src/reverse_geocoder.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  group("ReverseGeocoder", () {
    group("en", () {
      test("Ringsted", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(55.4441221, 11.7880129);
        expect(result!.city?.name.lang("en"), "Ringsted");
        expect(result.admin1?.name.lang("en"), "Zealand");
        expect(result.admin2?.name.lang("en"), "Ringsted Kommune");
      });
      test("Cape Town", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(-33.913557, 18.4230705);
        expect(result!.city?.name.lang("en"), "Cape Town");
        expect(result.admin1?.name.lang("en"), "Western Cape");
        expect(result.admin2?.name.lang("en"), "City of Cape Town");
      });
    });
    group("ja", () {
      test("Asakusa", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(35.713549, 139.7919729);
        expect(result!.city?.name.lang("ja"), "浅草");
        expect(result.admin1?.name.lang("ja"), "東京都");
        expect(result.admin2?.name.lang("ja"), "台東区");
      });
    });
    group("zh", () {
      test("hant string w/ hans locale", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(42.69751, 23.32415);
        expect(result!.city?.name.lang("zh", "hans"), "索菲亞");
      });
      test("hans string w/ hant locale", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(32.75893, 119.88512);
        expect(result!.city?.name.lang("zh", "hant"), "陈堡");
      });
    });
    test("admin only", () async {
      final rg = ReverseGeocoder();
      await rg.init(dbBuilder: _openDb);
      final result = await rg(25.1549, 55.2102);
      expect(result!.city?.name.lang("fr"), null);
      expect(result.admin1?.name.lang("fr"), "Dubaï");
      expect(result.admin2?.name.lang("fr"), null);
    });
  });
}

CommonDatabase _openDb() {
  return sqlite3.open("test/cities_2.sqlite", mode: OpenMode.readOnly);
}
