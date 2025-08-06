import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/platform/notification.dart' as itf;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:np_log/np_log.dart';

part 'notification.g.dart';

@npLog
class NotificationManager implements itf.NotificationManager {
  @override
  notify(itf.Notification n) async {
    if (n is itf.LogSaveSuccessfulNotification) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().captureLogSuccessNotification),
          duration: k.snackBarDurationShort,
        ),
      );
    } else {
      _log.shout("[notify] Unknown type: ${n.runtimeType}");
      throw UnsupportedError("Unsupported notification");
    }
  }

  @override
  dismiss(dynamic id) async {
    return;
  }
}
