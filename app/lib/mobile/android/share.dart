import 'package:flutter/services.dart';

class Share {
  static Future<void> shareItems(
    List<String> fileUris,
    List<String?> mimeTypes,
  ) => _channel.invokeMethod("shareItems", <String, dynamic>{
    "fileUris": fileUris,
    "mimeTypes": mimeTypes,
  });

  static Future<void> shareText(String text, String? mimeType) =>
      _channel.invokeMethod("shareText", <String, dynamic>{
        "text": text,
        "mimeType": mimeType,
      });

  static Future<void> shareAsAttachData(String fileUri, String? mimeType) =>
      _channel.invokeMethod("shareAsAttachData", <String, dynamic>{
        "fileUri": fileUri,
        "mimeType": mimeType,
      });

  static const _channel = MethodChannel("com.nkming.nc_photos/share");
}
