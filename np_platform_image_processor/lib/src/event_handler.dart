import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_image_processor/src/event.dart';
import 'package:np_platform_image_processor/src/k.dart' as k;

part 'event_handler.g.dart';

@npLog
class EventHandler {
  static Stream<ImageProcessorEvent> get stream =>
      _eventChannel.receiveBroadcastStream().map(_toEvent).whereNotNull();

  static ImageProcessorEvent? _toEvent(dynamic ev) {
    try {
      return ImageProcessorEvent.fromNativeEvent(ev);
    } catch (e, stackTrace) {
      _log.severe("Failed while parsing native events", e, stackTrace);
      return null;
    }
  }

  static const _eventChannel = EventChannel("${k.libId}/image_processor_event");

  static final _log = _$EventHandlerNpLog.log;
}

extension<T> on Stream<T?> {
  Stream<T> whereNotNull() => where((e) => e != null).cast<T>();
}
