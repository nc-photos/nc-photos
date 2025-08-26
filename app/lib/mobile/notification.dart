import 'package:logging/logging.dart';
import 'package:nc_photos/platform/notification.dart' as itf;
import 'package:nc_photos_plugin/nc_photos_plugin.dart' as plugin;
import 'package:np_log/np_log.dart';

part 'notification.g.dart';

@npLog
class NotificationManager implements itf.NotificationManager {
  @override
  notify(itf.Notification n) {
    if (n is itf.LogSaveSuccessfulNotification) {
      return plugin.Notification.notifyLogSaveSuccessful(n.result);
    } else if (n is AndroidDownloadSuccessfulNotification) {
      return plugin.Notification.notifyDownloadSuccessful(
        n.fileUris,
        n.mimeTypes,
        n.notificationId,
      );
    } else if (n is AndroidDownloadProgressNotification) {
      return plugin.Notification.notifyDownloadProgress(
        n.progress,
        n.max,
        n.currentItemTitle,
        n.notificationId,
      );
    } else {
      _log.shout("[notify] Unknown type: ${n.runtimeType}");
      throw UnsupportedError("Unsupported notification");
    }
  }

  @override
  dismiss(dynamic id) async {
    if (id != null) {
      return plugin.Notification.dismiss(id);
    } else {
      return;
    }
  }
}

class AndroidDownloadSuccessfulNotification implements itf.Notification {
  const AndroidDownloadSuccessfulNotification(
    this.fileUris,
    this.mimeTypes, {
    this.notificationId,
  });

  final List<String> fileUris;
  final List<String?> mimeTypes;
  final dynamic notificationId;
}

class AndroidDownloadProgressNotification implements itf.Notification {
  const AndroidDownloadProgressNotification(
    this.progress,
    this.max, {
    this.currentItemTitle,
    this.notificationId,
  });

  AndroidDownloadProgressNotification copyWith({
    int? progress,
    String? currentItemTitle,
    dynamic notificationId,
  }) => AndroidDownloadProgressNotification(
    progress ?? this.progress,
    max,
    currentItemTitle: currentItemTitle ?? this.currentItemTitle,
    notificationId: notificationId ?? this.notificationId,
  );

  final int progress;
  final int max;
  final String? currentItemTitle;
  final dynamic notificationId;
}
