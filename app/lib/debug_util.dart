import 'dart:async';
import 'dart:convert';

import 'package:nc_photos/mobile/platform.dart'
    if (dart.library.html) 'package:nc_photos/web/platform.dart'
    as platform;
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:path/path.dart' as path_lib;

class LogCapturer {
  factory LogCapturer() {
    _inst ??= LogCapturer._();
    return _inst!;
  }

  LogCapturer._();

  /// Start capturing logs
  void start() {
    _subscription ??= LogStream().stream.listen(_logs.add);
  }

  /// Stop capturing and save the captured logs
  Future<dynamic> stop() {
    _subscription?.cancel();
    _subscription = null;
    final saver = platform.FileSaver();
    final content = const Utf8Encoder().convert(_logs.join("\n"));
    _logs.clear();
    return saver.saveFile("nc-photos.log", content);
  }

  bool get isEnable => _subscription != null;

  final _logs = <String>[];
  StreamSubscription? _subscription;

  static LogCapturer? _inst;
}

String logFilename(String? filename, {bool? shouldLogFileName}) {
  if ((shouldLogFileName ?? isDevMode) || filename == null) {
    return "$filename";
  }
  try {
    final basename = path_lib.basenameWithoutExtension(filename);
    final displayName =
        basename.length <= 6
            ? basename
            : "${basename.slice(0, 3)}***${basename.slice(-3)}";
    return "${path_lib.dirname(filename) != "." ? "***/" : ""}"
        "$displayName"
        "${path_lib.extension(filename)}";
  } catch (_) {
    return "***";
  }
}
