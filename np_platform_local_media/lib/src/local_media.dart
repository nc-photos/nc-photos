import 'package:flutter/services.dart';
import 'package:np_common/exception.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/size.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_platform_local_media/src/messages.g.dart' as api;
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'local_media.g.dart';

interface class LocalMedia {
  static Future<Map<Date, int>> getFilesSummary({
    List<String>? dirWhitelist,
  }) async {
    try {
      final results = await _hostApi.getFilesSummary(
        dirWhitelist: dirWhitelist,
      );
      return results.map((k, v) => MapEntry(DateTime.parse(k).toDate(), v));
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  static Future<List<LocalMediaQueryResult>> queryFiles({
    List<String>? fileIds,
    TimeRange? timeRange,
    List<String>? dirWhitelist,
    bool? isAscending,
    int? offset,
    int? limit,
  }) async {
    try {
      final results = await _hostApi.queryFiles(
        fileIds: fileIds,
        timeRangeBeg: timeRange?.from?.millisecondsSinceEpoch,
        isTimeRangeBegInclusive: timeRange?.let(
          (e) => e.fromBound == TimeRangeBound.inclusive,
        ),
        timeRangeEnd: timeRange?.to?.millisecondsSinceEpoch,
        isTimeRangeEndInclusive: timeRange?.let(
          (e) => e.toBound == TimeRangeBound.inclusive,
        ),
        dirWhitelist: dirWhitelist,
        isAscending: isAscending ?? false,
        offset: offset,
        limit: limit,
      );
      return results.map((e) => e.toLocalMediaQueryResult()).toList();
    } on PlatformException catch (e) {
      if (e.code == _exceptionCodePermissionError) {
        throw const PermissionException();
      } else {
        rethrow;
      }
    }
  }

  static Future<Uint8List> readFile(String platformIdentifier) async {
    try {
      return await _hostApi.readFile(platformIdentifier);
    } on PlatformException catch (e) {
      if (e.code == _exceptionFileNotFound) {
        throw const FileNotFoundException();
      } else {
        rethrow;
      }
    }
  }

  static Future<Uint8List> readThumbnail(
    String platformIdentifier, {
    required int width,
    required int height,
  }) async {
    try {
      return await _hostApi.readThumbnail(
        platformIdentifier,
        width: width,
        height: height,
      );
    } on PlatformException catch (e) {
      if (e.code == _exceptionFileNotFound) {
        throw const FileNotFoundException();
      } else {
        rethrow;
      }
    }
  }

  static final _hostApi = api.MyHostApi();

  static const _exceptionCodePermissionError = "permissionError";
  static const _exceptionFileNotFound = "fileNotFoundException";
}

@toString
class LocalMediaQueryResult {
  const LocalMediaQueryResult({
    required this.id,
    this.displayName,
    this.dateModified,
    this.mimeType,
    this.dateTaken,
    this.resolution,
    this.size,
    this.androidUri,
    this.androidPath,
  });

  @override
  String toString() => _$toString();

  final String id;
  final String? displayName;
  final DateTime? dateModified;
  final String? mimeType;
  final DateTime? dateTaken;
  final SizeInt? resolution;
  final int? size;

  // android specific
  final String? androidUri;
  final String? androidPath;
}

extension QueryResultExtension on api.QueryResult {
  String get platformIdentifier {
    if (getRawPlatform() == NpPlatform.android) {
      return androidUri!;
    } else {
      return id;
    }
  }
}

extension on api.QueryResult {
  LocalMediaQueryResult toLocalMediaQueryResult() {
    return LocalMediaQueryResult(
      id: id,
      displayName: displayName,
      dateModified: dateModified?.let(
        (e) => DateTime.fromMillisecondsSinceEpoch(e, isUtc: true),
      ),
      mimeType: mimeType,
      dateTaken: dateTaken?.let(
        (e) => DateTime.fromMillisecondsSinceEpoch(e, isUtc: true),
      ),
      resolution:
          width != null && height != null ? SizeInt(width!, height!) : null,
      size: size,
      androidUri: androidUri,
      androidPath: androidPath,
    );
  }
}
