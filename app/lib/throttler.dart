import 'dart:async';
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:np_log/np_log.dart';
import 'package:np_math/np_math.dart';

part 'throttler.g.dart';

/// Throttle how many times an event could be triggered
///
/// Events can be filtered by 2 ways:
/// 1. Time passed after the last event
/// 2. Number of events
@npLog
class Throttler<T> {
  Throttler({required this.onTriggered, this.logTag});

  /// Post an event
  ///
  /// [data] can be used to provide optional data. When the stream of events
  /// eventually trigger, a list of all data received will be passed to the
  /// callback. Nulls are ignored
  void trigger({
    Duration maxResponceTime = const Duration(seconds: 1),
    int? maxPendingCount,
    T? data,
  }) {
    _count += 1;
    if (data != null) {
      _data.add(data);
    }
    _subscription?.cancel();
    _subscription = null;
    if (maxPendingCount != null) {
      _maxCount = math.min(maxPendingCount, _maxCount ?? int32Max);
    }
    if (_maxCount != null && _count >= _maxCount!) {
      _log.info("[trigger]$_logTag Triggered after $_count events");
      _doTrigger();
    } else {
      final responseTime = _minDuration(
        maxResponceTime,
        _currentResponseTime ?? const Duration(days: 1),
      );
      _subscription = Future.delayed(responseTime).asStream().listen((event) {
        _log.info("[trigger]$_logTag Triggered after $responseTime");
        _doTrigger();
      });
      _currentResponseTime = responseTime;
    }
  }

  /// Drop all pending triggers, this may be useful in places like [dispose]
  void clear() {
    _subscription?.cancel();
    _subscription = null;
    _currentResponseTime = null;
    _count = 0;
    _maxCount = null;
    // _data may be used else where, thus we must not call List.clear() here
    _data = <T>[];
  }

  Future<void> triggerNow() async {
    if (_hasPendingEvent) {
      _log.info("[triggerNow]$_logTag Triggered");
      return _doTrigger();
    }
  }

  Future<void> _doTrigger() async {
    if (_hasPendingEvent) {
      final data = _data;
      clear();
      await onTriggered?.call(data);
    }
  }

  bool get _hasPendingEvent => _count > 0;

  String get _logTag => logTag == null ? "" : "[$logTag]";

  final FutureOr<void> Function(List<T>)? onTriggered;

  /// Extra tag printed with logs from this class
  final String? logTag;

  StreamSubscription<void>? _subscription;
  Duration? _currentResponseTime;
  int _count = 0;
  int? _maxCount;
  var _data = <T>[];
}

Duration _minDuration(Duration a, Duration b) {
  return a.compareTo(b) < 0 ? a : b;
}
