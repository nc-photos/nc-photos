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

  Future<void> call(
    LocalFile file, {
    required String relativePath,
    ConvertConfig? convertConfig,
  }) {
    if (file is LocalUriFile) {
      return _uploadUriFile([file], relativePath, convertConfig: convertConfig);
    } else {
      throw UnsupportedError("Unsupported local file");
    }
  }

  Future<void> multiple(
    List<LocalFile> files, {
    required String relativePath,
    ConvertConfig? convertConfig,
  }) {
    final uriFiles = files.whereType<LocalUriFile>().toList();
    return _uploadUriFile(uriFiles, relativePath, convertConfig: convertConfig);
  }

  Future<void> _uploadUriFile(
    List<LocalUriFile> files,
    String relativePath, {
    ConvertConfig? convertConfig,
  }) async {
    _log.info(
      "[_uploadUriFile] Uploading ${files.length} files to $relativePath, convertConfig: $convertConfig",
    );
    if (relativePath.startsWith("/")) {
      relativePath = relativePath.substring(1);
    }
    final dir = "${api_util.getWebdavRootUrl(account)}/$relativePath";
    await Uploader.asyncUpload(
      uploadables:
          files.map((e) {
            final canConvert = supportedConvertSrcMimes.contains(e.mime);
            final String filename;
            if (convertConfig != null && canConvert) {
              final basename = path_lib.basenameWithoutExtension(e.filename);
              filename = "$basename.${convertConfig.getExtension()}";
            } else {
              filename = e.filename;
            }
            final path = "$dir/$filename";
            return _LocalUriUploadable(
              uploadPath: path,
              contentUri: e.uri,
              canConvert: canConvert,
            );
          }).toList(),
      headers: {
        "Content-Type": "application/octet-stream",
        "User-Agent": getAppUserAgent(),
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
      convertConfig: convertConfig,
    );
  }

  final Account account;
}

class _LocalUriUploadable implements AndroidUploadable {
  const _LocalUriUploadable({
    required this.uploadPath,
    required this.contentUri,
    required this.canConvert,
  });

  @override
  final String uploadPath;
  @override
  final String contentUri;
  @override
  final bool canConvert;
}

extension on ConvertConfig {
  String getExtension() {
    return switch (format) {
      ConvertFormat.jpeg => "jpg",
      ConvertFormat.jxl => "jxl",
    };
  }
}
