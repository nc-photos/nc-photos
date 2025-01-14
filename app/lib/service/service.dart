import 'dart:async';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_init.dart' as app_init;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/event/native_event.dart';
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/use_case/battery_ensurer.dart';
import 'package:nc_photos/use_case/sync_metadata/sync_metadata.dart';
import 'package:nc_photos/use_case/wifi_ensurer.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_async/np_async.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:np_platform_message_relay/np_platform_message_relay.dart';

part 'config.dart';
part 'l10n.dart';
part 'service.g.dart';

/// Start the background service
Future<void> startService({
  required PrefController prefController,
}) async {
  _$__NpLog.log.info("[startService] Starting service");
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: serviceMain,
      autoStart: false,
      isForegroundMode: true,
      foregroundServiceNotificationTitle:
          L10n.global().metadataTaskProcessingNotification,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: () => throw UnimplementedError(),
      onBackground: () => throw UnimplementedError(),
    ),
  );
  // sync settings
  await ServiceConfig.setProcessExifWifiOnly(
      prefController.shouldProcessExifWifiOnlyValue);
  await ServiceConfig.setEnableClientExif(
      prefController.isEnableClientExifValue);
  await ServiceConfig.setFallbackClientExif(
      prefController.isFallbackClientExifValue);
  await service.start();
}

/// Ask the background service to stop ASAP
void stopService() {
  _$__NpLog.log.info("[stopService] Stopping service");
  FlutterBackgroundService().sendData({
    _dataKeyEvent: _eventStop,
  });
}

@visibleForTesting
@pragma("vm:entry-point")
Future<void> serviceMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _Service()();
}

@npLog
class _Service {
  Future<void> call() async {
    final service = FlutterBackgroundService();
    service.setForegroundMode(true);

    await app_init.init(app_init.InitIsolateType.flutterIsolate);
    await _L10n().init();

    _log.info("[call] Service started");
    final onCancelSubscription = service.onCancel.listen((_) {
      _log.info("[call] User canceled");
      _stopSelf();
    });
    final onDataSubscription =
        service.onDataReceived.listen((event) => _onNotifAction(event ?? {}));

    try {
      await _doWork();
    } catch (e, stackTrace) {
      _log.shout("[call] Uncaught exception", e, stackTrace);
    }
    await onCancelSubscription.cancel();
    await onDataSubscription.cancel();
    await KiwiContainer().resolve<DiContainer>().npDb.dispose();
    service.stopBackgroundService();
    _log.info("[call] Service stopped");
  }

  Future<void> _doWork() async {
    final c = KiwiContainer().resolve<DiContainer>();
    final prefController = PrefController(c.pref);
    final account = prefController.currentAccountValue;
    if (account == null) {
      _log.shout("[_doWork] account == null");
      return;
    }
    final accountPrefController = AccountPrefController(account: account);

    final wifiEnsurer = WifiEnsurer(
      interrupter: _shouldRun.stream,
    );
    wifiEnsurer.isWaiting.listen((event) {
      if (event) {
        FlutterBackgroundService()
          ..setNotificationInfo(
            title: _L10n.global().metadataTaskPauseNoWiFiNotification,
          )
          ..pauseWakeLock();
      } else {
        FlutterBackgroundService().resumeWakeLock();
      }
    });
    final batteryEnsurer = BatteryEnsurer(
      interrupter: _shouldRun.stream,
    );
    batteryEnsurer.isWaiting.listen((event) {
      if (event) {
        FlutterBackgroundService()
          ..setNotificationInfo(
            title: _L10n.global().metadataTaskPauseLowBatteryNotification,
          )
          ..pauseWakeLock();
      } else {
        FlutterBackgroundService().resumeWakeLock();
      }
    });

    final service = FlutterBackgroundService();
    final syncOp = SyncMetadata(
      fileRepo: c.fileRepo,
      fileRepo2: c.fileRepo2,
      fileRepoRemote: c.fileRepoRemote,
      db: c.npDb,
      interrupter: _shouldRun.stream,
      wifiEnsurer: wifiEnsurer,
      batteryEnsurer: batteryEnsurer,
    );
    final processedIds = <int>[];
    await for (final f in syncOp.syncAccount(account, accountPrefController)) {
      processedIds.add(f.fdId);
      service.setNotificationInfo(
        title: _L10n.global().metadataTaskProcessingNotification,
        content: f.strippedPath,
      );
    }
    if (processedIds.isNotEmpty) {
      await MessageRelay.broadcast(
          FileExifUpdatedEvent(processedIds).toEvent());
    }
  }

  void _onNotifAction(Map<String, dynamic> data) {
    try {
      final event = data[_dataKeyEvent];
      switch (event) {
        case _eventStop:
          _stopSelf();
          break;

        default:
          _log.severe("[_onNotifAction] Unknown event: $event");
          break;
      }
    } catch (e, stackTrace) {
      _log.shout("[_onNotifAction] Uncaught exception", e, stackTrace);
    }
  }

  void _stopSelf() {
    _log.info("[_stopSelf] Stopping service");
    FlutterBackgroundService().setNotificationInfo(
      title: _L10n.global().backgroundServiceStopping,
    );
    _shouldRun.add(null);
  }

  final _shouldRun = StreamController<void>.broadcast();
}

@npLog
// ignore: camel_case_types
class __ {}

const _dataKeyEvent = "event";
const _eventStop = "stop";
