import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/use_case/recognize_face/list_recognize_face.dart';
import 'package:nc_photos/use_case/recognize_face/list_recognize_face_item.dart';
import 'package:np_log/np_log.dart';

part 'sync_recognize_face.g.dart';

@npLog
class SyncRecognizeFace {
  const SyncRecognizeFace(this._c);

  /// Sync people in cache db with remote server
  ///
  /// Return if any people were updated
  Future<bool> call(Account account) async {
    _log.info("[call] Sync people with remote");
    final List<RecognizeFace> remote;
    try {
      remote = await ListRecognizeFace(_c.withRemoteRepo())(account).last;
    } catch (e) {
      if (e is ApiException && e.response.statusCode == 404) {
        // recognize app probably not installed, ignore
        _log.info("[call] Recognize app not installed");
        return false;
      }
      rethrow;
    }
    final remoteItems = await _getFaceItems(account, remote);
    return _c.npDb.syncRecognizeFacesAndItems(
      account: account.toDb(),
      data: remoteItems.map(
        (key, value) => MapEntry(
          key.toDb(),
          value.map(DbRecognizeFaceItemConverter.toDb).toList(),
        ),
      ),
    );
  }

  Future<Map<RecognizeFace, List<RecognizeFaceItem>>> _getFaceItems(
    Account account,
    List<RecognizeFace> faces,
  ) async {
    Object? firstError;
    StackTrace? firstStackTrace;
    final remote =
        await ListMultipleRecognizeFaceItem(_c.withRemoteRepo())(
          account,
          faces,
          onError: (f, e, stackTrace) {
            _log.severe(
              "[_getFaceItems] Failed while listing remote face: $f",
              e,
              stackTrace,
            );
            if (firstError == null) {
              firstError = e;
              firstStackTrace = stackTrace;
            }
          },
        ).last;
    if (firstError != null) {
      Error.throwWithStackTrace(
        firstError!,
        firstStackTrace ?? StackTrace.current,
      );
    }
    return remote;
  }

  final DiContainer _c;
}
