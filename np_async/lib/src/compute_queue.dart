import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef ComputeQueueCallback<U> = void Function(U result);

/// Compute the jobs in the queue one by one sequentially in isolate
class ComputeQueue<T, U> {
  void addJob(
    T event,
    ComputeCallback<T, U> callback,
    ComputeQueueCallback<U> onResult, {
    VoidCallback? onBeforeCompute,
  }) {
    _queue.addLast(_Job(event, callback, onResult, onBeforeCompute));
    if (_queue.length == 1) {
      _startProcessing();
    }
  }

  bool get isProcessing => _queue.isNotEmpty;

  Future<void> _startProcessing() async {
    while (_queue.isNotEmpty) {
      final ev = _queue.first;
      final U result;
      try {
        ev.onBeforeCompute?.call();
        result = await compute(ev.callback, ev.message);
      } finally {
        _queue.removeFirst();
      }
      ev.onResult(result);
    }
  }

  final _queue = Queue<_Job<T, U>>();
}

class _Job<T, U> {
  const _Job(this.message, this.callback, this.onResult, this.onBeforeCompute);

  final T message;
  final ComputeCallback<T, U> callback;
  final ComputeQueueCallback<U> onResult;
  final VoidCallback? onBeforeCompute;
}
