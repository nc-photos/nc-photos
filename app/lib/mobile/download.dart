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
  itf.Download build({
    required String url,
    Map<String, String>? headers,
    String? mimeType,
    required String filename,
    String? parentDir,
    required bool isPublic,
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
        isPublic: isPublic,
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
    required this.isPublic,
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
      if (isPublic) {
        return await MediaStore.copyFileToDownload(
          file.path,
          filename: filename,
          subDir: parentDir,
        );
      } else {
        final dstFile = await _copyFileToInternal(file);
        return await ContentUri.getUriForFile(dstFile.absolute.path);
      }
    } finally {
      await file.delete();
    }
  }

  @override
  bool cancel() {
    shouldInterrupt = true;
    return true;
  }

  Future<Directory> _openTempDir() async {
    final root = await getTemporaryDirectory();
    final dir = Directory("${root.path}/downloads");
    if (!await dir.exists()) {
      return dir.create();
    } else {
      return dir;
    }
  }

  Future<File> _createTempFile() async {
    final dstDir = await _openTempDir();
    while (true) {
      final fileName = const Uuid().v4();
      final file = File("${dstDir.path}/$fileName");
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
    final tempDir = await _openTempDir();
    await for (final f in tempDir.list(followLinks: false)) {
      _log.warning("[_cleanUp] Deleting file: ${f.path}");
      try {
        await f.delete();
      } catch (e, stackTrace) {
        _log.warning("[_cleanUp] Failed while delete", e, stackTrace);
      }
    }

    final shareDir = await _openShareDir();
    await for (final f in shareDir.list(followLinks: false)) {
      _log.warning("[_cleanUp] Deleting file: ${f.path}");
      try {
        await f.delete();
      } catch (e, stackTrace) {
        _log.warning("[_cleanUp] Failed while delete", e, stackTrace);
      }
    }
  }

  Future<Directory> _openShareDir() async {
    final root = await getTemporaryDirectory();
    final dir = Directory("${root.path}/shares");
    if (!await dir.exists()) {
      return dir.create();
    } else {
      return dir;
    }
  }

  Future<File> _copyFileToInternal(File src) async {
    final dstDir = await _openShareDir();
    final dst = File("${dstDir.path}/$filename");
    await src.copy(dst.path);
    return dst;
  }

  final String url;
  final Map<String, String>? headers;
  final String? mimeType;
  final String filename;
  final String? parentDir;
  final bool isPublic;
  final void Function(double progress)? onProgress;

  bool shouldInterrupt = false;

  static bool _isInitialDownload = true;
}
