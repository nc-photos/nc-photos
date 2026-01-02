import 'dart:async';

import 'package:nc_photos/connectivity_util.dart' as connectivity_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/service/service.dart';
import 'package:rxdart/rxdart.dart';

class WifiEnsurer {
  WifiEnsurer({this.interrupter, this.progressLogger}) {
    interrupter?.listen((event) {
      _shouldRun = false;
    });
  }

  Future<void> call() async {
    var count = 0;
    var isLogged = false;
    while (await ServiceConfig.isProcessExifWifiOnly() &&
        !await connectivity_util.isWifi()) {
      if (!_shouldRun) {
        throw const InterruptedException();
      }
      // give a chance to reconnect with the WiFi network
      if (++count >= 60) {
        if (!_isWaiting.value) {
          _isWaiting.add(true);
        }
      }
      if (!isLogged) {
        progressLogger?.add("Blocked by WifiEnsurer");
        isLogged = true;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    if (_isWaiting.value) {
      _isWaiting.add(false);
    }
  }

  ValueStream<bool> get isWaiting => _isWaiting.stream;

  final Stream<void>? interrupter;
  final StreamController<String>? progressLogger;

  var _shouldRun = true;
  final _isWaiting = BehaviorSubject.seeded(false);
}
