import 'package:np_api/np_api.dart' as api;

class CacheNotFoundException implements Exception {
  const CacheNotFoundException([this.message]);

  @override
  toString() {
    if (message == null) {
      return "CacheNotFoundException";
    } else {
      return "CacheNotFoundException: $message";
    }
  }

  final dynamic message;
}

class ApiException implements Exception {
  ApiException({required this.response, this.message});

  @override
  toString() {
    if (message == null) {
      return "ApiException";
    } else {
      return "ApiException: $message";
    }
  }

  final api.Response response;
  final dynamic message;
}

/// The Nextcloud base URL address is invalid
class InvalidBaseUrlException implements Exception {
  InvalidBaseUrlException([this.message]);

  @override
  toString() {
    if (message == null) {
      return "InvalidBaseUrlException";
    } else {
      return "InvalidBaseUrlException: $message";
    }
  }

  final dynamic message;
}

/// A download job has failed
class DownloadException implements Exception {
  DownloadException([this.message]);

  @override
  toString() {
    return "DownloadException: $message";
  }

  final dynamic message;
}

/// A running job has been canceled
class JobCanceledException implements Exception {
  const JobCanceledException([this.message]);

  @override
  String toString() {
    return "JobCanceledException: $message";
  }

  final dynamic message;
}

/// Trying to downgrade an Album
class AlbumDowngradeException implements Exception {
  const AlbumDowngradeException([this.message]);

  @override
  toString() {
    return "AlbumDowngradeException: $message";
  }

  final dynamic message;
}

class InterruptedException implements Exception {
  const InterruptedException([this.message]);

  @override
  toString() => "InterruptedException: $message";

  final dynamic message;
}

class AlbumItemPermissionException implements Exception {
  const AlbumItemPermissionException([this.message]);

  @override
  toString() => "AlbumItemPermissionException: $message";

  final dynamic message;
}

class CollectionPartialShareException implements Exception {
  const CollectionPartialShareException(this.shareeName, [this.message]);

  @override
  String toString() {
    if (message == null) {
      return "CollectionPartialShareException";
    } else {
      return "CollectionPartialShareException: $message";
    }
  }

  final String shareeName;
  final dynamic message;
}

class CollectionPartialUnshareException implements Exception {
  const CollectionPartialUnshareException(this.shareeName, [this.message]);

  @override
  String toString() {
    if (message == null) {
      return "CollectionPartialUnshareException";
    } else {
      return "CollectionPartialUnshareException: $message";
    }
  }

  final String shareeName;
  final dynamic message;
}
