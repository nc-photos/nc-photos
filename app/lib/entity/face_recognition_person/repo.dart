import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/face_recognition_face.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:np_log/np_log.dart';

part 'repo.g.dart';

abstract class FaceRecognitionPersonRepo {
  /// Query all [FaceRecognitionPerson]s belonging to [account]
  ///
  /// Normally the stream should complete with only a single event, but some
  /// implementation might want to return multiple set of values, say one set of
  /// cached value and later another set of updated value from a remote source.
  /// In any case, each event is guaranteed to be one complete set of data
  Stream<List<FaceRecognitionPerson>> getPersons(Account account);

  /// Query all [FaceRecognitionFace]s belonging to [person]
  Stream<List<FaceRecognitionFace>> getFaces(
    Account account,
    FaceRecognitionPerson person,
  );
}

/// A repo that simply relay the call to the backed
/// [FaceRecognitionPersonDataSource]
@npLog
class BasicFaceRecognitionPersonRepo implements FaceRecognitionPersonRepo {
  const BasicFaceRecognitionPersonRepo(this.dataSrc);

  @override
  Stream<List<FaceRecognitionPerson>> getPersons(Account account) async* {
    yield await dataSrc.getPersons(account);
  }

  @override
  Stream<List<FaceRecognitionFace>> getFaces(
    Account account,
    FaceRecognitionPerson person,
  ) async* {
    yield await dataSrc.getFaces(account, person);
  }

  final FaceRecognitionPersonDataSource dataSrc;
}

abstract class FaceRecognitionPersonDataSource {
  /// Query all [FaceRecognitionPerson]s belonging to [account]
  Future<List<FaceRecognitionPerson>> getPersons(Account account);

  /// Query all faces belonging to [person]
  Future<List<FaceRecognitionFace>> getFaces(
    Account account,
    FaceRecognitionPerson person,
  );
}
