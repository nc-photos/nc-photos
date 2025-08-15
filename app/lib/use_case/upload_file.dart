import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/use_case/put_file_binary.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';

class UploadFile {
  const UploadFile(this._c, {required this.account});

  Future<void> call(LocalFile file, {required String relativePath}) {
    if (file is LocalUriFile) {
      return _uploadUriFile(file, relativePath);
    } else {
      throw UnsupportedError("Unsupported local file");
    }
  }

  Future<void> _uploadUriFile(LocalUriFile file, String relativePath) async {
    final bytes = await ContentUri.readUri(file.uri);
    if (relativePath.startsWith("/")) {
      relativePath = relativePath.substring(1);
    }
    final dir = "${api_util.getWebdavRootUrlRelative(account)}/$relativePath";
    final path = "$dir/${file.filename}";
    await PutFileBinary(_c.fileRepo)(account, path, bytes);
  }

  final DiContainer _c;
  final Account account;
}
