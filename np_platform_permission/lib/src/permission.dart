// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:np_platform_permission/src/k.dart' as k;

class Permission {
  static const READ_EXTERNAL_STORAGE =
      "android.permission.READ_EXTERNAL_STORAGE";
  static const READ_MEDIA_IMAGES = "android.permission.READ_MEDIA_IMAGES";
  static const WRITE_EXTERNAL_STORAGE =
      "android.permission.WRITE_EXTERNAL_STORAGE";

  static Future<void> request(List<String> permissions) => _methodChannel
      .invokeMethod("request", <String, dynamic>{"permissions": permissions});

  static Future<bool> hasWriteExternalStorage() async {
    return (await _methodChannel.invokeMethod<bool>(
      "hasWriteExternalStorage",
    ))!;
  }

  static Future<bool> hasReadMedia() async {
    return (await _methodChannel.invokeMethod<bool>("hasReadMedia"))!;
  }

  static Future<void> requestReadMedia() =>
      _methodChannel.invokeMethod("requestReadMedia");

  static Stream get stream => _eventStream;

  static final _eventStream = _eventChannel.receiveBroadcastStream().map((
    event,
  ) {
    if (event is Map) {
      switch (event["event"]) {
        case _eventRequestPermissionsResult:
          return PermissionRequestResult(
            (event["grantResults"] as Map).cast<String, int>(),
          );

        default:
          _log.shout("[_eventStream] Unknown event: ${event["event"]}");
      }
    } else {
      return event;
    }
  });

  static const _eventChannel = EventChannel("${k.libId}/permission");
  static const _methodChannel = MethodChannel("${k.libId}/permission_method");

  static const _eventRequestPermissionsResult = "RequestPermissionsResult";

  static final _log = Logger("plugin.permission.Permission");
}

class PermissionRequestResult {
  static const granted = 0;
  static const denied = -1;

  const PermissionRequestResult(this.grantResults);

  final Map<String, int> grantResults;
}
