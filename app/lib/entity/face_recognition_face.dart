import 'package:equatable/equatable.dart';
import 'package:to_string/to_string.dart';

part 'face_recognition_face.g.dart';

@toString
class FaceRecognitionFace with EquatableMixin {
  const FaceRecognitionFace({required this.id, required this.fileId});

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [id, fileId];

  final int id;
  final int fileId;
}
