import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

mixin BlocLogger {
  String? get tag => null;

  bool Function(dynamic currentState, dynamic nextState)? get shouldLog => null;
}

class BlocListenerT<B extends StateStreamable<S>, S, T>
    extends SingleChildStatelessWidget {
  const BlocListenerT({
    super.key,
    super.child,
    required this.selector,
    required this.listener,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) =>
          selector(previous) != selector(current),
      listener: (context, state) => listener(context, selector(state)),
      child: child,
    );
  }

  final BlocWidgetSelector<S, T> selector;
  final void Function(BuildContext context, T state) listener;
}

/// Wrap around a string such that two strings with the same value will fail
/// the identical check
class StateMessage {
  StateMessage(this.value);

  final String value;
}

extension EmitterExtension<State> on Emitter<State> {
  Future<void> forEachIgnoreError<T>(
    Stream<T> stream, {
    required State Function(T data) onData,
  }) =>
      onEach<T>(
        stream,
        onData: (data) => call(onData(data)),
        onError: (_, __) {},
      );
}

extension BlocExtension<E, S> on Bloc<E, S> {
  void safeAdd(E event) {
    if (!isClosed) {
      add(event);
    }
  }
}

class _BlocForEachObj {
  const _BlocForEachObj(this.subscription, this.completer);

  final StreamSubscription subscription;
  final Completer completer;
}

mixin BlocForEachMixin<E, S> implements Bloc<E, S> {
  @override
  Future<void> close() async {
    for (final e in _forEaches) {
      unawaited(e.subscription.cancel());
      e.completer.complete();
    }
  }

  // The original emit.forEach is causing the internal eventController in Bloc
  // to deadlock when closing, use this instead
  Future<void> forEach<T>(
    Emitter<S> emit,
    Stream<T> stream, {
    required S Function(T data) onData,
    S Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    final completer = Completer();
    final subscription = stream.listen((event) {
      emit(onData(event));
    }, onError: (e, stackTrace) {
      if (onError != null) {
        emit(onError(e, stackTrace));
      }
    });
    _forEaches.add(_BlocForEachObj(subscription, completer));
    return completer.future;
  }

  final _forEaches = <_BlocForEachObj>[];
}

mixin BlocErrorCatcher<E, S> implements Bloc<E, S> {
  @override
  void onError(Object error, StackTrace stackTrace) {
    // we need this to prevent onError being triggered recursively
    if (!isClosed && !_isHandlingError) {
      _isHandlingError = true;
      try {
        handleBlocError(error, stackTrace);
      } catch (_) {}
      _isHandlingError = false;
    }
  }

  @protected
  void handleBlocError(Object error, StackTrace stackTrace) {}

  var _isHandlingError = false;
}
