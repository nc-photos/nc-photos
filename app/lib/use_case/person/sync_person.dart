import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/use_case/face_recognition_person/sync_face_recognition_person.dart';
import 'package:nc_photos/use_case/recognize_face/sync_recognize_face.dart';
import 'package:np_log/np_log.dart';

part 'sync_person.g.dart';

@npLog
class SyncPerson {
  const SyncPerson(this._c);

  /// Sync people in cache db with remote server
  ///
  /// Return if any people were updated
  Future<bool> call(Account account, PersonProvider provider) async {
    _log.info("[call] Current provider: $provider");
    switch (provider) {
      case PersonProvider.none:
        return false;
      case PersonProvider.faceRecognition:
        return _withFaceRecognition(account);
      case PersonProvider.recognize:
        return _withRecognize(account);
    }
  }

  Future<bool> _withFaceRecognition(Account account) =>
      SyncFaceRecognitionPerson(_c)(account);

  Future<bool> _withRecognize(Account account) =>
      SyncRecognizeFace(_c)(account);

  final DiContainer _c;
}
