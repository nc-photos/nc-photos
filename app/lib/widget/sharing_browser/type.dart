part of '../sharing_browser.dart';

abstract class _Item {
  static _Item fromSharingStreamData(
    Account account,
    List<SharingStreamData> src,
  ) {
    if (src.first is SharingStreamFileData) {
      final casted = src.cast<SharingStreamFileData>();
      return _FileShareItem(
        account: account,
        file: casted.first.file,
        shares: casted.map((e) => e.share).toList(),
      );
    } else if (src.first is SharingStreamAlbumData) {
      final casted = src.cast<SharingStreamAlbumData>();
      return _AlbumShareItem(
        account: account,
        album: casted.first.album,
        shares: casted.map((e) => e.share).toList(),
      );
    } else {
      throw ArgumentError("Unknown type: ${src.runtimeType}");
    }
  }

  String get name;
  String? get sharedBy;
  DateTime? get sharedTime;
  DateTime get sortTime;
}

class _FileShareItem implements _Item {
  const _FileShareItem({
    required this.account,
    required this.shares,
    required this.file,
  });

  @override
  String get name => shares.first.filename;

  @override
  String? get sharedBy =>
      shares.first.uidOwner == account.userId
          ? null
          : shares.first.displaynameOwner;

  @override
  DateTime? get sharedTime => shares.first.stime;

  @override
  DateTime get sortTime => shares.first.stime;

  final Account account;
  final List<Share> shares;
  final File file;
}

class _AlbumShareItem implements _Item {
  const _AlbumShareItem({
    required this.account,
    required this.shares,
    required this.album,
  });

  @override
  String get name => album.name;

  @override
  String? get sharedBy =>
      shares.first.uidOwner == account.userId
          ? null
          : shares.first.displaynameOwner;

  @override
  DateTime? get sharedTime => shares.first.stime;

  @override
  DateTime get sortTime => shares.first.stime;

  final Account account;
  final List<Share> shares;
  final Album album;
}
