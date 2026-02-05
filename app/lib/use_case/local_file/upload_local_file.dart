import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_http/np_http.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';
import 'package:path/path.dart' as path_lib;

part 'upload_local_file.g.dart';

@npLog
class UploadLocalFile {
  const UploadLocalFile({required this.account});

  void call(
    LocalFile file, {
    required String relativePath,
    ConvertConfig? convertConfig,
    void Function(bool isSuccess)? onResult,
  }) {
    _uploadFile(
      [file],
      relativePath,
      convertConfig: convertConfig,
      onResult: (_, isSuccess) {
        onResult?.call(isSuccess);
      },
    );
  }

  void multiple(
    List<LocalFile> files, {
    required String relativePath,
    ConvertConfig? convertConfig,
    void Function(LocalFile file, bool isSuccess)? onResult,
  }) {
    _uploadFile(
      files,
      relativePath,
      convertConfig: convertConfig,
      onResult: onResult,
    );
  }

  void _uploadFile(
    List<LocalFile> files,
    String relativePath, {
    ConvertConfig? convertConfig,
    void Function(LocalFile file, bool isSuccess)? onResult,
  }) {
    _log.info(
      "[_uploadFile] Uploading ${files.length} files to $relativePath, convertConfig: $convertConfig",
    );
    if (relativePath.startsWith("/")) {
      relativePath = relativePath.substring(1);
    }
    final dir = "${api_util.getWebdavRootUrl(account)}/$relativePath";
    Uploader.asyncUpload(
      uploadables:
          files.map((e) {
            final canConvert = supportedConvertSrcMimes.contains(e.mime);
            final srcFilename = e.filename ?? "file";
            final String dstFilename;
            if (convertConfig != null && canConvert) {
              final basename = path_lib.basenameWithoutExtension(srcFilename);
              dstFilename = "$basename.${convertConfig.getExtension()}";
            } else {
              dstFilename = srcFilename;
            }
            final path = "$dir/$dstFilename";
            return Uploadable(
              platformIdentifier: e.platformIdentifier,
              uploadPath: path,
              canConvert: canConvert,
            );
          }).toList(),
      headers: {
        "Content-Type": "application/octet-stream",
        "User-Agent": getAppUserAgent(),
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
      convertConfig: convertConfig,
      onResult: (uploadable, isSuccess) {
        final localFile = files.firstWhereOrNull(
          (e) => e.platformIdentifier == uploadable.platformIdentifier,
        );
        if (localFile != null) {
          onResult?.call(localFile, isSuccess);
        }
      },
    );
  }

  final Account account;
}

extension on ConvertConfig {
  String getExtension() {
    return switch (format) {
      ConvertFormat.jpeg => "jpg",
      ConvertFormat.jxl => "jxl",
    };
  }
}
