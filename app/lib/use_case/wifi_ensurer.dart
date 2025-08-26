import 'package:nc_photos/connectivity_util.dart' as connectivity_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/service/service.dart';
import 'package:rxdart/rxdart.dart';

class WifiEnsurer {
  WifiEnsurer({this.interrupter}) {
    interrupter?.listen((event) {
      _shouldRun = false;
    });
  }

  Future<void> call() async {
    var count = 0;
    while (await ServiceConfig.isProcessExifWifiOnly() &&
        !await connectivity_util.isWifi()) {
      if (!_shouldRun) {
        throw const InterruptedException();
      }
      // give a chance to reconnect with the WiFi network
      if (++count >= 6) {
        if (!_isWaiting.value) {
          _isWaiting.add(true);
        }
      }
      await Future.delayed(const Duration(seconds: 5));
    }
    if (_isWaiting.value) {
      _isWaiting.add(false);
    }
  }

  ValueStream<bool> get isWaiting => _isWaiting.stream;

  final Stream<void>? interrupter;

  var _shouldRun = true;
  final _isWaiting = BehaviorSubject.seeded(false);
}
