import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/exception_util.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/try_or_null.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;

part 'any_file_util.g.dart';

Future<(T, U, V)> handleAnyFileIdByType<T, U, V>(
  Iterable<String> afIds, {
  required FutureOr<T> Function(List<({String afId, int fileId})> ids)
  nextcloudHandler,
  required FutureOr<U> Function(List<({String afId, String fileId})> ids)
  localHandler,
  required FutureOr<V> Function(
    List<({String afId, int remoteFileId, String localFileId})> ids,
  )
  mergedHandler,
}) async {
  final groups = afIds.groupBy(
    key: (e) => tryOrNull(() => AnyFileProviderType.fromId(e)),
  );
  if (groups[null]?.isNotEmpty == true) {
    _$__NpLog.log.severe(
      "[handleAnyFileIdByType] Unknown ids: ${groups[null]}",
    );
  }
  final nextcloudIds =
      (groups[AnyFileProviderType.nextcloud] ?? [])
          .map((e) {
            try {
              return (afId: e, fileId: AnyFileNextcloudProvider.parseAfId(e));
            } catch (err, stackTrace) {
              _$__NpLog.log.severe(
                "[handleAnyFileIdByType] Failed to parse nextcloud file id: $e",
                err,
                stackTrace,
              );
              return null;
            }
          })
          .nonNulls
          .toList();
  final localIds =
      (groups[AnyFileProviderType.local] ?? [])
          .map((e) {
            try {
              return (afId: e, fileId: AnyFileLocalProvider.parseAfId(e));
            } catch (err, stackTrace) {
              _$__NpLog.log.severe(
                "[handleAnyFileIdByType] Failed to parse local file id: $e",
                err,
                stackTrace,
              );
              return null;
            }
          })
          .nonNulls
          .toList();
  final mergedIds =
      (groups[AnyFileProviderType.merged] ?? [])
          .map((e) {
            try {
              final ids = AnyFileMergedProvider.parseAfId(e);
              return (
                afId: e,
                remoteFileId: AnyFileNextcloudProvider.parseAfId(
                  ids.remoteAfId,
                ),
                localFileId: AnyFileLocalProvider.parseAfId(ids.localAfId),
              );
            } catch (err, stackTrace) {
              _$__NpLog.log.severe(
                "[handleAnyFileIdByType] Failed to parse local file id: $e",
                err,
                stackTrace,
              );
              return null;
            }
          })
          .nonNulls
          .toList();
  try {
    return await (
      Future.value(nextcloudHandler(nextcloudIds)),
      Future.value(localHandler(localIds)),
      Future.value(mergedHandler(mergedIds)),
    ).wait;
  } on ParallelWaitError catch (pe) {
    _$__NpLog.log.severe(
      "[handleAnyFileIdByType] Exceptions, 1: ${pe.errors.$1}, 2: ${pe.errors.$2}",
    );
    final (e, stackTrace) = firstErrorOf2(pe);
    Error.throwWithStackTrace(e, stackTrace);
  }
}

int anyFileMergeSorter(AnyFile a, AnyFile b) => deconstructedAnyFileMergeSorter(
  (filename: a.name, dateTime: a.dateTime),
  (filename: b.name, dateTime: b.dateTime),
);

int deconstructedAnyFileMergeSorter(
  ({String filename, DateTime dateTime}) a,
  ({String filename, DateTime dateTime}) b,
) {
  if (a.dateTime.difference(b.dateTime).abs() < const Duration(minutes: 1)) {
    var x = path_lib
        .basenameWithoutExtension(a.filename)
        .compareTo(path_lib.basenameWithoutExtension(b.filename));
    if (x == 0) {
      x = a.dateTime.compareTo(b.dateTime);
    }
    return x;
  } else {
    return a.dateTime.compareTo(b.dateTime);
  }
}

bool isAnyFileMergeable(AnyFile a, AnyFile b) {
  return isDeconstructedAnyFileMergeable(
    (
      filename: a.name,
      dateTime: a.dateTime,
      isRemote: a.provider is AnyFileNextcloudProvider,
    ),
    (
      filename: b.name,
      dateTime: b.dateTime,
      isRemote: b.provider is AnyFileNextcloudProvider,
    ),
  );
}

bool isDeconstructedAnyFileMergeable(
  ({String filename, DateTime dateTime, bool isRemote}) a,
  ({String filename, DateTime dateTime, bool isRemote}) b,
) {
  return path_lib.basenameWithoutExtension(a.filename) ==
          path_lib.basenameWithoutExtension(b.filename) &&
      a.dateTime.difference(b.dateTime).abs() < const Duration(minutes: 1) &&
      a.isRemote != b.isRemote;
}

@npLog
// ignore: camel_case_types
class __ {}
