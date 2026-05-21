import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/share.dart';

class AppEventListener<T> {
  AppEventListener(this._listener);

  void begin() {
    if (_subscription != null) {
      _log.warning("[begin] Already listening");
      return;
    }
    _subscription = _stream.listen(_listener);
  }

  void end() {
    if (_subscription == null) {
      _log.warning("[end] Already not listening");
      return;
    }
    _subscription?.cancel();
    _subscription = null;
  }

  final void Function(T) _listener;
  final _stream = KiwiContainer().resolve<EventBus>().on<T>();
  StreamSubscription<T>? _subscription;

  final _log = Logger("event.event.AppEventListener<${T.runtimeType}>");
}

@Deprecated("not fired anymore, to be removed")
class AccountPrefUpdatedEvent {
  const AccountPrefUpdatedEvent(this.pref, this.key, this.value);

  final AccountPref pref;
  final AccountPrefKey key;
  final dynamic value;
}

@Deprecated("not fired anymore, to be removed")
class FilePropertyUpdatedEvent {
  FilePropertyUpdatedEvent(this.account, this.file, this.properties);

  final Account account;
  final FileDescriptor file;
  final int properties;

  // Bit masks for properties field
  static const propMetadata = 0x01;
  static const propIsArchived = 0x02;
  static const propOverrideDateTime = 0x04;
  static const propFavorite = 0x08;
  static const propImageLocation = 0x10;
}

class FileRemovedEvent {
  FileRemovedEvent(this.account, this.file);

  final Account account;
  final FileDescriptor file;
}

class FileTrashbinRestoredEvent {
  FileTrashbinRestoredEvent(this.account, this.file);

  final Account account;
  final File file;
}

class FileMovedEvent {
  FileMovedEvent(this.account, this.file, this.destination);

  final Account account;
  final FileDescriptor file;
  final String destination;
}

class ShareRemovedEvent {
  const ShareRemovedEvent(this.account, this.share);

  final Account account;
  final Share share;
}

@Deprecated("not fired anymore, to be removed")
class FavoriteResyncedEvent {
  const FavoriteResyncedEvent(this.account);

  final Account account;
}

@Deprecated("not fired anymore, to be removed")
class PrefUpdatedEvent {
  PrefUpdatedEvent(this.key, this.value);

  final PrefKey key;
  final dynamic value;
}

class LocalFileDeletedEvent {
  const LocalFileDeletedEvent(this.files);

  final List<LocalFile> files;
}

extension FilePropertyUpdatedEventExtension on FilePropertyUpdatedEvent {
  bool hasAnyProperties(List<int> properties) =>
      properties.any((p) => this.properties & p != 0);
}
