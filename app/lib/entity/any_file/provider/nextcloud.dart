part of '../any_file.dart';

class AnyFileNextcloudProvider
    implements AnyFileProvider, ArchivableAnyFile, FavoritableAnyFile {
  const AnyFileNextcloudProvider({required this.file});

  static int parseAfId(String afId) {
    if (afId.slice(0, 4) != kFourCc) {
      throw ArgumentError();
    }
    return int.parse(afId.slice(5));
  }

  static String toAfId(int fileId) {
    return "$kFourCc-$fileId";
  }

  @override
  String get id => toAfId(file.fdId);

  @override
  String get name => file.filename;

  @override
  String? get mime => file.fdMime;

  @override
  DateTime get bestDateTime => file.fdDateTime;

  @override
  String get logTag => file.fdPath;

  @override
  String? get displayPath => file.strippedPath;

  @override
  bool get isArchived => file.fdIsArchived;

  @override
  bool get isFavorite => file.fdIsFavorite;

  final FileDescriptor file;

  static const kFourCc = "NEXT";
}
