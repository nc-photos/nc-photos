import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/np_api_util.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'data_source.g.dart';

@npLog
class ShareRemoteDataSource implements ShareDataSource {
  @override
  Future<List<Share>> list(
    Account account,
    FileDescriptor file, {
    bool? isIncludeReshare,
  }) async {
    _log.info("[list] ${file.fdPath}");
    final response = await ApiUtil.fromAccount(account)
        .ocs()
        .filesSharing()
        .shares()
        .get(path: file.strippedPath, reshares: isIncludeReshare);
    return _onListResult(response);
  }

  @override
  listDir(Account account, File dir) async {
    _log.info("[listDir] ${dir.path}");
    final response = await ApiUtil.fromAccount(
      account,
    ).ocs().filesSharing().shares().get(path: dir.strippedPath, subfiles: true);
    return _onListResult(response);
  }

  @override
  listAll(Account account) async {
    _log.info("[listAll] $account");
    final response =
        await ApiUtil.fromAccount(account).ocs().filesSharing().shares().get();
    return _onListResult(response);
  }

  @override
  reverseList(Account account, File file) async {
    _log.info("[reverseList] ${file.path}");
    final response = await ApiUtil.fromAccount(account)
        .ocs()
        .filesSharing()
        .shares()
        .get(path: file.strippedPath, sharedWithMe: true);
    return _onListResult(response);
  }

  @override
  reverseListAll(Account account) async {
    _log.info("[reverseListAll] $account");
    final response = await ApiUtil.fromAccount(
      account,
    ).ocs().filesSharing().shares().get(sharedWithMe: true);
    return _onListResult(response);
  }

  @override
  Future<Share> create(
    Account account,
    FileDescriptor file,
    String shareWith,
  ) async {
    _log.info("[create] Share '${file.fdPath}' with '$shareWith'");
    final response = await ApiUtil.fromAccount(
      account,
    ).ocs().filesSharing().shares().post(
      path: file.strippedPath,
      shareType: ShareType.user.toValue(),
      shareWith: shareWith,
    );
    if (!response.isGood) {
      _log.severe("[create] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final json = jsonDecode(response.body);
    final JsonObj dataJson = json["ocs"]["data"];
    return _ShareParser().parseSingle(dataJson);
  }

  @override
  Future<Share> createLink(
    Account account,
    String relativePath, {
    String? password,
  }) async {
    _log.info("[createLink] Share '$relativePath' with a share link");
    final response = await ApiUtil.fromAccount(
      account,
    ).ocs().filesSharing().shares().post(
      path: relativePath,
      shareType: ShareType.publicLink.toValue(),
      password: password,
    );
    if (!response.isGood) {
      _log.severe("[create] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final json = jsonDecode(response.body);
    final JsonObj dataJson = json["ocs"]["data"];
    return _ShareParser().parseSingle(dataJson);
  }

  @override
  delete(Account account, Share share) async {
    _log.info("[delete] $share");
    final response =
        await ApiUtil.fromAccount(
          account,
        ).ocs().filesSharing().share(share.id).delete();
    if (!response.isGood) {
      _log.severe("[delete] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }
  }

  Future<List<Share>> _onListResult(api.Response response) async {
    if (!response.isGood) {
      _log.severe("[_onListResult] Failed requesting server: $response");
      throw ApiException(
        response: response,
        message: "Server responed with an error: HTTP ${response.statusCode}",
      );
    }

    final apiShares = await api.ShareParser().parse(response.body);
    return apiShares.map(ApiShareConverter.fromApi).toList();
  }
}

@npLog
class _ShareParser {
  List<Share> parseList(List<JsonObj> jsons) {
    final product = <Share>[];
    for (final j in jsons) {
      try {
        product.add(parseSingle(j));
      } catch (e) {
        _log.severe("[parseList] Failed parsing json: ${jsonEncode(j)}", e);
      }
    }
    return product;
  }

  Share parseSingle(JsonObj json) {
    final shareType = ShareTypeExtension.fromValue(json["share_type"]);
    final itemType = ShareItemTypeExtension.fromValue(json["item_type"]);
    return Share(
      id: json["id"],
      shareType: shareType,
      stime: DateTime.fromMillisecondsSinceEpoch(json["stime"] * 1000),
      uidOwner: CiString(json["uid_owner"]),
      displaynameOwner: json["displayname_owner"],
      uidFileOwner: CiString(json["uid_file_owner"]),
      path: json["path"],
      itemType: itemType,
      mimeType: json["mimetype"],
      itemSource: json["item_source"],
      // when shared with a password protected link, shareWith somehow contains
      // the password, which doesn't make sense. We set it to null instead
      shareWith:
          shareType == ShareType.publicLink
              ? null
              : (json["share_with"] as String?)?.toCi(),
      shareWithDisplayName: json["share_with_displayname"],
      url: json["url"],
    );
  }
}
