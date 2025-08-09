import 'package:equatable/equatable.dart';
import 'package:to_string/to_string.dart';

part 'recognize_face.g.dart';

/// A person's face recognized by the Recognize app
///
/// Beware that the terminology used in Recognize is different to
/// FaceRecognition, which is also followed by this app. A face in Recognize is
/// a person in FaceRecognition and this app
@toString
class RecognizeFace with EquatableMixin {
  const RecognizeFace({required this.label});

  bool get isNamed => int.tryParse(label) == null;

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [label];

  final String label;
}
