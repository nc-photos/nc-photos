import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_string/np_string.dart';
import 'package:path/path.dart' as path_lib;
import 'package:to_string/to_string.dart';

part 'share.g.dart';

enum ShareType {
  user,
  group,
  publicLink,
  email,
  federatedCloudShare,
  circle,
  talk,
}

extension ShareTypeExtension on ShareType {
  static ShareType fromValue(int shareTypeVal) {
    switch (shareTypeVal) {
      case 0:
        return ShareType.user;
      case 1:
        return ShareType.group;
      case 3:
        return ShareType.publicLink;
      case 4:
        return ShareType.email;
      case 6:
        return ShareType.federatedCloudShare;
      case 7:
        return ShareType.circle;
      case 10:
        return ShareType.talk;
      default:
        throw ArgumentError("Invalid shareType: $shareTypeVal");
    }
  }

  int toValue() {
    switch (this) {
      case ShareType.user:
        return 0;
      case ShareType.group:
        return 1;
      case ShareType.publicLink:
        return 3;
      case ShareType.email:
        return 4;
      case ShareType.federatedCloudShare:
        return 6;
      case ShareType.circle:
        return 7;
      case ShareType.talk:
        return 10;
    }
  }
}

enum ShareItemType { file, folder }

extension ShareItemTypeExtension on ShareItemType {
  static ShareItemType fromValue(String itemTypeVal) {
    switch (itemTypeVal) {
      case "file":
        return ShareItemType.file;
      case "folder":
        return ShareItemType.folder;
      default:
        throw ArgumentError("Invalid itemType: $itemTypeVal");
    }
  }

  String toValue() {
    switch (this) {
      case ShareItemType.file:
        return "file";
      case ShareItemType.folder:
        return "folder";
    }
  }
}

@toString
class Share with EquatableMixin {
  Share({
    required this.id,
    required this.shareType,
    required this.stime,
    required this.uidOwner,
    required this.displaynameOwner,
    required this.uidFileOwner,
    required String path,
    required this.itemType,
    required this.mimeType,
    required this.itemSource,
    required this.shareWith,
    required this.shareWithDisplayName,
    this.url,
  }) : path = path.trimAny("/");

  @override
  String toString() => _$toString();

  @override
  get props => [
    id,
    shareType,
    stime,
    uidOwner,
    displaynameOwner,
    uidFileOwner,
    path,
    itemType,
    mimeType,
    itemSource,
    shareWith,
    shareWithDisplayName,
    url,
  ];

  // see: https://doc.owncloud.com/server/latest/developer_manual/core/apis/ocs-share-api.html#response-attributes-2
  final String id;
  final ShareType shareType;
  final DateTime stime;
  final CiString uidOwner;
  final String displaynameOwner;
  final CiString uidFileOwner;
  final String path;
  final ShareItemType itemType;
  final String mimeType;
  final int itemSource;
  final CiString? shareWith;
  final String shareWithDisplayName;
  final String? url;
}

extension ShareExtension on Share {
  String get filename => path_lib.basename(path);
}

class ShareRepo {
  ShareRepo(this.dataSrc);

  /// See [ShareDataSource.list]
  Future<List<Share>> list(
    Account account,
    FileDescriptor file, {
    bool? isIncludeReshare,
  }) => dataSrc.list(account, file, isIncludeReshare: isIncludeReshare);

  /// See [ShareDataSource.listDir]
  Future<List<Share>> listDir(Account account, File dir) =>
      dataSrc.listDir(account, dir);

  /// See [ShareDataSource.listAll]
  Future<List<Share>> listAll(Account account) => dataSrc.listAll(account);

  /// See [ShareDataSource.reverseList]
  Future<List<Share>> reverseList(Account account, File file) =>
      dataSrc.reverseList(account, file);

  /// See [ShareDataSource.reverseListAll]
  Future<List<Share>> reverseListAll(Account account) =>
      dataSrc.reverseListAll(account);

  /// See [ShareDataSource.create]
  Future<Share> create(
    Account account,
    FileDescriptor file,
    String shareWith,
  ) => dataSrc.create(account, file, shareWith);

  /// See [ShareDataSource.createLink]
  Future<Share> createLink(
    Account account,
    String relativePath, {
    String? password,
  }) => dataSrc.createLink(account, relativePath, password: password);

  /// See [ShareDataSource.delete]
  Future<void> delete(Account account, Share share) =>
      dataSrc.delete(account, share);

  final ShareDataSource dataSrc;
}

abstract class ShareDataSource {
  /// List all shares from a given file
  Future<List<Share>> list(
    Account account,
    FileDescriptor file, {
    bool? isIncludeReshare,
  });

  /// List all shares from a given directory
  Future<List<Share>> listDir(Account account, File dir);

  /// List all shares from a given user
  Future<List<Share>> listAll(Account account);

  /// List all shares by other users from a given file
  Future<List<Share>> reverseList(Account account, File file);

  /// List all shares by other users with a given user
  Future<List<Share>> reverseListAll(Account account);

  /// Share a file/folder with a user
  Future<Share> create(Account account, FileDescriptor file, String shareWith);

  /// Share a file/folder with a share link
  ///
  /// If [password] is not null, the share link will be password protected
  Future<Share> createLink(
    Account account,
    String relativePath, {
    String? password,
  });

  /// Remove the given share
  Future<void> delete(Account account, Share share);
}
