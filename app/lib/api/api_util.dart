// Helper functions working with remote Nextcloud server
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:np_api/np_api.dart' hide NcAlbumItem;
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'api_util.g.dart';

/// Characters that are not allowed in filename
const reservedFilenameChars = "<>:\"/\\|?*";

/// Return the preview image URL for [file]. See [getFilePreviewUrlRelative]
String getFilePreviewUrl(
  Account account,
  FileDescriptor file, {
  required int width,
  required int height,
  String? mode,
  required bool isKeepAspectRatio,
}) {
  return "${account.url}/"
      "${getFilePreviewUrlRelative(account, file, width: width, height: height, mode: mode, isKeepAspectRatio: isKeepAspectRatio)}";
}

/// Return the relative preview image URL for [file]
///
/// If [isKeepAspectRatio] == true, the preview will maintain the original
/// aspect ratio, otherwise it will be cropped
String getFilePreviewUrlRelative(
  Account account,
  FileDescriptor file, {
  required int width,
  required int height,
  String? mode,
  required bool isKeepAspectRatio,
}) {
  String url;
  if (file_util.isNcAlbumFile(account, file)) {
    // We can't use the generic file preview url because collaborative albums do
    // not create a file share for photos not belonging to you, that means you
    // can only access the file view the Photos API
    url =
        "index.php/apps/photos/api/v1/preview/${file.fdId}?x=$width&y=$height";
  } else {
    if (file_util.isTrash(account, file)) {
      // trashbin does not support preview.png endpoint
      url = "index.php/apps/files_trashbin/preview?fileId=${file.fdId}";
    } else {
      url = "index.php/core/preview?fileId=${file.fdId}";
    }
    url = "$url&x=$width&y=$height";
    if (mode != null) {
      url = "$url&mode=$mode";
    }
    // keep this here to use cache from older version
    url = "$url&a=${isKeepAspectRatio ? 1 : 0}";
  }
  return url;
}

/// Return the preview image URL for [fileId]. See [getFilePreviewUrlRelative]
String getFilePreviewUrlByFileId(
  Account account,
  int fileId, {
  required int width,
  required int height,
  String? mode,
  required bool isKeepAspectRatio,
}) {
  String url = "${account.url}/index.php/core/preview?fileId=$fileId";
  url = "$url&x=$width&y=$height";
  if (mode != null) {
    url = "$url&mode=$mode";
  }
  url = "$url&a=${isKeepAspectRatio ? 1 : 0}";
  return url;
}

/// Return the preview image URL for [fileId], using the new Photos API in
/// Nextcloud 25
String getPhotosApiFilePreviewUrlByFileId(
  Account account,
  int fileId, {
  required int width,
  required int height,
}) =>
    "${account.url}/index.php/apps/photos/api/v1/preview/$fileId?x=$width&y=$height";

String getFileUrl(Account account, FileDescriptor file) {
  return "${account.url}/${getFileUrlRelative(file)}";
}

String getFileUrlRelative(FileDescriptor file) {
  return file.fdPath;
}

Uri getFileUri(Account account, FileDescriptor file) {
  final serverUri = account.uri;
  return serverUri.replace(
    path: "${serverUri.path}/${getFileUrlRelative(file)}",
  );
}

String getWebdavRootUrlRelative(Account account) =>
    "remote.php/dav/files/${account.userId}";

String getTrashbinPath(Account account) =>
    "remote.php/dav/trashbin/${account.userId}/trash";

/// Return the face image URL. See [getFacePreviewUrlRelative]
String getFacePreviewUrl(
  Account account,
  int faceId, {
  required int size,
}) {
  return "${account.url}/"
      "${getFacePreviewUrlRelative(account, faceId, size: size)}";
}

/// Return the relative URL of the face image
String getFacePreviewUrlRelative(
  Account account,
  int faceId, {
  required int size,
}) {
  return "index.php/apps/facerecognition/face/$faceId/thumb/$size";
}

