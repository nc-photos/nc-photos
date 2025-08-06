import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/face_recognition_face.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';

class ListFaceRecognitionFace {
  const ListFaceRecognitionFace(this._c);

  /// List all [FaceRecognitionFace]s belonging to [person]
  Stream<List<FaceRecognitionFace>> call(
    Account account,
    FaceRecognitionPerson person,
  ) => _c.faceRecognitionPersonRepo.getFaces(account, person);

  final DiContainer _c;
}
