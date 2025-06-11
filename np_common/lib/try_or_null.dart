import 'dart:async';

T? tryOrNull<T>(T Function() fn) {
  try {
    return fn();
  } catch (_) {
    return null;
  }
}

Future<T?> tryOrNullF<T>(Future<T> Function() fn) async {
  try {
    return await fn();
  } catch (_) {
    return null;
  }
}

Future<T?> tryOrNullFN<T>(Future<T?> Function() fn) => tryOrNullF<T?>(fn);
