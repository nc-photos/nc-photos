import 'package:np_api/np_api.dart';
import 'package:test/test.dart';

void main() {
  group("FaceRecognitionPersonParser", () {
    test("parse", _persons);
  });
}

Future<void> _persons() async {
  const json = """
{
    "ocs": {
        "meta": {
            "status": "ok",
            "statuscode": 200,
            "message": "OK"
        },
        "data": [
            {
                "name": "Random Person",
                "thumbFaceId": 1,
                "count": 3
            },
            {
                "name": "Random Cat",
                "thumbFaceId": 10,
                "count": 4
            }
        ]
    }
}
""";
  final results = await FaceRecognitionPersonParser().parse(json);
  expect(results, const [
    FaceRecognitionPerson(name: "Random Person", thumbFaceId: 1, count: 3),
    FaceRecognitionPerson(name: "Random Cat", thumbFaceId: 10, count: 4),
  ]);
}
