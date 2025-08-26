import 'dart:convert';

import 'package:nc_photos/use_case/compat/v34.dart';
import 'package:np_universal_storage/np_universal_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group("CompatV34", () {
    group("isPrefNeedMigration", () {
      test("w/ accounts2", () async {
        SharedPreferences.setMockInitialValues({
          "accounts2": [
            """{"account":{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]},"settings":{"isEnableFaceRecognitionApp":true,"shareFolder":""}}""",
          ],
        });
        expect(await CompatV34.isPrefNeedMigration(), true);
      });

      test("w/ accounts", () async {
        SharedPreferences.setMockInitialValues({
          "accounts": [
            """{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]}""",
          ],
        });
        expect(await CompatV34.isPrefNeedMigration(), true);
      });

      test("w/o accounts(2)", () async {
        SharedPreferences.setMockInitialValues({"hello": "world"});
        expect(await CompatV34.isPrefNeedMigration(), false);
      });
    });

    group("migratePref", () {
      test("from v1", () async {
        SharedPreferences.setMockInitialValues({
          "accounts": [
            """{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]}""",
          ],
        });
        final storage = UniversalMemoryStorage();
        await CompatV34.migratePref(storage);
        final pref = await SharedPreferences.getInstance();
        final result = pref.getStringList("accounts3");
        expect(result?.length, 1);
        expect(
          result![0],
          matches(
            RegExp(
              r"""\{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":\["dir","dir2"\],"id":"[0-9a-f]+-[0-9a-f]+"\}""",
            ),
          ),
        );
        expect(pref.containsKey("accounts"), false);
        final id = jsonDecode(result[0])["id"];
        expect(
          await storage.getString("accounts/$id/pref"),
          """{"isEnableFaceRecognitionApp":true,"shareFolder":""}""",
        );
      });

      test("from v32", () async {
        SharedPreferences.setMockInitialValues({
          "accounts2": [
            """{"account":{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":["dir","dir2"]},"settings":{"isEnableFaceRecognitionApp":true,"shareFolder":""}}""",
          ],
        });
        final storage = UniversalMemoryStorage();
        await CompatV34.migratePref(storage);
        final pref = await SharedPreferences.getInstance();
        final result = pref.getStringList("accounts3");
        expect(result?.length, 1);
        expect(
          result![0],
          matches(
            RegExp(
              r"""\{"scheme":"http","address":"example.com","username":"admin","password":"123456","roots":\["dir","dir2"\],"id":"[0-9a-f]+-[0-9a-f]+"\}""",
            ),
          ),
        );
        expect(pref.containsKey("accounts2"), false);
        final id = jsonDecode(result[0])["id"];
        expect(
          await storage.getString("accounts/$id/pref"),
          """{"isEnableFaceRecognitionApp":true,"shareFolder":""}""",
        );
      });
    });
  });
}
