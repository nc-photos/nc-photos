import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/entity/favorite.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_log/np_log.dart';

part 'data_source.g.dart';

@npLog
class FavoriteRemoteDataSource implements FavoriteDataSource {
  const FavoriteRemoteDataSource();

  @override
  list(Account account, File dir) async {
    _log.info("[list] ${dir.path}");
    final response = await ApiUtil.fromAccount(account).files().report(
          path: dir.path,
          favorite: true,
        );
    if (!response.isGood) {
      _log.severe("[list] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiFavorites = await api.FavoriteParser().parse(response.body);
    return apiFavorites.map(ApiFavoriteConverter.fromApi).toList();
  }
}
