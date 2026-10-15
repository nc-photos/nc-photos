import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';

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

// Queue with a fixed size of 1. Old elements are dropped when new one is added
class SingleComputeQueue<T, U> {
  void addJob(
    T event,
    ComputeCallback<T, U> callback,
    ComputeQueueCallback<U> onResult, {
    VoidCallback? onBeforeCompute,
  }) {
    _mutex.protect(() async {
      _pendingJob = _Job(event, callback, onResult, onBeforeCompute);
      if (!_isProcessing) {
        unawaited(_startProcessing());
      }
    });
  }

  bool get isProcessing => _isProcessing;

  Future<void> _startProcessing() async {
    _isProcessing = true;
    try {
      while (_pendingJob != null) {
        _Job<T, U>? job;
        await _mutex.protect(() async {
          job = _pendingJob;
          _pendingJob = null;
        });
        if (job == null) {
          return;
        }
        final U result;
        job!.onBeforeCompute?.call();
        result = await compute(job!.callback, job!.message);
        job!.onResult(result);
      }
    } finally {
      _isProcessing = false;
    }
  }

  _Job<T, U>? _pendingJob;
  var _isProcessing = false;
  final _mutex = Mutex();
}

class _Job<T, U> {
  const _Job(this.message, this.callback, this.onResult, this.onBeforeCompute);

  final T message;
  final ComputeCallback<T, U> callback;
  final ComputeQueueCallback<U> onResult;
  final VoidCallback? onBeforeCompute;
}
