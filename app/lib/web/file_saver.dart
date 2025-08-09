// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:nc_photos/platform/file_saver.dart' as itf;

class FileSaver extends itf.FileSaver {
  @override
  saveFile(String filename, Uint8List content) async {
    js.context.callMethod("webSaveAs", [
      html.Blob([content]),
      filename,
    ]);
  }
}
