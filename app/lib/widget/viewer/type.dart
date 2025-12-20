part of 'viewer.dart';

class _OpenDetailPaneRequest {
  const _OpenDetailPaneRequest(this.shouldAnimate);

  final bool shouldAnimate;
}

class _ShareRequest {
  const _ShareRequest(this.file);

  final AnyFile file;
}

class _StartSlideshowRequest {
  const _StartSlideshowRequest({required this.afId, required this.fromPage});

  final String afId;
  final int fromPage;
}

class _SlideshowRequest {
  const _SlideshowRequest({
    required this.afIds,
    required this.startIndex,
    required this.collectionId,
    required this.config,
    required this.fromPage,
  });

  final List<String> afIds;
  final int startIndex;
  final String? collectionId;
  final SlideshowConfig config;
  final int fromPage;
}

class _SetAsRequest {
  const _SetAsRequest({required this.account, required this.file});

  final Account account;
  final AnyFile file;
}

class _UploadRequest {
  const _UploadRequest({required this.account, required this.file});

  final Account account;
  final AnyFile file;
}

class _DeleteRequest {
  const _DeleteRequest({required this.account, required this.file});

  final Account account;
  final AnyFile file;
}
