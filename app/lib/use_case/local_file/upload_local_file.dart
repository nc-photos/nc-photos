import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_http/np_http.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';

class UploadLocalFile {
  const UploadLocalFile({required this.account});

  Future<void> call(LocalFile file, {required String relativePath}) {
    if (file is LocalUriFile) {
      return _uploadUriFile(file, relativePath);
    } else {
      throw UnsupportedError("Unsupported local file");
    }
  }

  Future<void> _uploadUriFile(LocalUriFile file, String relativePath) async {
    if (relativePath.startsWith("/")) {
      relativePath = relativePath.substring(1);
    }
    final dir = "${api_util.getWebdavRootUrl(account)}/$relativePath";
    final path = "$dir/${file.filename}";
    await Uploader.asyncUpload(
      uploadables: [
        _LocalUriUploadable(uploadPath: path, contentUri: file.uri),
      ],
      headers: {
        "Content-Type": "application/octet-stream",
        "User-Agent": getAppUserAgent(),
        "Authorization": AuthUtil.fromAccount(account).toHeaderValue(),
      },
    );
  }

  final Account account;
}

class _LocalUriUploadable implements AndroidUploadable {
  const _LocalUriUploadable({
    required this.uploadPath,
    required this.contentUri,
  });

  @override
  final String uploadPath;
  @override
  final String contentUri;
}
