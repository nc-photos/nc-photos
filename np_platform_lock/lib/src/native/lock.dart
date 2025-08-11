import 'package:flutter/services.dart';
import 'package:np_platform_lock/src/k.dart' as k;

class Lock {
  static Future<bool> tryLock(int lockId) async {
    return (await _channel.invokeMethod<bool>("tryLock", <String, dynamic>{
      "lockId": lockId,
    }))!;
  }

  static Future<void> unlock(int lockId) =>
      _channel.invokeMethod("unlock", <String, dynamic>{"lockId": lockId});

  static const _channel = MethodChannel("${k.libId}/lock");
}
