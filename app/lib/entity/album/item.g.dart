// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $AlbumFileItemCopyWithWorker {
  AlbumFileItem call({
    CiString? addedBy,
    DateTime? addedAt,
    FileDescriptor? file,
    CiString? ownerId,
  });
}

class _$AlbumFileItemCopyWithWorkerImpl
    implements $AlbumFileItemCopyWithWorker {
  _$AlbumFileItemCopyWithWorkerImpl(this.that);

  @override
  AlbumFileItem call({
    dynamic addedBy,
    dynamic addedAt,
    dynamic file,
    dynamic ownerId,
  }) {
    return AlbumFileItem(
      addedBy: addedBy as CiString? ?? that.addedBy,
      addedAt: addedAt as DateTime? ?? that.addedAt,
      file: file as FileDescriptor? ?? that.file,
      ownerId: ownerId as CiString? ?? that.ownerId,
    );
  }

  final AlbumFileItem that;
}

extension $AlbumFileItemCopyWith on AlbumFileItem {
  $AlbumFileItemCopyWithWorker get copyWith => _$copyWith;
  $AlbumFileItemCopyWithWorker get _$copyWith =>
      _$AlbumFileItemCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$AlbumItemNpLog on AlbumItem {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("entity.album.item.AlbumItem");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$AlbumItemToString on AlbumItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "${objectRuntimeType(this, "AlbumItem")} {addedBy: $addedBy, addedAt: $addedAt}";
  }
}

extension _$AlbumFileItemToString on AlbumFileItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "AlbumFileItem {addedBy: $addedBy, addedAt: $addedAt, file: ${file.fdPath}, ownerId: $ownerId}";
  }
}

extension _$AlbumLabelItemToString on AlbumLabelItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "AlbumLabelItem {addedBy: $addedBy, addedAt: $addedAt, text: $text}";
  }
}

extension _$AlbumMapItemToString on AlbumMapItem {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "AlbumMapItem {addedBy: $addedBy, addedAt: $addedAt, location: $location}";
  }
}
