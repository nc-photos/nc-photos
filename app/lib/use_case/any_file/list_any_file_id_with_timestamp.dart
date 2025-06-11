import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/local_file/repo.dart';
import 'package:nc_photos/use_case/file/list_file_id_with_timestamp.dart';
import 'package:nc_photos/use_case/local_file/list_local_file_id_with_timestamp.dart';
import 'package:np_collection/np_collection.dart';

class AnyFileIdWithTimestamp {
  const AnyFileIdWithTimestamp({required this.afId, required this.timestamp});

  final String afId;
  final int timestamp;
}

class ListAnyFileIdWithTimestamp {
  const ListAnyFileIdWithTimestamp({
    required this.fileRepo,
    required this.localFileRepo,
  });

  Future<List<AnyFileIdWithTimestamp>> call(
    Account account,
    String shareDirPath, {
    bool? isArchived,
  }) async {
    final (remote, local) =
        await (
          ListFileIdWithTimestamp(fileRepo: fileRepo)(
            account,
            shareDirPath,
            isArchived: isArchived,
          ),
          ListLocalFileIdWithTimestamp(localFileRepo: localFileRepo)(),
        ).wait;
    final remote2 =
        remote
            .map(
              (e) => AnyFileIdWithTimestamp(
                afId: AnyFileNextcloudProvider.toAfId(e.fileId),
                timestamp: e.timestamp,
              ),
            )
            .toList();
    final local2 =
        local
            .map(
              (e) => AnyFileIdWithTimestamp(
                afId: AnyFileLocalProvider.toAfId(e.fileId),
                timestamp: e.timestamp,
              ),
            )
            .toList();
    return mergeSortedLists(remote2.reversed, local2.reversed, (a, b) {
      var diff = a.timestamp.compareTo(b.timestamp);
      if (diff == 0) {
        diff = b.afId.compareTo(a.afId);
      }
      return diff;
    }).reversed.toList();
  }

  final FileRepo2 fileRepo;
  final LocalFileRepo localFileRepo;
}
