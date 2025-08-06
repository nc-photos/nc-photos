import 'package:logging/logging.dart';
import 'package:nc_photos/stream_extension.dart';
import 'package:np_platform_permission/np_platform_permission.dart';

Future<Map<String, int>> requestPermissionsForResult(
  List<String> permissions,
) => _doRequest(() => Permission.request(permissions));

Future<Map<String, int>> requestReadExternalStorageForResult() =>
    _doRequest(() => Permission.requestReadExternalStorage());

Future<Map<String, int>> requestPostNotificationsForResult() =>
    _doRequest(() => Permission.requestPostNotifications());

Future<Map<String, int>> _doRequest(Future Function() op) async {
  Map<String, int>? result;
  final resultFuture = Permission.stream
      .whereType<PermissionRequestResult>()
      .first
      .then((ev) => result = ev.grantResults);
  await op();
  await resultFuture;
  _log.info("[_doRequest] Result: $result");
  return result!;
}

final _log = Logger("mobile.android.permission_util");
