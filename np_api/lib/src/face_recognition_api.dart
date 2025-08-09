part of 'api.dart';

class ApiOcsFacerecognition {
  ApiOcsFacerecognition(this._ocs);

  ApiOcsFacerecognitionPersons persons() => ApiOcsFacerecognitionPersons(this);

  ApiOcsFacerecognitionPerson person(String name) =>
      ApiOcsFacerecognitionPerson(this, name);

  final ApiOcs _ocs;
}

@npLog
class ApiOcsFacerecognitionPersons {
  ApiOcsFacerecognitionPersons(this._facerecognition);

  Future<Response> get() async {
    try {
      return await _facerecognition._ocs._api.request(
        "GET",
        "ocs/v2.php/apps/facerecognition/api/v1/persons",
        header: {"OCS-APIRequest": "true"},
        queryParameters: {"format": "json"},
      );
    } catch (e) {
      _log.severe("[get] Failed while get", e);
      rethrow;
    }
  }

  final ApiOcsFacerecognition _facerecognition;
}

class ApiOcsFacerecognitionPerson {
  ApiOcsFacerecognitionPerson(this._facerecognition, this._name);

  ApiOcsFacerecognitionPersonFaces faces() =>
      ApiOcsFacerecognitionPersonFaces(this);

  final ApiOcsFacerecognition _facerecognition;
  final String _name;
}

@npLog
class ApiOcsFacerecognitionPersonFaces {
  ApiOcsFacerecognitionPersonFaces(this._person);

  Future<Response> get() async {
    try {
      return await _person._facerecognition._ocs._api.request(
        "GET",
        "ocs/v2.php/apps/facerecognition/api/v1/person/${_person._name}/faces",
        header: {"OCS-APIRequest": "true"},
        queryParameters: {"format": "json"},
      );
    } catch (e) {
      _log.severe("[get] Failed while get", e);
      rethrow;
    }
  }

  final ApiOcsFacerecognitionPerson _person;
}
