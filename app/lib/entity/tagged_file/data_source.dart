import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/entity/tagged_file.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class TaggedFileRemoteDataSource implements TaggedFileDataSource {
  const TaggedFileRemoteDataSource();

  @override
  list(Account account, File dir, List<Tag> tags) async {
    _log.info(
      "[list] ${tags.map((t) => t.displayName).toReadableString()} under ${dir.path}",
    );
    final response = await ApiUtil.fromAccount(
      account,
    ).files().report(path: dir.path, systemtag: tags.map((t) => t.id).toList());
    if (!response.isGood) {
      _log.severe("[list] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiTaggedFiles = await api.TaggedFileParser().parse(response.body);
    return apiTaggedFiles.map(ApiTaggedFileConverter.fromApi).toList();
  }
}
