import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/type.dart';

abstract class AlbumCoverProvider with EquatableMixin {
  const AlbumCoverProvider();

  factory AlbumCoverProvider.fromJson(JsonObj json) {
    final type = json["type"];
    final content = json["content"];
    switch (type) {
      case AlbumAutoCoverProvider._type:
        return AlbumAutoCoverProvider.fromJson(content.cast<String, dynamic>());
      case AlbumManualCoverProvider._type:
        return AlbumManualCoverProvider.fromJson(
            content.cast<String, dynamic>());
      case AlbumMemoryCoverProvider._type:
        return AlbumMemoryCoverProvider.fromJson(
            content.cast<String, dynamic>());
      default:
        _log.shout("[fromJson] Unknown type: $type");
        throw ArgumentError.value(type, "type");
    }
  }

  JsonObj toJson() {
    String getType() {
      if (this is AlbumAutoCoverProvider) {
        return AlbumAutoCoverProvider._type;
      } else if (this is AlbumManualCoverProvider) {
        return AlbumManualCoverProvider._type;
      } else {
        throw StateError("Unknwon subtype");
      }
    }

    return {
      "type": getType(),
      "content": _toContentJson(),
    };
  }

  @override
  toString();

  FileDescriptor? getCover(Album album);

  JsonObj _toContentJson();

  static final _log = Logger("entity.album.cover_provider.AlbumCoverProvider");
}

/// Cover selected automatically by us
class AlbumAutoCoverProvider extends AlbumCoverProvider {
  AlbumAutoCoverProvider({
    this.coverFile,
  });

  factory AlbumAutoCoverProvider.fromJson(JsonObj json) {
    return AlbumAutoCoverProvider(
      coverFile: json["coverFile"] == null
          ? null
          : File.fromJson(json["coverFile"].cast<String, dynamic>()),
    );
  }

  @override
  toString() {
    return "$runtimeType {"
        "coverFile: '${coverFile?.path}', "
        "}";
  }

  @override
  getCover(Album album) {
    if (coverFile == null) {
      try {
        // use the latest file as cover
        return AlbumStaticProvider.of(album)
            .items
            .whereType<AlbumFileItem>()
            .map((e) => e.file)
            .where((element) =>
                file_util.isSupportedFormat(element) &&
                (element.hasPreview ?? false))
            .sorted(compareFileDateTimeDescending)
            .first;
      } catch (_) {
        return null;
      }
    } else {
      return coverFile;
    }
  }

  @override
  get props => [
        coverFile,
      ];

  @override
  _toContentJson() {
    return {
      if (coverFile != null) "coverFile": coverFile!.toJson(),
    };
  }

  final File? coverFile;

  static const _type = "auto";
}

/// Cover picked by user
class AlbumManualCoverProvider extends AlbumCoverProvider {
  AlbumManualCoverProvider({
    required this.coverFile,
  });

  factory AlbumManualCoverProvider.fromJson(JsonObj json) {
    return AlbumManualCoverProvider(
      coverFile: File.fromJson(json["coverFile"].cast<String, dynamic>()),
    );
  }

  @override
  toString() {
    return "$runtimeType {"
        "coverFile: '${coverFile.path}', "
        "}";
  }

  @override
  getCover(Album album) => coverFile;

  @override
  get props => [
        coverFile,
      ];

  @override
  _toContentJson() {
    return {
      "coverFile": coverFile.toJson(),
    };
  }

  final File coverFile;

  static const _type = "manual";
}

/// Cover selected when building a Memory album
class AlbumMemoryCoverProvider extends AlbumCoverProvider {
  AlbumMemoryCoverProvider({
    required this.coverFile,
  });

  factory AlbumMemoryCoverProvider.fromJson(JsonObj json) {
    return AlbumMemoryCoverProvider(
      coverFile:
          FileDescriptor.fromJson(json["coverFile"].cast<String, dynamic>()),
    );
  }

  @override
  toString() => "$runtimeType {"
      "coverFile: '${coverFile.fdPath}', "
      "}";

  @override
  getCover(Album album) => coverFile;

  @override
  get props => [
        coverFile,
      ];

  @override
  _toContentJson() => {
        "coverFile": coverFile.toJson(),
      };

  final FileDescriptor coverFile;

  static const _type = "memory";
}
