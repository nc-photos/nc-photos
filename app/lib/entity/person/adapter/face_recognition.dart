import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/person/adapter.dart';
import 'package:nc_photos/entity/person/content_provider/face_recognition.dart';
import 'package:nc_photos/entity/person_face.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/use_case/face_recognition_person/list_face_recognition_face.dart';
import 'package:nc_photos/use_case/find_file_descriptor.dart';
import 'package:np_log/np_log.dart';

part 'face_recognition.g.dart';

@npLog
class PersonFaceRecognitionAdapter implements PersonAdapter {
  PersonFaceRecognitionAdapter(this._c, this.account, this.person)
      : _provider = person.contentProvider as PersonFaceRecognitionProvider;

  @override
  Stream<List<PersonFace>> listFace() {
    return ListFaceRecognitionFace(_c)(account, _provider.person)
        .asyncMap((faces) async {
      final found = await FindFileDescriptor(_c)(
        account,
        faces.map((e) => e.fileId).toList(),
        onFileNotFound: (fileId) {
          _log.warning("[listFace] File not found: $fileId");
        },
      );
      return faces
          .map((i) {
            final f = found.firstWhereOrNull((e) => e.fdId == i.fileId);
            return f?.run(BasicPersonFace.new);
          })
          .nonNulls
          .toList();
    });
  }

  final DiContainer _c;
  final Account account;
  final Person person;

  final PersonFaceRecognitionProvider _provider;
}
