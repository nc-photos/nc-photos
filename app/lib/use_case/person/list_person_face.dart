import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/person/adapter.dart';
import 'package:nc_photos/entity/person_face.dart';

class ListPersonFace {
  const ListPersonFace(this._c);

  Stream<List<PersonFace>> call(
    Account account,
    Person person, {
    required bool shouldUseRecognizeApiKey,
  }) => PersonAdapter.of(
    _c,
    account,
    person,
    shouldUseRecognizeApiKey: shouldUseRecognizeApiKey,
  ).listFace();

  final DiContainer _c;
}
