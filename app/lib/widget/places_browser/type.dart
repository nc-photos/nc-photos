part of '../places_browser.dart';

@npLog
class _Item {
  _Item({required Account account, required this.place}) {
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
      _log.warning(
        "[_Item] Failed while getThumbnailUrlForImageFile",
        e,
        stackTrace,
      );
    }
  }

  String get name => place.place;
  String? get coverUrl => _coverUrl;
  String? get coverMime => place.latestFileMime;

  final LocationGroup place;

  String? _coverUrl;
}
