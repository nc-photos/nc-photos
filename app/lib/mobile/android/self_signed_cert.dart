import 'package:flutter/services.dart';

class SelfSignedCert {
  static Future<void> reload() => _channel.invokeMethod("reload");

  static const _channel = MethodChannel(
    "com.nkming.nc_photos/self-signed-cert",
  );
}
