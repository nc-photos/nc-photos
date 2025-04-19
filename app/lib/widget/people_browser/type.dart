part of '../people_browser.dart';

@npLog
class _Item {
  const _Item._({
    required this.person,
    required this.coverUrl,
    required this.coverMime,
  });

  factory _Item.fromPerson(Person person) {
    try {
      final result = person.getCoverUrl(
        k.photoLargeSize,
        k.photoLargeSize,
        isKeepAspectRatio: true,
      );
      return _Item._(
        person: person,
        coverUrl: result?.url,
        coverMime: result?.mime,
      );
    } catch (e, stackTrace) {
      _$_ItemNpLog.log
          .warning("[fromPerson] Failed while getCoverUrl", e, stackTrace);
      return _Item._(
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
