import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/persons_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/use_case/startup_sync.dart';

class SyncController {
  SyncController({this.onPeopleUpdated});

  void dispose() {
    _isDisposed = true;
  }

  Future<void> requestSync({
    required Account account,
    required FilesController filesController,
    required PersonsController personsController,
    required PersonProvider personProvider,
    required ServerController serverController,
  }) async {
    if (_isDisposed) {
      return;
    }
    if (_syncCompleter == null) {
      _syncCompleter = Completer();
      final result = await StartupSync.runInIsolate(
        account,
        filesController,
        personsController,
        personProvider,
        serverController,
      );
      if (!_isDisposed && result.isSyncPersonUpdated) {
        onPeopleUpdated?.call();
      }
      _syncCompleter!.complete();
    } else {
      return _syncCompleter!.future;
    }
  }

  Future<void> requestResync({
    required Account account,
    required FilesController filesController,
    required PersonsController personsController,
    required PersonProvider personProvider,
    required ServerController serverController,
  }) async {
    if (_syncCompleter?.isCompleted == true) {
      _syncCompleter = null;
    } else {
      // already syncing
    }
    return requestSync(
      account: account,
      filesController: filesController,
      personsController: personsController,
      personProvider: personProvider,
      serverController: serverController,
    );
  }

  final VoidCallback? onPeopleUpdated;

  Completer<void>? _syncCompleter;
  var _isDisposed = false;
}
