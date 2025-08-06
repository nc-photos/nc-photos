import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/face_recognition_face.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/entity/face_recognition_person/repo.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class FaceRecognitionPersonRemoteDataSource
    implements FaceRecognitionPersonDataSource {
  const FaceRecognitionPersonRemoteDataSource();

  @override
  Future<List<FaceRecognitionPerson>> getPersons(Account account) async {
    _log.info("[getPersons] $account");
    final response =
        await ApiUtil.fromAccount(
          account,
        ).ocs().facerecognition().persons().get();
    if (!response.isGood) {
      _log.severe("[getPersons] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiPersons = await api.FaceRecognitionPersonParser().parse(
      response.body,
    );
    return apiPersons.map(ApiFaceRecognitionPersonConverter.fromApi).toList();
  }

  @override
  Future<List<FaceRecognitionFace>> getFaces(
    Account account,
    FaceRecognitionPerson person,
  ) async {
    _log.info("[getFaces] $person");
    final response =
        await ApiUtil.fromAccount(
          account,
        ).ocs().facerecognition().person(person.name).faces().get();
    if (!response.isGood) {
      _log.severe("[getFaces] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiFaces = await api.FaceRecognitionFaceParser().parse(response.body);
    return apiFaces.map(ApiFaceRecognitionFaceConverter.fromApi).toList();
  }
}

@npLog
class FaceRecognitionPersonSqliteDbDataSource
    implements FaceRecognitionPersonDataSource {
  const FaceRecognitionPersonSqliteDbDataSource(this.db);

  @override
  Future<List<FaceRecognitionPerson>> getPersons(Account account) async {
    _log.info("[getPersons] $account");
    final results = await db.getFaceRecognitionPersons(account: account.toDb());
    return results
        .map((p) {
          try {
            return DbFaceRecognitionPersonConverter.fromDb(p);
          } catch (e, stackTrace) {
            _log.severe(
              "[getPersons] Failed while converting DB entry",
              e,
              stackTrace,
            );
            return null;
          }
        })
        .nonNulls
        .toList();
  }

  @override
  Future<List<FaceRecognitionFace>> getFaces(
    Account account,
    FaceRecognitionPerson person,
  ) async {
    _log.info("[getFaces] $person");
    // we are not caching faces ATM, to be implemented
    return const FaceRecognitionPersonRemoteDataSource().getFaces(
      account,
      person,
    );
  }

  final NpDb db;
}
