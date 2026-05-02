import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

/// Hold non-persisted global variables
class SessionStorage {
  factory SessionStorage() {
    return _inst;
  }

  SessionStorage._();

  /// Whether the range select notification has been shown to user
  bool hasShowRangeSelectNotification = false;

  /// Whether the drag to rearrange notification has been shown
  bool hasShowDragRearrangeNotification = false;

  /// Whether the dynamic_color library is supported in this platform
  bool isSupportDynamicColor = false;
  ColorScheme? lightDynamicColorScheme;
  ColorScheme? darkDynamicColorScheme;

  DateTime lastSuspendTime = clock.now();

  bool hasShownVideoPreviewHint = false;

  Map<String, String> accountRecognizeApiKeys = {};

  static final _inst = SessionStorage._();
}
