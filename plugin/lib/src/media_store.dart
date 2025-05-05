import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos_plugin/src/exception.dart';
import 'package:nc_photos_plugin/src/k.dart' as k;
import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';

class MediaStoreQueryResult {
  const MediaStoreQueryResult(
    this.id,
    this.uri,
    this.displayName,
    this.path,
    this.dateModified,
    this.mimeType,
    this.dateTaken,
  );

  final int id;
  final String uri;
  final String displayName;
  final String path;
  final int dateModified;
  final String? mimeType;
  final int? dateTaken;
}

class MediaStoreDeleteRequestResultEvent {
  const MediaStoreDeleteRequestResultEvent(this.resultCode);

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
              e["id"],
              e["uri"],
              e["displayName"],
              e["path"],
              e["dateModified"],
              e["mimeType"],
              e["dateTaken"],
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
    TimeRange? timeRange,
  }) async {
    try {
      final List results = await _methodChannel
          .invokeMethod("queryFiles2", <String, dynamic>{
            "timeRangeBeg": timeRange?.from?.millisecondsSinceEpoch,
            "isTimeRangeBegInclusive": timeRange?.let(
              (e) => e.fromBound == TimeRangeBound.inclusive,
            ),
            "timeRangeEnd": timeRange?.to?.millisecondsSinceEpoch,
            "isTimeRangeEndInclusive": timeRange?.let(
              (e) => e.toBound == TimeRangeBound.inclusive,
            ),
          });
      return results
          .cast<Map>()
          .map(
            (e) => MediaStoreQueryResult(
              e["id"],
              e["uri"],
              e["displayName"],
              e["path"],
              e["dateModified"],
              e["mimeType"],
              e["dateTaken"],
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

  static Stream get stream => _eventStream;

  static final _eventStream = _eventChannel.receiveBroadcastStream().map((
    event,
  ) {
    if (event is Map) {
      switch (event["event"]) {
        case _eventDeleteRequestResult:
          return MediaStoreDeleteRequestResultEvent(event["resultCode"]);

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

  static final _log = Logger("media_store.MediaStore");
}
