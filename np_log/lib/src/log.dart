import 'dart:async';

import 'package:logging/logging.dart';

void initLog({required bool isDebugMode, void Function(String) print = print}) {
  Logger.root.level = !isDebugMode ? Level.WARNING : Level.ALL;
  Logger.root.onRecord.listen((record) {
    String msg =
        "[${record.loggerName}] ${record.level.name} ${record.time}: ${record.message}";
    if (record.error != null) {
      msg += " (throw: ${record.error.runtimeType} { ${record.error} })";
    }
    if (record.stackTrace != null) {
      msg += "\nStack Trace:\n${record.stackTrace}";
    }

    if (isDebugMode) {
      // show me colors!
      int color;
      if (record.level >= Level.SEVERE) {
        color = 91;
      } else if (record.level >= Level.WARNING) {
        color = 33;
      } else if (record.level >= Level.INFO) {
        color = 34;
      } else if (record.level >= Level.FINER) {
        color = 32;
      } else {
        color = 90;
      }
      msg = "\x1B[${color}m$msg\x1B[0m";
    }
    print(msg);
    LogStream().add(msg);
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
