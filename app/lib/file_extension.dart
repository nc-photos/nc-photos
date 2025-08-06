import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as path_lib;

extension FileExtension on File {
  Future<String?> readMime() async {
    final header =
        await openRead(
          0,
          defaultMagicNumbersMaxLength,
        ).expand((element) => element).toList();
    return lookupMimeType(path, headerBytes: header);
  }

  String get filename => path_lib.basename(path);
}
