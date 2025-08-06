import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:np_common/type.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'item.g.dart';

@npLog
@toString
abstract class AlbumItem with EquatableMixin {
  AlbumItem({required this.addedBy, required DateTime addedAt})
    : addedAt = addedAt.toUtc();

  factory AlbumItem.fromJson(JsonObj json) {
    final addedBy = CiString(json["addedBy"]);
    final addedAt = DateTime.parse(json["addedAt"]);
    final type = json["type"];
    final content = json["content"];
    switch (type) {
      case AlbumFileItem._type:
        return AlbumFileItem.fromJson(
          content.cast<String, dynamic>(),
          addedBy,
          addedAt,
        );
      case AlbumLabelItem._type:
        return AlbumLabelItem.fromJson(
          content.cast<String, dynamic>(),
          addedBy,
          addedAt,
        );
      case AlbumMapItem._type:
        return AlbumMapItem.fromJson(
          content.cast<String, dynamic>(),
          addedBy,
          addedAt,
        );
      default:
        _log.shout("[fromJson] Unknown type: $type");
        throw ArgumentError.value(type, "type");
    }
  }

  JsonObj toJson() {
    String getType() {
      if (this is AlbumFileItem) {
        return AlbumFileItem._type;
      } else if (this is AlbumLabelItem) {
        return AlbumLabelItem._type;
      } else if (this is AlbumMapItem) {
        return AlbumMapItem._type;
      } else {
        throw StateError("Unknwon subtype");
      }
    }

    return {
      "type": getType(),
      "content": toContentJson(),
      "addedBy": addedBy.toString(),
      "addedAt": addedAt.toIso8601String(),
    };
  }

  JsonObj toContentJson();

  bool compareServerIdentity(AlbumItem other);

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [addedBy, addedAt];

  final CiString addedBy;
  final DateTime addedAt;

  static final _log = _$AlbumItemNpLog.log;
}

@genCopyWith
@toString
class AlbumFileItem extends AlbumItem {
  AlbumFileItem({
    required super.addedBy,
    required super.addedAt,
    required this.file,
    required this.ownerId,
  });

  factory AlbumFileItem.fromJson(
    JsonObj json,
    CiString addedBy,
    DateTime addedAt,
  ) {
    return AlbumFileItem(
      addedBy: addedBy,
      addedAt: addedAt,
      file: FileDescriptor.fromJson(json["file"].cast<String, dynamic>()),
      ownerId: (json["ownerId"] as String).toCi(),
    );
  }

  @override
  String toString() => _$toString();

  @override
  JsonObj toContentJson() {
    return {"file": file.toFdJson(), "ownerId": ownerId.raw};
  }

  @override
  bool compareServerIdentity(AlbumItem other) =>
      other is AlbumFileItem &&
      file.compareServerIdentity(other.file) &&
      addedBy == other.addedBy &&
      addedAt == other.addedAt;

  @override
  List<Object?> get props => [...super.props, file, ownerId];

  final FileDescriptor file;
  final CiString ownerId;

  static const _type = "file";
}

@toString
class AlbumLabelItem extends AlbumItem {
  AlbumLabelItem({
    required super.addedBy,
    required super.addedAt,
    required this.text,
  });

  factory AlbumLabelItem.fromJson(
    JsonObj json,
    CiString addedBy,
    DateTime addedAt,
  ) {
    return AlbumLabelItem(
      addedBy: addedBy,
      addedAt: addedAt,
      text: json["text"],
    );
  }

  @override
  String toString() => _$toString();

  @override
  JsonObj toContentJson() {
    return {"text": text};
  }

  @override
  bool compareServerIdentity(AlbumItem other) =>
      other is AlbumLabelItem &&
      text == other.text &&
      addedBy == other.addedBy &&
      addedAt == other.addedAt;

  AlbumLabelItem copyWith({
    CiString? addedBy,
    DateTime? addedAt,
    String? text,
  }) {
    return AlbumLabelItem(
      addedBy: addedBy ?? this.addedBy,
      addedAt: addedAt ?? this.addedAt,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [...super.props, text];

  final String text;

  static const _type = "label";
}

@toString
class AlbumMapItem extends AlbumItem {
  AlbumMapItem({
    required super.addedBy,
    required super.addedAt,
    required this.location,
  });

  factory AlbumMapItem.fromJson(
    JsonObj json,
    CiString addedBy,
    DateTime addedAt,
  ) {
    return AlbumMapItem(
      addedBy: addedBy,
      addedAt: addedAt,
      location: CameraPosition.fromJson(json["location"]),
    );
  }

  @override
  String toString() => _$toString();

  @override
  JsonObj toContentJson() {
    return {"location": location.toJson()};
  }

  @override
  bool compareServerIdentity(AlbumItem other) =>
      other is AlbumMapItem &&
      location == other.location &&
      addedBy == other.addedBy &&
      addedAt == other.addedAt;

  AlbumMapItem copyWith({
    CiString? addedBy,
    DateTime? addedAt,
    CameraPosition? location,
  }) {
    return AlbumMapItem(
      addedBy: addedBy ?? this.addedBy,
      addedAt: addedAt ?? this.addedAt,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [...super.props, location];

  final CameraPosition location;

  static const _type = "map";
}
