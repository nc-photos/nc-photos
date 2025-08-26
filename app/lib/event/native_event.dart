import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/stream_extension.dart';
import 'package:np_platform_message_relay/np_platform_message_relay.dart';
import 'package:to_string/to_string.dart';

part 'native_event.g.dart';

@Deprecated("See AccountController.NativeEventRelay")
class NativeEventListener<T> {
  NativeEventListener(this.listener);

  void begin() {
    if (_subscription != null) {
      _log.warning("[begin] Already listening");
      return;
    }
    _subscription = _mappedStream.whereType<T>().listen(listener);
  }

  void end() {
    if (_subscription == null) {
      _log.warning("[end] Already not listening");
      return;
    }
    _subscription?.cancel();
    _subscription = null;
  }

  static final _mappedStream = MessageRelay.stream.whereType<Message>().map((
    ev,
  ) {
    switch (ev.event) {
      case FileExifUpdatedEvent.id:
        return FileExifUpdatedEvent.fromEvent(ev);

      default:
        throw ArgumentError("Invalid event: ${ev.event}");
    }
  });

  final void Function(T) listener;
  StreamSubscription<T>? _subscription;

  final _log = Logger(
    "event.native_event.NativeEventListener<${T.runtimeType}>",
  );
}

@toString
class FileExifUpdatedEvent {
  const FileExifUpdatedEvent(this.fileIds);

  factory FileExifUpdatedEvent.fromEvent(Message ev) {
    assert(ev.event == id);
    assert(ev.data != null);
    final dataJson = jsonDecode(ev.data!) as Map;
    return FileExifUpdatedEvent((dataJson["fileIds"] as List).cast<int>());
  }

  Message toEvent() => Message(id, jsonEncode({"fileIds": fileIds}));

  @override
  String toString() => _$toString();

  static const id = "FileExifUpdatedEvent";

  final List<int> fileIds;
}
