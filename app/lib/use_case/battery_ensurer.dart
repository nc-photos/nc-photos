import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:nc_photos/exception.dart';
import 'package:rxdart/rxdart.dart';

class BatteryEnsurer {
  BatteryEnsurer({this.interrupter, this.progressLogger}) {
    interrupter?.listen((event) {
      _shouldRun = false;
    });
  }

  Future<void> call() async {
    var isLogged = false;
    while (await Battery().batteryLevel <= 15) {
      if (!_shouldRun) {
        throw const InterruptedException();
      }
      if (!_isWaiting.value) {
        _isWaiting.add(true);
      }
      if (!isLogged) {
        progressLogger?.add("Blocked by BatteryEnsurer");
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
