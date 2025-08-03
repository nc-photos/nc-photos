import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/platform/download.dart' as itf;
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_http/np_http.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'download.g.dart';

class DownloadBuilder extends itf.DownloadBuilder {
  @override
  build({
    required String url,
    Map<String, String>? headers,
    String? mimeType,
    required String filename,
    String? parentDir,
    bool? shouldNotify,
    void Function(double progress)? onProgress,
  }) {
    if (getRawPlatform() == NpPlatform.android) {
      return _AndroidDownload(
        url: url,
        headers: headers,
        mimeType: mimeType,
        filename: filename,
        parentDir: parentDir,
        shouldNotify: shouldNotify,
        onProgress: onProgress,
      );
    } else {
      throw UnimplementedError();
    }
  }
}

@npLog
class _AndroidDownload extends itf.Download {
  _AndroidDownload({
    required this.url,
    this.headers,
    this.mimeType,
    required this.filename,
    this.parentDir,
    this.shouldNotify,
    this.onProgress,
  });

  @override
  Future<String> call() async {
    if (_isInitialDownload) {
      await _cleanUp();
      _isInitialDownload = false;
    }
    final file = await _createTempFile();
    try {
      // download file to a temp dir
      final fileWrite = file.openWrite();
      try {
        final uri = Uri.parse(url);
        final req = http.Request("GET", uri)..headers.addAll(headers ?? {});
        final response = await getHttpClient().send(req);
        bool isEnd = false;
        Object? error;
        final size = response.contentLength;
        var received = 0;
        final subscription = response.stream.listen(
          (value) {
            fileWrite.add(value);
            received += value.length;
            if (size != null && size > 0) {
              onProgress?.call((received / size).clamp(0, 1));
            }
          },
          onDone: () {
            isEnd = true;
          },
          onError: (e, stackTrace) {
            _log.severe("Failed while request", e, stackTrace);
            isEnd = true;
            error = e;
          },
          cancelOnError: true,
        );
        // wait until download finished
        while (!isEnd) {
          if (shouldInterrupt) {
            await subscription.cancel();
            break;
          }
          await Future.delayed(const Duration(seconds: 1));
        }
        if (error != null) {
          throw error!;
        }
      } finally {
        await fileWrite.flush();
        await fileWrite.close();
      }
      if (shouldInterrupt) {
        throw const JobCanceledException();
      }

      // copy the file to the actual dir
      return await MediaStore.copyFileToDownload(
        file.path,
        filename: filename,
        subDir: parentDir,
      );
    } finally {
      await file.delete();
    }
  }

  @override
  bool cancel() {
    shouldInterrupt = true;
    return true;
  }

  Future<Directory> _openDownloadDir() async {
    final tempDir = await getTemporaryDirectory();
    final downloadDir = Directory("${tempDir.path}/downloads");
    if (!await downloadDir.exists()) {
      return downloadDir.create();
    } else {
      return downloadDir;
    }
  }

  Future<File> _createTempFile() async {
    final downloadDir = await _openDownloadDir();
    while (true) {
      final fileName = const Uuid().v4();
      final file = File("${downloadDir.path}/$fileName");
      if (await file.exists()) {
        continue;
      }
      return file;
    }
  }

  /// Clean up remaining cache files from previous runs
  ///
  /// Normally the files will be deleted automatically
  Future<void> _cleanUp() async {
    final downloadDir = await _openDownloadDir();
    await for (final f in downloadDir.list(followLinks: false)) {
      _log.warning("[_cleanUp] Deleting file: ${f.path}");
      await f.delete();
    }
  }

  final String url;
  final Map<String, String>? headers;
  final String? mimeType;
  final String filename;
  final String? parentDir;
  final bool? shouldNotify;
  final void Function(double progress)? onProgress;

  bool shouldInterrupt = false;

  static bool _isInitialDownload = true;
}
