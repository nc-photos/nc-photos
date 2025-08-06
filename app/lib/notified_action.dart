import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';

class NotifiedListAction<T> {
  NotifiedListAction({
    required this.list,
    required this.action,
    this.processingText,
    required this.successText,
    this.getFailureText,
    this.onActionError,
  });

  /// Perform the action and return the success count
  Future<int> call() async {
    if (processingText != null) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(processingText!),
          duration: k.snackBarDurationShort,
        ),
        canBeReplaced: true,
      );
    }
    final failedItems = <T>[];
    for (final item in list) {
      try {
        await action(item);
      } catch (e, stackTrace) {
        onActionError?.call(item, e, stackTrace);
        failedItems.add(item);
      }
    }
    if (failedItems.isEmpty) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(successText),
          duration: k.snackBarDurationNormal,
        ),
      );
    } else {
      final failureText = getFailureText?.call(failedItems);
      if (failureText?.isNotEmpty == true) {
        SnackBarManager().showSnackBar(
          SnackBar(
            content: Text(failureText!),
            duration: k.snackBarDurationNormal,
          ),
        );
      }
    }
    return list.length - failedItems.length;
  }

  final List<T> list;

  /// Action to be applied to every items in [list]
  final FutureOr<void> Function(T item) action;

  /// Message to be shown before performing [action]
  final String? processingText;

  /// Message to be shown after [action] finished for each elements in [list]
  /// without throwing
  final String successText;

  /// Message to be shown if one or more [action] threw
  final String Function(List<T> failedItems)? getFailureText;

  /// Called when [action] threw when processing [item]
  final void Function(T item, Object e, StackTrace stackTrace)? onActionError;
}
