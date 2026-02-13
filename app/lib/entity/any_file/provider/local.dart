part of '../any_file.dart';

class AnyFileLocalProvider implements AnyFileProvider {
  const AnyFileLocalProvider({required this.file});

  static String parseAfId(String afId) {
    if (afId.slice(0, 4) != kFourCc) {
      throw ArgumentError();
    }
    return afId.slice(5);
  }

  static String toAfId(String fileId) {
    return "$kFourCc-$fileId";
  }

  @override
  String get id => toAfId(file.id);

  @override
  String get name => file.filename ?? "photo";

  @override
  String? get mime => file.mime;

  @override
  DateTime get bestDateTime => file.bestDateTime;

  @override
  String? get displayPath => file.path;

  @override
  String get logTag => file.logTag;

  final LocalFile file;

  static const kFourCc = "LOCL";
}
