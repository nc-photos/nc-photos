part of '../search_landing.dart';

@npLog
class _PersonItem {
  const _PersonItem._({
    required this.person,
    required this.coverUrl,
    required this.coverMime,
  });

  factory _PersonItem.fromPerson(Person person) {
    try {
      final result = person.getCoverUrl(
        k.photoLargeSize,
        k.photoLargeSize,
        isKeepAspectRatio: true,
      );
      return _PersonItem._(
        person: person,
        coverUrl: result?.url,
        coverMime: result?.mime,
      );
    } catch (e, stackTrace) {
      _$_PersonItemNpLog.log
          .warning("[fromPerson] Failed while getCoverUrl", e, stackTrace);
      return _PersonItem._(
        person: person,
        coverUrl: null,
        coverMime: null,
      );
    }
  }

  String get name => person.name;

  final Person person;
  final String? coverUrl;
  final String? coverMime;
}

@npLog
class _PlaceItem {
  _PlaceItem({
    required Account account,
    required this.place,
  }) {
    try {
      _coverUrl = getThumbnailUrlForImageFile(
        account,
        FileDescriptor(
          fdPath: file_util.unstripPath(account, place.latestFileRelativePath),
          fdId: place.latestFileId,
          fdMime: place.latestFileMime,
          fdIsArchived: false,
          fdIsFavorite: false,
          fdDateTime: place.latestDateTime,
        ),
      );
    } catch (e, stackTrace) {
      _log.warning("[_PlaceItem] Failed while getThumbnailUrlForImageFile", e,
          stackTrace);
    }
  }

  String get name => place.place;
  String? get coverUrl => _coverUrl;
  String? get coverMime => place.latestFileMime;

  final LocationGroup place;

  String? _coverUrl;
}
