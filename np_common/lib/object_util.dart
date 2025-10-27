import 'dart:async';

extension ObjectExtension<T> on T {
  /// Run [fn] with this, and return this
  T also(void Function(T obj) fn) {
    fn(this);
    return this;
  }

  /// Run [fn] with this, and return this
  Future<T> alsoFuture(FutureOr<void> Function(T obj) fn) async {
    await fn(this);
    return this;
  }

  /// Run [fn] with this, and return the results of [fn]
  U let<U>(U Function(T obj) fn) => fn(this);

  /// Run [fn] with this, and return the results of [fn]
  Future<U> letFuture<U>(FutureOr<U> Function(T obj) fn) async {
    return await fn(this);
  }

  /// Cast this as U, or null if this is not an object of U
  U? as<U>() => this is U ? this as U : null;

  U cast<U>() => this as U;
}
