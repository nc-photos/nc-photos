import 'package:http/http.dart' as http;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/platform/download.dart' as itf;
import 'package:nc_photos/web/file_saver.dart';
import 'package:np_http/np_http.dart';

class DownloadBuilder extends itf.DownloadBuilder {
  @override
  build({
    required String url,
    Map<String, String>? headers,
    String? mimeType,
    required String filename,
    String? parentDir,
    bool? shouldNotify,
  }) {
    return _WebDownload(url: url, headers: headers, filename: filename);
  }
}

class _WebDownload extends itf.Download {
  _WebDownload({required this.url, this.headers, required this.filename});

  @override
  call() async {
    final uri = Uri.parse(url);
    final req = http.Request("GET", uri)..headers.addAll(headers ?? {});
    final response = await http.Response.fromStream(
      await getHttpClient().send(req),
    );
    if (response.statusCode ~/ 100 != 2) {
      throw DownloadException(
        "Failed downloading $filename (HTTP ${response.statusCode})",
      );
    }
    final saver = FileSaver();
    await saver.saveFile(filename, response.bodyBytes);
  }

  @override
  cancel() => false;

  final String url;
  final Map<String, String>? headers;
  final String filename;
}
