import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/person/adapter.dart';
import 'package:nc_photos/entity/person/content_provider/recognize.dart';
import 'package:nc_photos/entity/person_face.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/use_case/find_file_descriptor.dart';
import 'package:nc_photos/use_case/recognize_face/list_recognize_face_item.dart';
import 'package:np_log/np_log.dart';

part 'recognize.g.dart';

@npLog
class PersonRecognizeAdapter implements PersonAdapter {
  PersonRecognizeAdapter(this._c, this.account, this.person)
    : _provider = person.contentProvider as PersonRecognizeProvider;

  @override
  Stream<List<PersonFace>> listFace() {
    return ListRecognizeFaceItem(_c)(account, _provider.face).asyncMap((
      faces,
    ) async {
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

  final PersonRecognizeProvider _provider;
}