String getAccountAvatarUrl(Account account, int size) =>
    "${account.url}/${getAccountAvatarUrlRelative(account, size)}";

String getAccountAvatarUrlRelative(Account account, int size) =>
    "avatar/${account.userId}/$size";

/// Initiate a login with Nextcloud login flow v2: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2
Future<InitiateLoginResponse> initiateLogin(Uri uri) async {
  final response = await Api.fromBaseUrl(uri).request(
    "POST",
    "index.php/login/v2",
    header: {
      "User-Agent": "nc-photos",
    },
  );
  if (response.isGood) {
    return InitiateLoginResponse.fromJsonString(response.body);
  } else {
    _log.severe(
        "[initiateLogin] Failed while requesting app password: $response");
    throw ApiException(
        response: response,
        message: "Server responded with an error: HTTP ${response.statusCode}");
  }
}

/// Retrieve App Password after successful initiation of login with Nextcloud login flow v2: https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2
Future<AppPasswordResponse> _getAppPassword(
    InitiateLoginPollOptions options) async {
  Uri baseUrl;
  if (options.endpoint.scheme == "http") {
    baseUrl = Uri.http(options.endpoint.authority);
  } else {
    baseUrl = Uri.https(options.endpoint.authority);
  }
  final response = await Api.fromBaseUrl(baseUrl).request(
      "POST", options.endpoint.pathSegments.join("/"),
      header: {
        "User-Agent": "nc-photos",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: "token=${options.token}");
  if (response.statusCode == 200) {
    return AppPasswordSuccess.fromJsonString(response.body);
  } else if (response.statusCode == 404) {
    return AppPasswordPending();
  } else {
    _log.severe(
        "[getAppPassword] Failed while requesting app password: $response");
    throw ApiException(
        response: response,
        message: "Server responded with an error: HTTP ${response.statusCode}");
  }
}

/// Polls the app password endpoint every 5 seconds as lang as the token is valid (currently fixed to 20 min)
/// See https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html#login-flow-v2
Stream<Future<AppPasswordResponse>> pollAppPassword(
    InitiateLoginPollOptions options) {
  return Stream.periodic(
          const Duration(seconds: 5), (_) => _getAppPassword(options))
      .takeWhile((_) => options.isTokenValid());
}

@toString
class InitiateLoginResponse {
  const InitiateLoginResponse({
    required this.poll,
    required this.login,
  });

  factory InitiateLoginResponse.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return InitiateLoginResponse(
      poll: InitiateLoginPollOptions(
          json['poll']['token'], json['poll']['endpoint']),
      login: json['login'],
    );
  }

  @override
  String toString() => _$toString();

  final InitiateLoginPollOptions poll;
  final String login;
}

@toString
class InitiateLoginPollOptions {
  InitiateLoginPollOptions(this.token, String endpoint)
      : endpoint = Uri.parse(endpoint),
        _validUntil = clock.now().add(const Duration(minutes: 20));

  @override
  String toString() => _$toString();

  bool isTokenValid() {
    return clock.now().isBefore(_validUntil);
  }

  @Format(r"${isDevMode ? $? : '***'}")
  final String token;
  final Uri endpoint;
  final DateTime _validUntil;
}

abstract class AppPasswordResponse {}

@toString
class AppPasswordSuccess implements AppPasswordResponse {
  const AppPasswordSuccess({
    required this.server,
    required this.loginName,
    required this.appPassword,
  });

  factory AppPasswordSuccess.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return AppPasswordSuccess(
      server: Uri.parse(json['server']),
      loginName: json['loginName'],
      appPassword: json['appPassword'],
    );
  }

  @override
  String toString() => _$toString();

  final Uri server;
  final String loginName;
  @Format(r"${isDevMode ? appPassword : '***'}")
  final String appPassword;
}

class AppPasswordPending implements AppPasswordResponse {}

final _log = Logger("api.api_util");
