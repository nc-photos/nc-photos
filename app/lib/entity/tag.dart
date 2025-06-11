import 'package:equatable/equatable.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/json_util.dart' as json_util;
import 'package:np_common/or_null.dart';
import 'package:np_common/type.dart';
import 'package:to_string/to_string.dart';

part 'tag.g.dart';

@ToString(ignoreNull: true)
class Tag with EquatableMixin {
  const Tag({
    required this.id,
    required this.displayName,
    this.userVisible,
    this.userAssignable,
  });

  factory Tag.fromJson(JsonObj json) => Tag(
    id: json["id"],
    displayName: json["displayName"],
    userVisible: json_util.boolFromJson(json["userVisible"]),
    userAssignable: json_util.boolFromJson(json["userAssignable"]),
  );

  JsonObj toJson() => {
    "id": id,
    "displayName": displayName,
    if (userVisible != null) "userVisible": userVisible,
    if (userAssignable != null) "userAssignable": userAssignable,
  };

  @override
  String toString() => _$toString();

  Tag copyWith({
    int? id,
    String? displayName,
    OrNull<bool>? userVisible,
    OrNull<bool>? userAssignable,
  }) => Tag(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    userVisible: userVisible == null ? this.userVisible : userVisible.obj,
    userAssignable:
        userAssignable == null ? this.userAssignable : userAssignable.obj,
  );

  @override
  get props => [id, displayName, userVisible, userAssignable];

  final int id;
  final String displayName;
  final bool? userVisible;
  final bool? userAssignable;
}

extension TagExtension on Tag {
  /// Compare the server identity of two Tags
  ///
  /// Return true if two Tags point to the same tag on server. Be careful that
  /// this does NOT mean that the two Tags are identical
  bool compareServerIdentity(Tag other) {
    return id == other.id && displayName == other.displayName;
  }
}

class TagRepo {
  const TagRepo(this.dataSrc);

  /// See [TagDataSource.list]
  Future<List<Tag>> list(Account account) => dataSrc.list(account);

  /// See [TagDataSource.listByFile]
  Future<List<Tag>> listByFile(Account account, FileDescriptor file) =>
      dataSrc.listByFile(account, file);

  final TagDataSource dataSrc;
}

abstract class TagDataSource {
  /// List all tags
  Future<List<Tag>> list(Account account);

  /// List all tags associated with [file]
  Future<List<Tag>> listByFile(Account account, FileDescriptor file);
}
