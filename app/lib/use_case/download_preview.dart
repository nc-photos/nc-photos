import 'package:nc_photos/account.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_platform_util/np_platform_util.dart';

class DownloadPreview {
  Future<dynamic> call(Account account, FileDescriptor file) async {
    assert(getRawPlatform() == NpPlatform.android);
    final previewUrl = getViewerUrlForImageFile(account, file);
    final fileInfo =
        await LargeImageCacheManager.inst.getSingleFile(previewUrl, headers: {
      "authorization": AuthUtil.fromAccount(account).toHeaderValue(),
    });
    return ContentUri.getUriForFile(fileInfo.absolute.path);
  }
}
