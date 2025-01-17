import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/use_case/face_recognition_person/list_face_recognition_person.dart';
import 'package:np_log/np_log.dart';

part 'sync_face_recognition_person.g.dart';

@npLog
class SyncFaceRecognitionPerson {
  const SyncFaceRecognitionPerson(this._c);

  /// Sync people in cache db with remote server
  ///
  /// Return if any people were updated
  Future<bool> call(Account account) async {
    _log.info("[call] Sync people with remote");
    final List<FaceRecognitionPerson> remote;
    try {
      remote =
          await ListFaceRecognitionPerson(_c.withRemoteRepo())(account).last;
    } catch (e) {
      if (e is ApiException && e.response.statusCode == 404) {
        // face recognition app probably not installed, ignore
        _log.info("[call] Face Recognition app not installed");
        return false;
      }
      rethrow;
    }
    final result = await _c.npDb.syncFaceRecognitionPersons(
      account: account.toDb(),
      persons: remote.map(DbFaceRecognitionPersonConverter.toDb).toList(),
    );
    return result.insert > 0 || result.delete > 0 || result.update > 0;
  }

  final DiContainer _c;
}
