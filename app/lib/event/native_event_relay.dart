import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/metadata_controller.dart';
import 'package:nc_photos/event/native_event.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/stream_extension.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_image_processor/np_platform_image_processor.dart';
import 'package:np_platform_message_relay/np_platform_message_relay.dart';

part 'native_event_relay.g.dart';

/// Convert native events into actions on the corresponding controllers
@npLog
class NativeEventRelay {
  NativeEventRelay({
    required this.filesController,
    required this.metadataController,
  }) {
    _subscriptions.add(
      MessageRelay.stream.whereType<Message>().listen((event) {
        switch (event.event) {
          case FileExifUpdatedEvent.id:
            _onFileExifUpdatedEvent(FileExifUpdatedEvent.fromEvent(event));
            break;

          default:
            _log.severe('Unknown event: ${event.event}');
            break;
        }
      }),
    );

    if (features.isSupportEnhancement) {
      _subscriptions.add(
        ImageProcessor.stream
            .whereType<ImageProcessorUploadSuccessEvent>()
            .listen(_onImageProcessorUploadSuccessEvent),
      );
    }
  }

  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
  }

  void _onFileExifUpdatedEvent(FileExifUpdatedEvent ev) {
    _log.info(ev);
    filesController.applySyncResult(fileExifs: ev.fileIds);
  }

  void _onImageProcessorUploadSuccessEvent(
    ImageProcessorUploadSuccessEvent ev,
  ) {
    _log.info(ev);
    filesController.syncRemote();
    metadataController.scheduleNext();
  }

  final FilesController filesController;
  final MetadataController metadataController;
  final _subscriptions = <StreamSubscription>[];
}
