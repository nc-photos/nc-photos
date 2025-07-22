import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face/repo.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_collection/np_collection.dart';
import 'package:np_common/type.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class RecognizeFaceRemoteDataSource implements RecognizeFaceDataSource {
  const RecognizeFaceRemoteDataSource();

  @override
  Future<List<RecognizeFace>> getFaces(Account account) async {
    _log.info("[getFaces] account: ${account.userId}");
    final response = await ApiUtil.fromAccount(account)
        .recognize(account.userId.raw)
        .faces()
        .propfind();
    if (!response.isGood) {
      _log.severe("[getFaces] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiFaces = await api.RecognizeFaceParser().parse(response.body);
    return apiFaces
        .map(ApiRecognizeFaceConverter.fromApi)
        .where((e) => e.label.isNotEmpty)
        .toList();
  }

  @override
  Future<List<RecognizeFaceItem>> getItems(
      Account account, RecognizeFace face) async {
    _log.info("[getItems] account: ${account.userId}, face: ${face.label}");
    final response = await ApiUtil.fromAccount(account)
        .recognize(account.userId.raw)
        .face(face.label)
        .propfind(
          getcontentlength: 1,
          getcontenttype: 1,
          getetag: 1,
          getlastmodified: 1,
          faceDetections: 1,
          fileMetadataSize: 1,
          hasPreview: 1,
          realpath: 1,
          favorite: 1,
          fileid: 1,
        );
    if (!response.isGood) {
      _log.severe("[getItems] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiItems = await api.RecognizeFaceItemParser().parse(response.body);
    return apiItems
        .where((f) => f.fileId != null)
        .map(ApiRecognizeFaceItemConverter.fromApi)
        .toList();
  }

  @override
  Future<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  }) async {
    final results = await Future.wait(faces.map((f) async {
      try {
        return MapEntry(f, await getItems(account, f));
      } catch (e, stackTrace) {
        _log.severe("[getMultiFaceItems] Failed while querying face: $f", e,
            stackTrace);
        onError?.call(f, e, stackTrace);
        return null;
      }
    }));
    return results.nonNulls.toMap();
  }

  @override
  Future<Map<RecognizeFace, RecognizeFaceItem>> getMultiFaceLastItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  }) async {
    final results = await getMultiFaceItems(account, faces, onError: onError);
    return results
        .map((key, value) => MapEntry(key, maxBy(value, (e) => e.fileId)!));
  }
}

@npLog
class RecognizeFaceSqliteDbDataSource implements RecognizeFaceDataSource {
  const RecognizeFaceSqliteDbDataSource(this.db);

  @override
  Future<List<RecognizeFace>> getFaces(Account account) async {
    _log.info("[getFaces] $account");
    final results = await db.getRecognizeFaces(account: account.toDb());
    return results
        .map((f) {
          try {
            return DbRecognizeFaceConverter.fromDb(f);
          } catch (e, stackTrace) {
            _log.severe(
                "[getFaces] Failed while converting DB entry", e, stackTrace);
            return null;
          }
        })
        .nonNulls
        .toList();
  }

  @override
  Future<List<RecognizeFaceItem>> getItems(
      Account account, RecognizeFace face) async {
    _log.info("[getItems] $face");
    final results = await db.getRecognizeFaceItemsByFaceLabel(
      account: account.toDb(),
      label: face.label,
    );
    return results
        .map((r) {
          try {
            return DbRecognizeFaceItemConverter.fromDb(
                account.userId.toString(), face.label, r);
          } catch (e, stackTrace) {
            _log.severe(
                "[getItems] Failed while converting DB entry", e, stackTrace);
            return null;
          }
        })
        .nonNulls
        .toList();
  }

  @override
  Future<Map<RecognizeFace, List<RecognizeFaceItem>>> getMultiFaceItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  }) async {
    _log.info("[getMultiFaceItems] ${faces.toReadableString()}");
    final results = await db.getRecognizeFaceItemsByFaceLabels(
      account: account.toDb(),
      labels: faces.map((e) => e.label).toList(),
    );
    return results.entries
        .map((e) {
          try {
            return MapEntry(
              faces.firstWhere((f) => f.label == e.key),
              e.value
                  .map((f) => DbRecognizeFaceItemConverter.fromDb(
                      account.userId.toString(), e.key, f))
                  .toList(),
            );
          } catch (e, stackTrace) {
            _log.severe("[getMultiFaceItems] Failed while converting DB entry",
                e, stackTrace);
            return null;
          }
        })
        .nonNulls
        .toMap();
  }

  @override
  Future<Map<RecognizeFace, RecognizeFaceItem>> getMultiFaceLastItems(
    Account account,
    List<RecognizeFace> faces, {
    ErrorWithValueHandler<RecognizeFace>? onError,
  }) async {
    _log.info("[getMultiFaceLastItems] ${faces.toReadableString()}");
    final results = await db.getLatestRecognizeFaceItemsByFaceLabels(
      account: account.toDb(),
      labels: faces.map((e) => e.label).toList(),
    );
    return results.entries
        .map((e) {
          try {
            return MapEntry(
              faces.firstWhere((f) => f.label == e.key),
              DbRecognizeFaceItemConverter.fromDb(
                  account.userId.toString(), e.key, e.value),
            );
          } catch (e, stackTrace) {
            _log.severe(
                "[getMultiFaceLastItems] Failed while converting DB entry",
                e,
                stackTrace);
            return null;
          }
        })
        .nonNulls
        .toMap();
  }

  final NpDb db;
}
