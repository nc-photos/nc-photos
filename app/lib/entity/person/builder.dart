import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/person/content_provider/face_recognition.dart';
import 'package:nc_photos/entity/person/content_provider/recognize.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';

class PersonBuilder {
  static Person byFaceRecognitionPerson(
    Account account,
    FaceRecognitionPerson person,
  ) {
    return Person(
      name: person.name,
      contentProvider: PersonFaceRecognitionProvider(
        account: account,
        person: person,
      ),
    );
  }

  static Person byRecognizeFace(
    Account account,
    RecognizeFace face,
    List<RecognizeFaceItem>? items,
  ) {
    return Person(
      name: face.isNamed ? face.label : "",
      contentProvider: PersonRecognizeProvider(
        account: account,
        face: face,
        items: items,
      ),
    );
  }
}
