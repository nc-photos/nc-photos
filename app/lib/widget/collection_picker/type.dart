part of 'collection_picker.dart';

@npLog
class _Item {
  const _Item._({
    required this.collection,
    required this.coverUrl,
    required this.coverMime,
  });

  factory _Item.fromCollection(Collection collection) {
    try {
      final result = collection.getCoverUrl(k.coverSize, k.coverSize);
      return _Item._(
        collection: collection,
        coverUrl: result?.url,
        coverMime: result?.mime,
      );
    } catch (e, stackTrace) {
      _$_ItemNpLog.log.warning(
        "[fromCollection] Failed while getCoverUrl",
        e,
        stackTrace,
      );
      return _Item._(collection: collection, coverUrl: null, coverMime: null);
    }
  }

  String get name => collection.name;

  final Collection collection;
  final String? coverUrl;
  final String? coverMime;
}
