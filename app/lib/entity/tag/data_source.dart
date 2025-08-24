import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class TagRemoteDataSource implements TagDataSource {
  const TagRemoteDataSource();

  @override
  list(Account account) async {
    _log.info("[list] $account");
    final response = await ApiUtil.fromAccount(account).systemtags().propfind(
      id: 1,
      displayName: 1,
      userVisible: 1,
      userAssignable: 1,
    );
    if (!response.isGood) {
      _log.severe("[list] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiTags = await api.TagParser().parse(response.body);
    return apiTags.map(ApiTagConverter.fromApi).toList();
  }

  @override
  Future<List<Tag>> listByFile(Account account, FileDescriptor file) async {
    _log.info("[listByFile] ${file.fdPath}");
    final response = await ApiUtil.fromAccount(account)
        .systemtagsRelations()
        .files(file.fdId)
        .propfind(id: 1, displayName: 1, userVisible: 1, userAssignable: 1);
    if (!response.isGood) {
      _log.severe("[listByFile] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiTags = await api.TagParser().parse(response.body);
    return apiTags.map(ApiTagConverter.fromApi).toList();
  }
}

@npLog
class TagSqliteDbDataSource implements TagDataSource {
  const TagSqliteDbDataSource(this.db);

  @override
  Future<List<Tag>> list(Account account) async {
    _log.info("[list] $account");
    final results = await db.getTags(account: account.toDb());
    return results.map(DbTagConverter.fromDb).toList();
  }

  @override
  Future<List<Tag>> listByFile(Account account, FileDescriptor file) async {
    _log.info("[listByFile] ${file.fdPath}");
    throw UnimplementedError();
  }

  final NpDb db;
}
