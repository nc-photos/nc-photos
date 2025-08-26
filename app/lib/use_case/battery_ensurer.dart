import 'package:battery_plus/battery_plus.dart';
import 'package:nc_photos/exception.dart';
import 'package:rxdart/rxdart.dart';

class BatteryEnsurer {
  BatteryEnsurer({this.interrupter}) {
    interrupter?.listen((event) {
      _shouldRun = false;
    });
  }

  Future<void> call() async {
    while (await Battery().batteryLevel <= 15) {
      if (!_shouldRun) {
        throw const InterruptedException();
      }
      if (!_isWaiting.value) {
        _isWaiting.add(true);
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
