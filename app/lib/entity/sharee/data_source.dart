import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'data_source.g.dart';

@npLog
class ShareeRemoteDataSource implements ShareeDataSource {
  @override
  list(Account account) async {
    _log.info("[list]");
    final response =
        await ApiUtil.fromAccount(account).ocs().filesSharing().sharees().get(
              itemType: "file",
              lookup: false,
            );
    if (!response.isGood) {
      _log.severe("[list] Failed requesting server: $response");
      throw ApiException(
          response: response,
          message:
              "Server responed with an error: HTTP ${response.statusCode}");
    }

    final apiShares = await api.ShareeParser().parse(response.body);
    return apiShares.map(ApiShareeConverter.fromApi).toList();
  }
}

@npLog
class _ShareeParser {
  List<Sharee> call(JsonObj json) {
    final JsonObj dataJson = json["ocs"]["data"];
    final product = <Sharee>[];
    for (final kt in _keyTypes.entries) {
      for (final u in dataJson[kt.key] ?? []) {
        try {
          product.add(Sharee(
            type: kt.value,
            label: u["label"],
            shareType: u["value"]["shareType"],
            shareWith: CiString(u["value"]["shareWith"]),
            shareWithDisplayNameUnique: u["shareWithDisplayNameUnique"],
          ));
        } catch (e) {
          _log.severe("[list] Failed parsing json: ${jsonEncode(u)}", e);
        }
      }
    }
    return product;
  }

  static const _keyTypes = {
    "users": ShareeType.user,
    "groups": ShareeType.group,
    "remotes": ShareeType.remote,
    "remote_groups": ShareeType.remoteGroup,
    "emails": ShareeType.email,
    "circles": ShareeType.circle,
    "rooms": ShareeType.room,
    "deck": ShareeType.deck,
    "lookup": ShareeType.lookup,
  };
}
