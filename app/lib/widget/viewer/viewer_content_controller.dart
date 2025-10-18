part of 'viewer.dart';

@npLog
class _ViewerContentController {
  _ViewerContentController({
    required this.contentProvider,
    required this.initialFile,
  }) {
    _pageContentMap[0] = initialFile;
  }

  Future<Map<int, AnyFile>> getForwardContent() async {
    try {
      _isQueryingForward = true;
      final from = _pageContentMap.entries.last.let(
        (e) => ViewerPositionInfo(pageIndex: e.key, originalFile: e.value),
      );
      final results = await contentProvider.getFiles(from, _fileCountPerQuery);
      final resultMap =
          results.files
              .mapIndexed((i, e) => MapEntry(from.pageIndex + 1 + i, e))
              .toMap();
      _log.info("[_getForwardContent] Result: $results");
      _pageContentMap.addAll(resultMap);
      return resultMap;
    } catch (e, stackTrace) {
      _log.severe("[_getForwardContent] Failed while getFiles", e, stackTrace);
      return const {};
    } finally {
      _isQueryingForward = false;
    }
  }

  Future<Map<int, AnyFile>> getBackwardContent() async {
    try {
      _isQueryingBackward = true;
      final from = _pageContentMap.entries.first.let(
        (e) => ViewerPositionInfo(pageIndex: e.key, originalFile: e.value),
      );
      final results = await contentProvider.getFiles(from, -_fileCountPerQuery);
      final resultMap =
          results.files
              .mapIndexed((i, e) => MapEntry(from.pageIndex - 1 - i, e))
              .toMap();
      _log.info("[_getBackwardContent] Result: $results");
      _pageContentMap.addAll(resultMap);
      return resultMap;
    } catch (e, stackTrace) {
      _log.severe("[_getBackwardContent] Failed while getFiles", e, stackTrace);
      return const {};
    } finally {
      _isQueryingBackward = false;
    }
  }

  bool needQueryForward(int page) {
    if (page > _pageContentMap.keys.last) {
      if (!_isQueryingForward) {
        return true;
      }
    }
    return false;
  }

  bool needQueryBackward(int page) {
    if (page < _pageContentMap.keys.first) {
      if (!_isQueryingBackward) {
        return true;
      }
    }
    return false;
  }

  void notifyFileRemoved(int page, String afId) {
    _log.info("[notifyFileRemoved] page: $page, afId: $afId");
    if (!_pageContentMap.containsKey(page)) {
      _log.severe("[notifyFileRemoved] Page not found: $page");
      return;
    }
    final current = _pageContentMap[page]!;
    if (current.id != afId) {
      _log.warning(
        "[notifyFileRemoved] Removed file does not match record, page: $page, expected: ${current.id}, actual: $afId",
      );
    }
    contentProvider.notifyFileRemoved(page, current);

    final nextMap = SplayTreeMap<int, AnyFile>();
    for (final e in _pageContentMap.entries) {
      if (e.key < page) {
        nextMap[e.key] = e.value;
      } else if (e.key > page) {
        nextMap[e.key - 1] = e.value;
      }
    }
    _pageContentMap = nextMap;
  }

  Future<void> fastJump({required int page, required String afId}) async {
    // make this class smarter to handle this without clearing cache
    if (page > _pageContentMap.keys.last || page < _pageContentMap.keys.first) {
      _log.fine(
        "[fastJump] Out of range, resetting map: $page, [${_pageContentMap.keys.first}, ${_pageContentMap.keys.last}]",
      );
      _pageContentMap.clear();
      _pageContentMap.addAll({page: await contentProvider.getFile(page, afId)});
    }
  }

  int get firstKnownPage => _pageContentMap.keys.first;

  int get lastKnownPage => _pageContentMap.keys.last;

  final ViewerContentProvider contentProvider;
  final AnyFile initialFile;

  var _pageContentMap = SplayTreeMap<int, AnyFile>();
  var _isQueryingForward = false;
  var _isQueryingBackward = false;
}

const _fileCountPerQuery = 60;
