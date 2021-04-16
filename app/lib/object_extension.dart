import 'package:np_common/object_util.dart';

extension ObjectExtension<T> on T {
  /// Deprecated, use [let]
  U run<U>(U Function(T obj) fn) => let(fn);

  /// Return if this is contained inside [iterable]
  bool isIn(Iterable<T> iterable) => iterable.contains(this);
}
