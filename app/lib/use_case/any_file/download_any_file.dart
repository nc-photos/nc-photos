import 'package:collection/collection.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/download_handler.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';

class DownloadAnyFile {
  const DownloadAnyFile(this._c, {required this.account});

  Future<void> call(List<AnyFile> files, {String? parentDir}) {
    final groups = groupBy(
      files,
      (e) => switch (e.provider) {
        AnyFileNextcloudProvider _ => AnyFileProviderType.nextcloud,
        AnyFileLocalProvider _ => AnyFileProviderType.local,
        AnyFileMergedProvider _ => AnyFileProviderType.merged,
      },
    );
    if (groups[AnyFileProviderType.nextcloud]?.isNotEmpty == true) {
      return DownloadHandler(_c).downloadFiles(
        account,
        groups[AnyFileProviderType.nextcloud]!
            .map((e) => (e.provider as AnyFileNextcloudProvider).file)
            .toList(),
      );
    } else {
      return Future.value();
    }
  }

  final DiContainer _c;
  final Account account;
}
