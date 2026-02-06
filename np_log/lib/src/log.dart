import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_platform_util/np_platform_util.dart';

void initLog({required bool isDebugMode}) {
  Logger.root.level = !isDebugMode ? Level.WARNING : Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (record.loggerName == "SuperSliverList") {
      return;
    }

    var msg =
        "[${record.loggerName}] ${record.level.name} ${record.time}: ${record.message}";
    if (record.error != null) {
      msg += " (throw: ${record.error.runtimeType} { ${record.error} })";
    }
    if (record.stackTrace != null) {
      msg += "\nStack Trace:\n${record.stackTrace}";
    }
    LogStream().add(msg);

    if (getRawPlatform() == NpPlatform.iOs) {
      var msg2 = "${record.level.name} ${record.time}: ${record.message}";
      if (record.error != null) {
        msg2 += " (throw: ${record.error.runtimeType})";
      }
      developer.log(
        _colorized(msg2, record.level),
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    } else {
      debugPrint(_colorized(msg, record.level), wrapWidth: 1024);
    }
  });
}

class LogStream {
  factory LogStream() {
    _inst ??= LogStream._();
    return _inst!;
  }

  LogStream._();

  void add(String log) {
    _stream.add(log);
  }

  Stream<String> get stream => _stream.stream;

  static LogStream? _inst;

  final _stream = StreamController<String>.broadcast();
}

String _colorized(String msg, Level level) {
  int color;
  if (level >= Level.SEVERE) {
    color = 91;
  } else if (level >= Level.WARNING) {
    color = 33;
  } else if (level >= Level.INFO) {
    color = 34;
  } else if (level >= Level.FINER) {
    color = 32;
  } else {
    color = 90;
  }
  return "\x1B[${color}m$msg\x1B[0m";
}
