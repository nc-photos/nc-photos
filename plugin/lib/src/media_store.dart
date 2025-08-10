import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos_plugin/src/exception.dart';
import 'package:nc_photos_plugin/src/k.dart' as k;
import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';

class MediaStoreQueryResult {
  const MediaStoreQueryResult({
    required this.id,
    required this.uri,
    required this.displayName,
    required this.path,
    required this.dateModified,
    required this.mimeType,
    required this.dateTaken,
    required this.width,
    required this.height,
    required this.size,
  });

  final int id;
  final String uri;
  final String displayName;
  final String path;
  final int dateModified;
  final String? mimeType;
  final int? dateTaken;
  final int? width;
  final int? height;
  final int size;
}

class MediaStoreDeleteRequestResultEvent {
  const MediaStoreDeleteRequestResultEvent(this.resultCode);

  final int resultCode;
}

class MediaStoreTrashRequestResultEvent {
  const MediaStoreTrashRequestResultEvent(this.resultCode);

  final int resultCode;
}

class MediaStore {
  static Future<String> saveFileToDownload(
    Uint8List content,
    String filename, {
    String? subDir,
  }) async {
    try {
      return (await _methodChannel.invokeMethod<String>(
        "saveFileToDownload",
        <String, dynamic>{
          "content": content,
          "filename": filename,
          "subDir": subDir,
        },
      ))!;
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  /// Copy a file to the user Download dir
  ///
  /// [fromFile] must be either a path or a content uri. If [filename] is not
  /// null, it will be used instead of the source filename
  static Future<String> copyFileToDownload(
    String fromFile, {
    String? filename,
    String? subDir,
  }) async {
    try {
      return (await _methodChannel.invokeMethod<String>(
        "copyFileToDownload",
        <String, dynamic>{
          "fromFile": fromFile,
          "filename": filename,
          "subDir": subDir,
        },
      ))!;
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  /// Return files under [relativePath] and its sub dirs
  static Future<List<MediaStoreQueryResult>> queryFiles(
    String relativePath,
  ) async {
    try {
      final List results = await _methodChannel.invokeMethod(
        "queryFiles",
        <String, dynamic>{"relativePath": relativePath},
      );
      return results
          .cast<Map>()
          .map(
            (e) => MediaStoreQueryResult(
              id: e["id"],
              uri: e["uri"],
              displayName: e["displayName"],
              path: e["path"],
              dateModified: e["dateModified"],
              mimeType: e["mimeType"],
              dateTaken: e["dateTaken"],
              width: e["width"],
              height: e["height"],
              size: e["size"],
            ),
          )
          .toList();
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  static Future<List<MediaStoreQueryResult>> queryFiles2({
    List<int>? fileIds,
    TimeRange? timeRange,
    bool? isAscending,
    int? offset,
    int? limit,
  }) async {
    try {
      final List results = await _methodChannel
          .invokeMethod("queryFiles2", <String, dynamic>{
            "fileIds": fileIds,
            "timeRangeBeg": timeRange?.from?.millisecondsSinceEpoch,
            "isTimeRangeBegInclusive": timeRange?.let(
              (e) => e.fromBound == TimeRangeBound.inclusive,
            ),
            "timeRangeEnd": timeRange?.to?.millisecondsSinceEpoch,
            "isTimeRangeEndInclusive": timeRange?.let(
              (e) => e.toBound == TimeRangeBound.inclusive,
            ),
            "isAscending": isAscending,
            "offset": offset,
            "limit": limit,
          });
      return results
          .cast<Map>()
          .map(
            (e) => MediaStoreQueryResult(
              id: e["id"],
              uri: e["uri"],
              displayName: e["displayName"],
              path: e["path"],
              dateModified: e["dateModified"],
              mimeType: e["mimeType"],
              dateTaken: e["dateTaken"],
              width: e["width"],
              height: e["height"],
              size: e["size"],
            ),
          )
          .toList();
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  static Future<List<String>?> deleteFiles(List<String> uris) async {
    return (await _methodChannel.invokeMethod<List>(
      "deleteFiles",
      <String, dynamic>{"uris": uris},
    ))?.cast<String>();
  }

  /// Request MediaStore to move files to trash and return the actual requested
  /// files (some uris are not supported)
  static Future<List<String>> trashFiles(List<String> uris) async {
    return (await _methodChannel.invokeMethod<List>(
      "trashFiles",
      <String, dynamic>{"uris": uris},
    ))!.cast<String>();
  }

  static Future<Map<Date, int>> getFilesSummary() async {
    try {
      return (await _methodChannel.invokeMethod<Map>(
        "getFilesSummary",
      ))!.cast<int, int>().map(
        (key, value) => MapEntry(
          Date.fromDateTime(DateTime.fromMillisecondsSinceEpoch(key)),
          value,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  static Future<List<({int fileId, int timestamp})>>
  getFileIdWithTimestamps() async {
    try {
      return (await _methodChannel.invokeMethod<List>(
            "getFileIdWithTimestamps",
          ))!
          .cast<Map>()
          .map(
            (e) => (
              fileId: e["fileId"] as int,
              timestamp: e["timestamp"] as int,
            ),
          )
          .toList();
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  static Stream get stream => _eventStream;

  static final _eventStream = _eventChannel.receiveBroadcastStream().map((
    event,
  ) {
    if (event is Map) {
      switch (event["event"]) {
        case _eventDeleteRequestResult:
          return MediaStoreDeleteRequestResultEvent(event["resultCode"]);

        case _eventTrashRequestResult:
          return MediaStoreTrashRequestResultEvent(event["resultCode"]);

        default:
          _log.shout("[_eventStream] Unknown event: ${event["event"]}");
      }
    } else {
      return event;
    }
  });

  static const _eventChannel = EventChannel("${k.libId}/media_store");
  static const _methodChannel = MethodChannel("${k.libId}/media_store_method");

  static const _exceptionCodePermissionError = "permissionError";
  static const _eventDeleteRequestResult = "DeleteRequestResult";
  static const _eventTrashRequestResult = "TrashRequestResult";

  static final _log = Logger("media_store.MediaStore");
}
