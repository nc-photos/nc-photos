part of 'viewer.dart';

class _OpenDetailPaneRequest {
  const _OpenDetailPaneRequest(this.shouldAnimate);

  final bool shouldAnimate;
}

class _ShareRequest {
  const _ShareRequest(this.file);

  final FileDescriptor file;
}

class _StartSlideshowRequest {
  const _StartSlideshowRequest({
    required this.fileId,
  });

  final int fileId;
}

class _SlideshowRequest {
  const _SlideshowRequest({
    required this.fileIds,
    required this.startIndex,
    required this.collectionId,
    required this.config,
  });

  final List<int> fileIds;
  final int startIndex;
  final String? collectionId;
  final SlideshowConfig config;
}

class _SetAsRequest {
  const _SetAsRequest({
    required this.account,
    required this.file,
  });

  final Account account;
  final FileDescriptor file;
}
