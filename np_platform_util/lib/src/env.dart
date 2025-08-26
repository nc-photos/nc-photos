import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum NpPlatform {
  android,
  fuchsia,
  iOs,
  linux,
  macOs,
  web,
  windows;

  bool get isMobile => this == android || this == iOs;
  bool get isDesktop =>
      this == fuchsia || this == linux || this == macOs || this == windows;
  bool get isApple => this == iOs || this == macOs;
}

/// Get the current running platform
///
/// This function does not take the current context into account
NpPlatform getRawPlatform() {
  if (kIsWeb) {
    return NpPlatform.web;
  } else {
    return defaultTargetPlatform.toPlatform();
  }
}

/// Get the current platform from [context]
NpPlatform getThemePlatform(BuildContext context) {
  if (kIsWeb) {
    return NpPlatform.web;
  } else {
    return Theme.of(context).platform.toPlatform();
  }
}

final isUnitTest = !kIsWeb && Platform.environment.containsKey("FLUTTER_TEST");

extension on TargetPlatform {
  NpPlatform toPlatform() {
    switch (this) {
      case TargetPlatform.android:
        return NpPlatform.android;
      case TargetPlatform.iOS:
        return NpPlatform.iOs;
      case TargetPlatform.linux:
        return NpPlatform.linux;
      case TargetPlatform.macOS:
        return NpPlatform.macOs;
      case TargetPlatform.windows:
        return NpPlatform.windows;
      case TargetPlatform.fuchsia:
        return NpPlatform.fuchsia;
    }
  }
}
