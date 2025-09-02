import 'package:collection/collection.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/use_case/local_file/upload_local_file.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';

class UploadAnyFile {
  const UploadAnyFile({required this.account});

  void call(
    List<AnyFile> files, {
    required String relativePath,
    ConvertConfig? convertConfig,
  }) {
    final groups = groupBy(
      files,
      (e) => switch (e.provider) {
        AnyFileNextcloudProvider _ => AnyFileProviderType.nextcloud,
        AnyFileLocalProvider _ => AnyFileProviderType.local,
      },
    );
    if (groups[AnyFileProviderType.local]?.isNotEmpty == true) {
      UploadLocalFile(account: account).multiple(
        groups[AnyFileProviderType.local]!
            .map((e) => (e.provider as AnyFileLocalProvider).file)
            .toList(),
        relativePath: relativePath,
        convertConfig: convertConfig,
      );
    }
  }

  final Account account;
}
