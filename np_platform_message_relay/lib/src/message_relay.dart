import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_message_relay/src/k.dart' as k;

part 'message_relay.g.dart';

class Message {
  const Message(this.event, this.data);

  static Message fromJson(Map<String, dynamic> json) {
    return Message(json["event"], json["data"]);
  }

  Map<String, dynamic> toJson() => {
        "event": event,
        if (data != null) "data": data,
      };

  final String event;
  final String? data;
}

/// Relay messages via native side
///
/// Typically used to broadcast messages across different Flutter engines (e.g.,
/// main isolate <-> background isolates)
///
/// Beware that the isolate that broadcasted the message will also receive the
/// message if subscribed
@npLog
class MessageRelay {
  static Future<void> broadcast(Message msg) =>
      _methodChannel.invokeMethod("broadcast", msg.toJson());

  static Stream<Message> get stream =>
      _eventChannel.receiveBroadcastStream().map(_toEvent).whereNotNull();

  static Message? _toEvent(dynamic ev) {
    try {
      return Message.fromJson((ev as Map).cast<String, dynamic>());
    } catch (e, stackTrace) {
      _log.severe("Failed while parsing native events", e, stackTrace);
      return null;
    }
  }

  static const _eventChannel = EventChannel("${k.libId}/message_relay_event");
  static const _methodChannel =
      MethodChannel("${k.libId}/message_relay_method");

  static final _log = _$MessageRelayNpLog.log;
}

extension<T> on Stream<T?> {
  Stream<T> whereNotNull() => where((e) => e != null).cast<T>();
}
