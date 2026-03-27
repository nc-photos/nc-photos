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
        expect(result!.names["en"]!.name, "Ringsted");
        expect(result.names["en"]!.admin1, "Zealand");
        expect(result.names["en"]!.admin2, "Ringsted Kommune");
      });
      test("Cape Town", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(-33.913557, 18.4230705);
        expect(result!.names["en"]!.name, "Cape Town");
        expect(result.names["en"]!.admin1, "Western Cape");
        expect(result.names["en"]!.admin2, "City of Cape Town");
      });
    });
    group("ja", () {
      test("Asakusa", () async {
        final rg = ReverseGeocoder();
        await rg.init(dbBuilder: _openDb);
        final result = await rg(35.713549, 139.7919729);
        expect(result!.names["ja"]!.name, "浅草");
        expect(result.names["ja"]!.admin1, "東京都");
        expect(result.names["ja"]!.admin2, "台東区");
      });
    });
    test("admin only", () async {
      final rg = ReverseGeocoder();
      await rg.init(dbBuilder: _openDb);
      final result = await rg(25.1549, 55.2102);
      expect(result!.names["fr"]!.name, null);
      expect(result.names["fr"]!.admin1, "Dubaï");
      expect(result.names["fr"]!.admin2, null);
    });
  });
}

CommonDatabase _openDb() {
  return sqlite3.open("test/cities_2.sqlite", mode: OpenMode.readOnly);
}
