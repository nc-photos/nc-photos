import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_http/np_http.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_local_media/np_platform_local_media.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

part 'download_file2.g.dart';

class DownloadPublicFile {
  /// Download a file to a public dir and return its platform identifier
  Future<String> call(
    Account account,
    FileDescriptor file, {
    void Function(double progress)? onProgress,
  }) {
    final url = "${account.url}/${file.fdPath}";
    return _do(
      url: url,
      headers: {"authorization": AuthUtil.fromAccount(account).toHeaderValue()},
      mimeType: file.fdMime,
      filename: file.filename,
      onProgress: onProgress,
    );
  }

  Future<String> _do({
    required String url,
    Map<String, String>? headers,
    required String filename,
    String? mimeType,
    String? parentDir,
    void Function(double progress)? onProgress,
  }) async {
    String? result;
    await _download(
      url: url,
      headers: headers,
      filename: filename,
      interruptor: _interruptor,
      onProgress: onProgress,
      postDownload: (tempFile) async {
        result = await LocalMedia.copyPrivateFileToPublicDir(
          tempFile.path,
          srcMime: mimeType,
          dstDir: parentDir,
        );
      },
    );
    return result!;
  }

  void cancel() {
    _interruptor.add(true);
  }

  final _interruptor = BehaviorSubject.seeded(false);
}

class DownloadInternalTempFile {
  /// Download a temp file to an internal dir and return its path. The temp file
  /// is only guaranteed to be available during this app session
  Future<String> call(
    Account account,
    FileDescriptor file, {
    void Function(double progress)? onProgress,
  }) {
    final url = "${account.url}/${file.fdPath}";
    return _do(
      url: url,
      headers: {"authorization": AuthUtil.fromAccount(account).toHeaderValue()},
      filename: file.filename,
      onProgress: onProgress,
    );
  }

  Future<String> _do({
    required String url,
    Map<String, String>? headers,
    required String filename,
    void Function(double progress)? onProgress,
  }) async {
    String? result;
    await _download(
      url: url,
      headers: headers,
      filename: filename,
      interruptor: _interruptor,
      onProgress: onProgress,
      postDownload: (tempFile) async {
        final dstFile = await _copyFileToInternal(tempFile, filename: filename);
        result = dstFile.absolute.path;
      },
    );
    return result!;
  }

  void cancel() {
    _interruptor.add(true);
  }

  Future<File> _copyFileToInternal(File src, {required String filename}) async {
    final dstDir = await _openInternalDir();
    final dst = File("${dstDir.path}/$filename");
    await src.copy(dst.path);
    return dst;
  }

  final _interruptor = BehaviorSubject.seeded(false);
}

Future<void> _download({
  required String url,
  Map<String, String>? headers,
  required String filename,
  required ValueStream<bool> interruptor,
  void Function(double progress)? onProgress,
  FutureOr<void> Function(File tempFile)? postDownload,
}) async {
  if (_isInitialDownload) {
    await _cleanUp();
    _isInitialDownload = false;
  }
  final (:dir, :file) = await _createTempFile(name: filename);
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
          _$__NpLog.log.severe("Failed while request", e, stackTrace);
          isEnd = true;
          error = e;
        },
        cancelOnError: true,
      );
      // wait until download finished
      while (!isEnd) {
        if (interruptor.valueOrNull == true) {
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
    if (interruptor.valueOrNull == true) {
      throw const JobCanceledException();
    }

    await postDownload?.call(file);
  } finally {
    await dir.delete(recursive: true);
  }
}

Future<({Directory dir, File file})> _createTempFile({
  required String name,
}) async {
  final dstDir = await _openTempDir();
  while (true) {
    final dirName = const Uuid().v4();
    final dir = Directory("${dstDir.path}/$dirName");
    if (await FileSystemEntity.type(dir.path) !=
        FileSystemEntityType.notFound) {
      continue;
    }
    await dir.create();
    return (dir: dir, file: File("${dir.path}/$name"));
  }
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

Future<Directory> _openInternalDir() async {
  final root = await getTemporaryDirectory();
  final dir = Directory("${root.path}/shares");
  if (!await dir.exists()) {
    return dir.create();
  } else {
    return dir;
  }
}

/// Clean up remaining cache files from previous runs
///
/// Normally the files will be deleted automatically
Future<void> _cleanUp() async {
  final tempDir = await _openTempDir();
  await for (final f in tempDir.list(followLinks: false)) {
    _$__NpLog.log.warning("[_cleanUp] Deleting file: ${f.path}");
    try {
      await f.delete(recursive: true);
    } catch (e, stackTrace) {
      _$__NpLog.log.warning("[_cleanUp] Failed while delete", e, stackTrace);
    }
  }

  final shareDir = await _openInternalDir();
  await for (final f in shareDir.list(followLinks: false)) {
    _$__NpLog.log.warning("[_cleanUp] Deleting file: ${f.path}");
    try {
      await f.delete(recursive: true);
    } catch (e, stackTrace) {
      _$__NpLog.log.warning("[_cleanUp] Failed while delete", e, stackTrace);
    }
  }
}

bool _isInitialDownload = true;

@npLog
// ignore: camel_case_types
class __ {}
