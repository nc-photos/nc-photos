abstract class Download {
  /// Download a file
  ///
  /// The return data depends on the platform
  /// - web: null
  /// - android: Uri to the downloaded file
  Future call();

  /// Cancel a download
  ///
  /// Not all platforms support canceling an ongoing download. Return true if
  /// the current platform supports it, however there's no guarantee if and when
  /// the download task would be canceled. After a download is canceled
  /// successfully, [JobCanceledException] will be thrown in [call]
  bool cancel();
}

abstract class DownloadBuilder {
  /// Create a platform specific download
  ///
  /// [parentDir] is a hint that set the parent directory where the files are
  /// saved. Whether this is supported or not is implementation specific
  ///
  /// [shouldNotify] is a hint that suggest whether to notify user about the
  /// progress. The actual decision is made by the underlying platform code and
  /// is not guaranteed to respect this flag
  Download build({
    required String url,
    Map<String, String>? headers,
    String? mimeType,
    required String filename,
    String? parentDir,
    required bool isPublic,
    bool? shouldNotify,
  });
}
