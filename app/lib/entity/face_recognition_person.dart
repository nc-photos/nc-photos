import 'package:equatable/equatable.dart';
import 'package:to_string/to_string.dart';

part 'face_recognition_person.g.dart';

@toString
class FaceRecognitionPerson with EquatableMixin {
  const FaceRecognitionPerson({
    required this.name,
    required this.thumbFaceId,
    required this.count,
  });

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [name, thumbFaceId, count];

  final String name;
  final int thumbFaceId;
  final int count;
}
