import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/person/adapter/face_recognition.dart';
import 'package:nc_photos/entity/person/adapter/recognize.dart';
import 'package:nc_photos/entity/person/content_provider/face_recognition.dart';
import 'package:nc_photos/entity/person/content_provider/recognize.dart';
import 'package:nc_photos/entity/person_face.dart';

abstract class PersonAdapter {
  const PersonAdapter();

  static PersonAdapter of(DiContainer c, Account account, Person person) {
    switch (person.contentProvider.runtimeType) {
      case const (PersonFaceRecognitionProvider):
        return PersonFaceRecognitionAdapter(c, account, person);
      case const (PersonRecognizeProvider):
        return PersonRecognizeAdapter(c, account, person);
      default:
        throw UnsupportedError(
          "Unknown type: ${person.contentProvider.runtimeType}",
        );
    }
  }

  /// List faces of this person
  Stream<List<PersonFace>> listFace();
}
