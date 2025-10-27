part of '../any_file.dart';

class AnyFileMergedProvider
    implements AnyFileProvider, ArchivableAnyFile, FavoritableAnyFile {
  const AnyFileMergedProvider({required this.remote, required this.local});

  static ({String remoteAfId, String localAfId}) parseAfId(String afId) {
    if (afId.slice(0, 4) != kFourCc) {
      throw ArgumentError();
    }
    final json = jsonDecode(afId.slice(5));
    return (remoteAfId: json[0], localAfId: json[1]);
  }

  static String toAfId({
    required String remoteAfId,
    required String localAfId,
  }) {
    final obj = [remoteAfId, localAfId];
    return "$kFourCc-${jsonEncode(obj)}";
  }

  AnyFile asRemoteFile() => AnyFile(provider: remote);

  AnyFile asLocalFile() => AnyFile(provider: local);

  @override
  String get id => toAfId(remoteAfId: remote.id, localAfId: local.id);

  @override
  String get name => remote.name;

  @override
  String? get mime => remote.mime;

  @override
  DateTime get bestDateTime => remote.bestDateTime;

  @override
  String? get displayPath => remote.displayPath;

  @override
  String get logTag => remote.logTag;

  @override
  bool get isArchived => remote.isArchived;

  @override
  bool get isFavorite => remote.isFavorite;

  final AnyFileNextcloudProvider remote;
  final AnyFileLocalProvider local;

  static const kFourCc = "MERG";
}
