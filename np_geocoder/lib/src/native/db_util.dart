import 'dart:io' as io;

import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zstandard/zstandard.dart';

part 'db_util.g.dart';

Future<CommonDatabase> openRawSqliteDbFromAsset({
  bool isReadOnly = false,
}) async {
  final dir = await _openDir();
  final file = io.File(path_lib.join(dir.path, "cities_2.sqlite"));
  if (!await file.exists()) {
    // remove old dbs
    await _cleanUp();
    // copy file from assets
    final blob = await rootBundle.load(
      "packages/np_geocoder/assets/cities_2.sqlite.zst",
    );
    final buffer = blob.buffer;
    final zstd = Zstandard();
    final decompressed = await zstd.decompress(
      buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
    );
    final tempFile = io.File(path_lib.join(dir.path, "cities_2.sqlite.tmp"));
    await tempFile.writeAsBytes(decompressed!, flush: true);
    await tempFile.rename(file.path);
  }
  return sqlite3.open(
    file.path,
    mode: isReadOnly ? OpenMode.readOnly : OpenMode.readWriteCreate,
  );
}

Future<io.Directory> _openDir() async {
  final root = await getApplicationDocumentsDirectory();
  final dir = io.Directory("${root.path}/geocoder");
  if (!await dir.exists()) {
    return dir.create();
  } else {
    return dir;
  }
}

Future<void> _cleanUp() async {
  final dir = await _openDir();
  await for (final f in dir.list(followLinks: false)) {
    _log.warning("[_cleanUp] Deleting file: ${f.path}");
    try {
      await f.delete(recursive: true);
    } catch (e, stackTrace) {
      _log.warning("[_cleanUp] Failed while delete", e, stackTrace);
    }
  }
}

@npLog
// ignore: camel_case_types
class __ {}

final Logger _log = _$__NpLog.log;
