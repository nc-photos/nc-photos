import 'dart:async';

import 'package:flutter/services.dart';
import 'package:np_platform_image_processor/src/event.dart';
import 'package:np_platform_image_processor/src/event_handler.dart';
import 'package:np_platform_image_processor/src/k.dart' as k;

abstract class ImageFilter {
  Map<String, dynamic> toJson();
}

class ImageProcessor {
  static Stream<ImageProcessorEvent> get stream => EventHandler.stream;

  static Future<void> zeroDce(
    Uri fileUri,
    String filename,
    int maxWidth,
    int maxHeight,
    int iteration, {
    Map<String, String>? headers,
    required bool isSaveToServer,
  }) => _methodChannel.invokeMethod("zeroDce", <String, dynamic>{
    "fileUri": fileUri.toString(),
    "headers": headers,
    "filename": filename,
    "maxWidth": maxWidth,
    "maxHeight": maxHeight,
    "iteration": iteration,
    "isSaveToServer": isSaveToServer,
  });

  static Future<void> deepLab3Portrait(
    Uri fileUri,
    String filename,
    int maxWidth,
    int maxHeight,
    int radius, {
    Map<String, String>? headers,
    required bool isSaveToServer,
  }) => _methodChannel.invokeMethod("deepLab3Portrait", <String, dynamic>{
    "fileUri": fileUri.toString(),
    "headers": headers,
    "filename": filename,
    "maxWidth": maxWidth,
    "maxHeight": maxHeight,
    "radius": radius,
    "isSaveToServer": isSaveToServer,
  });

  static Future<void> esrgan(
    Uri fileUri,
    String filename,
    int maxWidth,
    int maxHeight, {
    Map<String, String>? headers,
    required bool isSaveToServer,
  }) => _methodChannel.invokeMethod("esrgan", <String, dynamic>{
    "fileUri": fileUri.toString(),
    "headers": headers,
    "filename": filename,
    "maxWidth": maxWidth,
    "maxHeight": maxHeight,
    "isSaveToServer": isSaveToServer,
  });

  static Future<void> arbitraryStyleTransfer(
    Uri fileUri,
    String filename,
    int maxWidth,
    int maxHeight,
    String styleUri,
    double weight, {
    Map<String, String>? headers,
    required bool isSaveToServer,
  }) => _methodChannel.invokeMethod("arbitraryStyleTransfer", <String, dynamic>{
    "fileUri": fileUri.toString(),
    "headers": headers,
    "filename": filename,
    "maxWidth": maxWidth,
    "maxHeight": maxHeight,
    "styleUri": styleUri,
    "weight": weight,
    "isSaveToServer": isSaveToServer,
  });

  static Future<void> deepLab3ColorPop(
    Uri fileUri,
    String filename,
    int maxWidth,
    int maxHeight,
    double weight, {
    Map<String, String>? headers,
    required bool isSaveToServer,
  }) => _methodChannel.invokeMethod("deepLab3ColorPop", <String, dynamic>{
    "fileUri": fileUri.toString(),
    "headers": headers,
    "filename": filename,
    "maxWidth": maxWidth,
    "maxHeight": maxHeight,
    "weight": weight,
    "isSaveToServer": isSaveToServer,
  });

  static Future<void> neurOp(
    Uri fileUri,
    String filename,
    int maxWidth,
    int maxHeight, {
    Map<String, String>? headers,
    required bool isSaveToServer,
  }) => _methodChannel.invokeMethod("neurOp", <String, dynamic>{
    "fileUri": fileUri.toString(),
    "headers": headers,
    "filename": filename,
    "maxWidth": maxWidth,
    "maxHeight": maxHeight,
    "isSaveToServer": isSaveToServer,
  });

  static const _methodChannel = MethodChannel(
    "${k.libId}/image_processor_method",
  );
}
