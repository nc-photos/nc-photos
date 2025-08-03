import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/exception_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:np_log/np_log.dart';

part 'snack_bar_manager.g.dart';

/// Showing snack bars
///
/// This manager helps showing a snack bar even after the context was
/// invalidated by having another widget (presumably top-level) to handle such
/// request in a decoupled way
@npLog
class SnackBarManager {
  factory SnackBarManager() => _inst;

  @visibleForTesting
  SnackBarManager.scoped();

  void registerHandler(SnackBarHandler handler) {
    _handlers.add(handler);
  }

  void unregisterHandler(SnackBarHandler handler) {
    _handlers.remove(handler);
  }

  /// Queue a snack bar to be shown ASAP
  ///
  /// If the snack bar can't be shown, return null.
  ///
  /// If [canBeReplaced] is true, this snackbar will be dismissed by the next
  /// snack bar
  void showSnackBar(
    SnackBar snackBar, {
    bool canBeReplaced = false,
  }) {
    _add(_Item(snackBar, canBeReplaced));
    _ensureRunning();
  }

  void showSnackBarForException(Object? exception) {
    final (text, action) = exceptionToSnackBarData(exception);
    showSnackBar(SnackBar(
      content: Text(text),
      action: action,
      duration: k.snackBarDurationNormal,
    ));
  }

  void _ensureRunning() {
    if (!_isRunning) {
      _isRunning = true;
      _next();
    }
  }

  void _add(_Item item) {
    _queue.add(item);
    if (_currentItem?.canBeReplaced == true) {
      _currentItem!.controller?.close();
    }
  }

  Future<void> _next() async {
    if (_queue.isEmpty) {
      _isRunning = false;
      return;
    }
    final item = _queue.removeFirst();
    if (item.canBeReplaced && _queue.isNotEmpty) {
      _log.info("[_next] Skip replaceable snack bar");
      return _next();
    }
    // show item
    for (final h in _handlers.reversed) {
      final controller = h.showSnackBar(item.snackBar);
      if (controller != null) {
        item.controller = controller;
        _currentItem = item;
        try {
          final reason = await controller.closed;
          _log.fine("[_next] Snack bar closed: ${reason.name}");
        } finally {
          _currentItem = null;
        }
        return _next();
      }
    }
    _log.warning("[_next] No handler available");
    return _next();
  }

  final _handlers = <SnackBarHandler>[];
  final Queue<_Item> _queue = DoubleLinkedQueue();
  var _isRunning = false;
  _Item? _currentItem;

  static final _inst = SnackBarManager.scoped();
}

abstract class SnackBarHandler {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
      SnackBar snackBar);
}

class _Item {
  _Item(this.snackBar, this.canBeReplaced);

  final SnackBar snackBar;
  final bool canBeReplaced;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? controller;
}
