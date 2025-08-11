import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:np_collection/np_collection.dart';

Future<void> wait(
  FutureOr<bool> Function() condition, {
  Duration? pollInterval,
}) async {
  while (!await condition()) {
    await Future.delayed(pollInterval ?? const Duration(milliseconds: 500));
  }
}

extension IterableExtension<T> on Iterable<T> {
  Future<List<U>> computeAll<U>(ComputeCallback<T, U> callback) async {
    final list = asList();
    if (list.isEmpty) {
      return [];
    } else {
      return await compute(
        _computeAllImpl<T, U>,
        _ComputeAllMessage(callback, list),
      );
    }
  }
}

class _ComputeAllMessage<T, U> {
  const _ComputeAllMessage(this.callback, this.data);

  final ComputeCallback<T, U> callback;
  final List<T> data;
}

Future<List<U>> _computeAllImpl<T, U>(_ComputeAllMessage<T, U> message) async {
  final result = await Future.wait(
    message.data.map((e) async => await message.callback(e)),
  );
  return result;
}
