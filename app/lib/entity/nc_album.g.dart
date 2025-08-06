// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nc_album.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $NcAlbumCopyWithWorker {
  NcAlbum call({
    String? path,
    int? lastPhoto,
    int? nbItems,
    String? location,
    DateTime? dateStart,
    DateTime? dateEnd,
    List<NcAlbumCollaborator>? collaborators,
  });
}

class _$NcAlbumCopyWithWorkerImpl implements $NcAlbumCopyWithWorker {
  _$NcAlbumCopyWithWorkerImpl(this.that);

  @override
  NcAlbum call({
    dynamic path,
    dynamic lastPhoto = copyWithNull,
    dynamic nbItems,
    dynamic location = copyWithNull,
    dynamic dateStart = copyWithNull,
    dynamic dateEnd = copyWithNull,
    dynamic collaborators,
  }) {
    return NcAlbum(
      path: path as String? ?? that.path,
      lastPhoto: lastPhoto == copyWithNull ? that.lastPhoto : lastPhoto as int?,
      nbItems: nbItems as int? ?? that.nbItems,
      location: location == copyWithNull ? that.location : location as String?,
      dateStart:
          dateStart == copyWithNull ? that.dateStart : dateStart as DateTime?,
      dateEnd: dateEnd == copyWithNull ? that.dateEnd : dateEnd as DateTime?,
      collaborators:
          collaborators as List<NcAlbumCollaborator>? ?? that.collaborators,
    );
  }

  final NcAlbum that;
}

extension $NcAlbumCopyWith on NcAlbum {
  $NcAlbumCopyWithWorker get copyWith => _$copyWith;
  $NcAlbumCopyWithWorker get _$copyWith => _$NcAlbumCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$NcAlbumToString on NcAlbum {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "NcAlbum {path: $path, lastPhoto: $lastPhoto, nbItems: $nbItems, location: $location, dateStart: $dateStart, dateEnd: $dateEnd, collaborators: [length: ${collaborators.length}]}";
  }
}

extension _$NcAlbumCollaboratorToString on NcAlbumCollaborator {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "NcAlbumCollaborator {id: $id, label: $label, type: $type}";
  }
}
