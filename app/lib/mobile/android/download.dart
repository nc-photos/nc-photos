import 'dart:async';

import 'package:flutter/services.dart';

class DownloadEvent {
  static Stream<DownloadCancelEvent> downloadCancelStream() =>
      _downloadCancelChannel.receiveBroadcastStream().map(
        (data) => DownloadCancelEvent(data["notificationId"]),
      );

  /// User canceled the download job
  static const exceptionCodeUserCanceled = "userCanceled";

  static const _downloadCancelChannel = EventChannel(
    "com.nkming.nc_photos/download_event/action_download_cancel",
  );
}

class DownloadCancelEvent {
  const DownloadCancelEvent(this.notificationId);

  final int notificationId;
}
