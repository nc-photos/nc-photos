part of '../share_collection_dialog.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.collection,
    required this.processingShares,
    this.sharees,
    this.shareeSuggester,
    this.error,
  });

  factory _State.init({required Collection collection}) {
    return _State(collection: collection, processingShares: const []);
  }

  @override
  String toString() => _$toString();

  final Collection collection;
  final List<CollectionShare> processingShares;

  final List<Sharee>? sharees;
  final Suggester<Sharee>? shareeSuggester;

  final ExceptionEvent? error;
}

abstract class _Event {
  const _Event();
}

@toString
class _UpdateCollection implements _Event {
  const _UpdateCollection(this.collection);

  @override
  String toString() => _$toString();

  final Collection collection;
}

@toString
class _LoadSharee implements _Event {
  const _LoadSharee();

  @override
  String toString() => _$toString();
}

@toString
class _RefreshSuggester implements _Event {
  const _RefreshSuggester();

  @override
  String toString() => _$toString();
}

mixin _ShareEventTag implements _Event {}

@toString
class _Share with _ShareEventTag implements _Event {
  const _Share(this.sharee);

  @override
  String toString() => _$toString();

  final Sharee sharee;
}

@toString
class _Unshare with _ShareEventTag implements _Event {
  const _Unshare(this.share);

  @override
  String toString() => _$toString();

  final CollectionShare share;
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}
