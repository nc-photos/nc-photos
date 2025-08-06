// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_descriptor.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $FileDescriptorCopyWithWorker {
  FileDescriptor call({
    String? fdPath,
    int? fdId,
    String? fdMime,
    bool? fdIsArchived,
    bool? fdIsFavorite,
    DateTime? fdDateTime,
  });
}

class _$FileDescriptorCopyWithWorkerImpl
    implements $FileDescriptorCopyWithWorker {
  _$FileDescriptorCopyWithWorkerImpl(this.that);

  @override
  FileDescriptor call({
    dynamic fdPath,
    dynamic fdId,
    dynamic fdMime = copyWithNull,
    dynamic fdIsArchived,
    dynamic fdIsFavorite,
    dynamic fdDateTime,
  }) {
    return FileDescriptor(
      fdPath: fdPath as String? ?? that.fdPath,
      fdId: fdId as int? ?? that.fdId,
      fdMime: fdMime == copyWithNull ? that.fdMime : fdMime as String?,
      fdIsArchived: fdIsArchived as bool? ?? that.fdIsArchived,
      fdIsFavorite: fdIsFavorite as bool? ?? that.fdIsFavorite,
      fdDateTime: fdDateTime as DateTime? ?? that.fdDateTime,
    );
  }

  final FileDescriptor that;
}

extension $FileDescriptorCopyWith on FileDescriptor {
  $FileDescriptorCopyWithWorker get copyWith => _$copyWith;
  $FileDescriptorCopyWithWorker get _$copyWith =>
      _$FileDescriptorCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$FileDescriptorToString on FileDescriptor {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "FileDescriptor {fdPath: $fdPath, fdId: $fdId, fdMime: $fdMime, fdIsArchived: $fdIsArchived, fdIsFavorite: $fdIsFavorite, fdDateTime: $fdDateTime}";
  }
}
