import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:sqlite3/wasm.dart';

// Web is no longer supported. The code here has been updated to make it build
// with the latest sqlite3 package, but they are untested
Future<CommonDatabase> openRawSqliteDbFromAsset(
  String assetRelativePath,
  String outputFilename, {
  bool isReadOnly = false,
}) async {
  final response = await http.get(Uri.parse("sqlite3.wasm"));
  final sqlite3 = await WasmSqlite3.load(response.bodyBytes);
  final fs = await IndexedDbFileSystem.open(dbName: "nc-photos");
  sqlite3.registerVirtualFileSystem(fs, makeDefault: true);

  if (fs.xAccess("/app-file/$outputFilename", SqlFlag.SQLITE_OPEN_READONLY) ==
      0) {
    // copy file from assets
    final blob = await rootBundle.load("assets/$assetRelativePath");
    final buffer = blob.buffer;
    final f = fs.xOpen(
      Sqlite3Filename("/app-file/$outputFilename"),
      SqlFlag.SQLITE_OPEN_CREATE | SqlFlag.SQLITE_OPEN_READWRITE,
    );
    f.file.xWrite(
      buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
      0,
    );
    await fs.flush();
  }
  return sqlite3.open("/app-file/$outputFilename");
}
