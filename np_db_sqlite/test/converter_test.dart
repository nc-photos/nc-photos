import 'dart:convert';

import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/src/converter.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/database_extension.dart';
import 'package:test/test.dart';

void main() {
  group("AlbumConverter", () {
    group("fromSql", () {
      test("no share", _AlbumConverter.fromSqlNoShare);
    });
  });
}

abstract class _AlbumConverter {
  static void fromSqlNoShare() {
    final sqlAlbum = Album(
      rowId: 1,
      file: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: """{"items": []}""",
      coverProviderType: "memory",
      coverProviderContent: _stripJsonString("""{
        "coverFile": {
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": "2020-01-02T03:04:05.678901Z"
        }
      }"""),
      sortProviderType: "null",
      sortProviderContent: "{}",
    );
    final src = CompleteAlbum(sqlAlbum, 1, []);
    expect(
      AlbumConverter.fromSql(src),
      DbAlbum(
        fileId: 1,
        fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
        version: 8,
        lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
        name: "test1",
        providerType: "static",
        providerContent: const {"items": []},
        coverProviderType: "memory",
        coverProviderContent: const {
          "coverFile": {
            "fdPath": "remote.php/dav/files/admin/test1.jpg",
            "fdId": 1,
            "fdMime": null,
            "fdIsArchived": false,
            "fdIsFavorite": false,
            "fdDateTime": "2020-01-02T03:04:05.678901Z",
          },
        },
        sortProviderType: "null",
        sortProviderContent: const {},
        shares: const [],
      ),
    );
  }
}

String _stripJsonString(String str) {
  return jsonEncode(jsonDecode(str));
}
