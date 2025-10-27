import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file_util.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/local_file/repo.dart';
import 'package:nc_photos/exception_util.dart';
import 'package:nc_photos/use_case/file/list_file_id_with_timestamp.dart';
import 'package:nc_photos/use_case/local_file/list_local_file_id_with_timestamp.dart';
import 'package:np_log/np_log.dart';

part 'list_any_file_id_with_timestamp.g.dart';

class AnyFileIdWithTimestamp {
  const AnyFileIdWithTimestamp({
    required this.afId,
    required this.timestamp,
    required this.filename,
  });

  final String afId;
  final int timestamp;
  final String filename;
}

@npLog
class ListAnyFileIdWithTimestamp {
  const ListAnyFileIdWithTimestamp({
    required this.fileRepo,
    required this.localFileRepo,
    required this.prefController,
  });

  Future<List<AnyFileIdWithTimestamp>> call(
    Account account,
    String shareDirPath, {
    List<String>? localDirWhitelist,
    bool? isArchived,
  }) async {
    try {
      final (remote, local) =
          await (
            ListFileIdWithTimestamp(fileRepo: fileRepo)(
              account,
              shareDirPath,
              isArchived: isArchived,
            ),
            ListLocalFileIdWithTimestamp(
              localFileRepo: localFileRepo,
              prefController: prefController,
            )(dirWhitelist: localDirWhitelist),
          ).wait;
      final remote2 =
          remote
              .map(
                (e) => _AnyFileIdWithTimestamp(
                  afId: AnyFileNextcloudProvider.toAfId(e.fileId),
                  timestamp: e.timestamp,
                  filename: e.filename,
                  type: _AnyFileType.remote,
                ),
              )
              .toList();
      final local2 =
          local
              .map(
                (e) => _AnyFileIdWithTimestamp(
                  afId: AnyFileLocalProvider.toAfId(e.fileId),
                  timestamp: e.timestamp,
                  filename: e.filename,
                  type: _AnyFileType.local,
                ),
              )
              .toList();
      final sorted = [...remote2, ...local2]..sort(
        (a, b) => deconstructedAnyFileMergeSorter(
          (
            filename: a.filename,
            dateTime: DateTime.fromMillisecondsSinceEpoch(
              a.timestamp,
              isUtc: true,
            ),
          ),
          (
            filename: b.filename,
            dateTime: DateTime.fromMillisecondsSinceEpoch(
              b.timestamp,
              isUtc: true,
            ),
          ),
        ),
      );
      final merged = <_AnyFileIdWithTimestamp>[];
      for (final e in sorted) {
        if (merged.isEmpty) {
          merged.add(e);
          continue;
        }
        if (merged.last.type != _AnyFileType.merged &&
            isDeconstructedAnyFileMergeable(
              (
                filename: merged.last.filename,
                dateTime: DateTime.fromMillisecondsSinceEpoch(
                  merged.last.timestamp,
                  isUtc: true,
                ),
                isRemote: merged.last.type == _AnyFileType.remote,
              ),
              (
                filename: e.filename,
                dateTime: DateTime.fromMillisecondsSinceEpoch(
                  e.timestamp,
                  isUtc: true,
                ),
                isRemote: e.type == _AnyFileType.remote,
              ),
            )) {
          // merge
          final replace = merged.removeLast();
          final remote = replace.type == _AnyFileType.remote ? replace : e;
          final local = replace.type == _AnyFileType.local ? replace : e;
          merged.add(
            _AnyFileIdWithTimestamp(
              afId: AnyFileMergedProvider.toAfId(
                remoteAfId: remote.afId,
                localAfId: local.afId,
              ),
              filename: remote.filename,
              timestamp: remote.timestamp,
              type: _AnyFileType.merged,
            ),
          );
        } else {
          merged.add(e);
        }
      }
      merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return merged;
    } on ParallelWaitError catch (pe) {
      _log.severe("[call] Exceptions, 1: ${pe.errors.$1}, 2: ${pe.errors.$2}");
      final (e, stackTrace) = firstErrorOf2(pe);
      Error.throwWithStackTrace(e, stackTrace);
    }
  }

  final FileRepo2 fileRepo;
  final LocalFileRepo localFileRepo;
  final PrefController prefController;
}

enum _AnyFileType { remote, local, merged }

class _AnyFileIdWithTimestamp extends AnyFileIdWithTimestamp {
  const _AnyFileIdWithTimestamp({
    required super.afId,
    required super.timestamp,
    required super.filename,
    required this.type,
  });

  final _AnyFileType type;
}
