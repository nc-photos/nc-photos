import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/person/builder.dart';
import 'package:nc_photos/use_case/face_recognition_person/list_face_recognition_person.dart';
import 'package:nc_photos/use_case/recognize_face/list_recognize_face.dart';
import 'package:nc_photos/use_case/recognize_face/list_recognize_face_item.dart';
import 'package:np_log/np_log.dart';

part 'list_person.g.dart';

@npLog
class ListPerson {
  const ListPerson(this._c);

  Stream<List<Person>> call(Account account, PersonProvider provider) async* {
    _log.info("[call] Current provider: $provider");
    switch (provider) {
      case PersonProvider.none:
        return;
      case PersonProvider.faceRecognition:
        yield* _withFaceRecognition(account);
        break;
      case PersonProvider.recognize:
        yield* _withRecognize(account);
        break;
    }
  }

  Stream<List<Person>> _withFaceRecognition(Account account) async* {
    try {
      await for (final results in ListFaceRecognitionPerson(_c)(account)) {
        yield results
            .map((e) => PersonBuilder.byFaceRecognitionPerson(account, e))
            .toList();
      }
    } catch (e, stackTrace) {
      // not installed?
      _log.severe(
        "[_withFaceRecognition] Failed while ListFaceRecognitionPerson",
        e,
        stackTrace,
      );
    }
  }

  Stream<List<Person>> _withRecognize(Account account) async* {
    try {
      await for (final faces in ListRecognizeFace(_c)(account)) {
        final itemStream = ListMultipleRecognizeFaceItem(_c)(
          account,
          faces,
          onError: (value, e, stackTrace) {
            _log.severe(
              "[_withRecognize] Failed while ListRecognizeFace for $value",
              e,
              stackTrace,
            );
          },
        );
        await for (final items in itemStream) {
          yield faces
              .map((f) => PersonBuilder.byRecognizeFace(account, f, items[f]))
              .toList();
        }
      }
    } catch (e, stackTrace) {
      // not installed?
      _log.severe(
          "[_withRecognize] Failed while ListRecognizeFace", e, stackTrace);
    }
  }

  final DiContainer _c;
}
