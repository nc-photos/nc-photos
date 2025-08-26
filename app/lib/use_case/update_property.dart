import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';

part 'update_property.g.dart';

@npLog
class UpdateProperty {
  const UpdateProperty({required this.fileRepo});

  final FileRepo2 fileRepo;

  Future<void> call(
    Account account,
    FileDescriptor file, {
    OrNull<Metadata>? metadata,
    OrNull<bool>? isArchived,
    OrNull<DateTime>? overrideDateTime,
    bool? favorite,
    OrNull<ImageLocation>? location,
  }) async {
    if (metadata == null &&
        isArchived == null &&
        overrideDateTime == null &&
        favorite == null &&
        location == null) {
      // ?
      _log.warning("[call] Nothing to update");
      return;
    }

    await fileRepo.updateProperty(
      account,
      file,
      metadata: metadata,
      isArchived: isArchived,
      overrideDateTime: overrideDateTime,
      favorite: favorite,
      location: location,
    );
  }
}

extension UpdatePropertyExtension on UpdateProperty {
  /// Convenience function to only update metadata
  ///
  /// See [UpdateProperty.call]
  Future<void> updateMetadata(Account account, File file, Metadata metadata) =>
      call(account, file, metadata: OrNull(metadata));

  /// Convenience function to only update isArchived
  ///
  /// See [UpdateProperty.call]
  Future<void> updateIsArchived(Account account, File file, bool isArchived) =>
      call(account, file, isArchived: OrNull(isArchived));

  /// Convenience function to only update overrideDateTime
  ///
  /// See [UpdateProperty.call]
  Future<void> updateOverrideDateTime(
    Account account,
    File file,
    DateTime overrideDateTime,
  ) => call(account, file, overrideDateTime: OrNull(overrideDateTime));
}
