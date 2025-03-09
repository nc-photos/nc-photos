part of 'viewer.dart';

@npLog
class _ViewerContentController {
  _ViewerContentController({
    required this.contentProvider,
    required this.allFilesCount,
    required this.initialFile,
    required this.initialIndex,
  }) {
    _pageContentMap[initialIndex] = initialFile;
  }

  Future<Map<int, FileDescriptor>> getForwardContent() async {
    try {
      _isQueryingForward = true;
      final from = _pageContentMap.entries.last.let(
          (e) => ViewerPositionInfo(pageIndex: e.key, originalFile: e.value));
      if (from.pageIndex >= allFilesCount - 1) {
        _log.severe(
            "[_getForwardContent] Trying to query beyond max count, contentEnd: ${from.pageIndex}, max: $allFilesCount");
        return const {};
      }
      final results = await contentProvider.getFiles(from, _fileCountPerQuery);
      final resultMap = results.files
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

  Future<Map<int, FileDescriptor>> getBackwardContent() async {
    try {
      _isQueryingBackward = true;
      final from = _pageContentMap.entries.first.let(
          (e) => ViewerPositionInfo(pageIndex: e.key, originalFile: e.value));
      final count = min(from.pageIndex, _fileCountPerQuery);
      if (count == 0) {
        _log.severe(
            "[_getBackwardContent] Trying to query beyond max count, contentBegin: ${from.pageIndex}");
        return const {};
      }
      final results = await contentProvider.getFiles(from, -count);
      final resultMap = results.files
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
    if (page > _pageContentMap.keys.last && page < allFilesCount) {
      if (!_isQueryingForward) {
        return true;
      }
    }
    return false;
  }

  bool needQueryBackward(int page) {
    if (page < _pageContentMap.keys.first && page >= 0) {
      if (!_isQueryingBackward) {
        return true;
      }
    }
    return false;
  }

  void notifyFileRemoved(int page, int fileId) {
    _log.info("[notifyFileRemoved] page: $page, fileId: $fileId");
    if (!_pageContentMap.containsKey(page)) {
      _log.severe("[notifyFileRemoved] Page not found: $page");
      return;
    }
    final current = _pageContentMap[page]!;
    if (current.fdId != fileId) {
      _log.warning(
          "[notifyFileRemoved] Removed file does not match record, page: $page, expected: ${current.fdId}, actual: $fileId");
    }
    contentProvider.notifyFileRemoved(page, current);

    final nextMap = SplayTreeMap<int, FileDescriptor>();
    for (final e in _pageContentMap.entries) {
      if (e.key < page) {
        nextMap[e.key] = e.value;
      } else if (e.key > page) {
        nextMap[e.key - 1] = e.value;
      }
    }
    _pageContentMap = nextMap;
  }

  Future<void> fastJump({
    required int page,
    required int fileId,
  }) async {
    // make this class smarter to handle this without clearing cache
    if (page > _pageContentMap.keys.last || page < _pageContentMap.keys.first) {
      _log.fine(
          "[fastJump] Out of range, resetting map: $page, [${_pageContentMap.keys.first}, ${_pageContentMap.keys.last}]");
      _pageContentMap.clear();
      _pageContentMap.addAll({
        page: await contentProvider.getFile(page, fileId),
      });
    }
  }

  final ViewerContentProvider contentProvider;
  final int allFilesCount;
  final FileDescriptor initialFile;
  final int initialIndex;

  var _pageContentMap = SplayTreeMap<int, FileDescriptor>();
  var _isQueryingForward = false;
  var _isQueryingBackward = false;
}

const _fileCountPerQuery = 30;
