import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/exception_util.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/try_or_null.dart';
import 'package:np_log/np_log.dart';

part 'any_file_util.g.dart';

Future<(T, U)> handleAnyFileIdByType<T, U>(
  List<String> afIds, {
  required FutureOr<T> Function(List<({String afId, int fileId})> ids)
  nextcloudHandler,
  required FutureOr<U> Function(List<({String afId, String fileId})> ids)
  localHandler,
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
  try {
    return await (
      Future.value(nextcloudHandler(nextcloudIds)),
      Future.value(localHandler(localIds)),
    ).wait;
  } on ParallelWaitError catch (pe) {
    _$__NpLog.log.severe(
      "[handleAnyFileIdByType] Exceptions, 1: ${pe.errors.$1}, 2: ${pe.errors.$2}",
    );
    final (e, stackTrace) = firstErrorOf2(pe);
    Error.throwWithStackTrace(e, stackTrace);
  }
}

@npLog
// ignore: camel_case_types
class __ {}
