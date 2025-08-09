import 'package:np_api/np_api.dart';
import 'package:test/test.dart';

void main() {
  group("FaceRecognitionFaceParser", () {
    test("parse", _faces);
  });
}

Future<void> _faces() async {
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
                "id": 1,
                "fileId": 111
            },
            {
                "id": 2,
                "fileId": 222
            },
            {
                "id": 10,
                "fileId": 333
            }
        ]
    }
}
""";
  final results = await FaceRecognitionFaceParser().parse(json);
  expect(results, const [
    FaceRecognitionFace(id: 1, fileId: 111),
    FaceRecognitionFace(id: 2, fileId: 222),
    FaceRecognitionFace(id: 10, fileId: 333),
  ]);
}
