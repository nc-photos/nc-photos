import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';

mixin AnyFileWorkerNoFavoriteTag implements AnyFileFavoriteWorker {
  @override
  Future<void> favorite() {
    throw UnsupportedError("Operation not supported");
  }

  @override
  Future<void> unfavorite() {
    throw UnsupportedError("Operation not supported");
  }
}

mixin AnyFileWorkerNoArchiveTag implements AnyFileArchiveWorker {
  @override
  Future<void> archive() {
    throw UnsupportedError("Operation not supported");
  }

  @override
  Future<void> unarchive() {
    throw UnsupportedError("Operation not supported");
  }
}

mixin AnyFileWorkerNoDownloadTag implements AnyFileDownloadWorker {
  @override
  Future<void> download() {
    throw UnsupportedError("Operation not supported");
  }
}

mixin AnyFileWorkerNoDeleteTag implements AnyFileDeleteWorker {
  @override
  Future<bool> delete() {
    throw UnsupportedError("Operation not supported");
  }
}

mixin AnyFileWorkerNoUploadTag implements AnyFileUploadWorker {
  @override
  void upload(String relativePath, {ConvertConfig? convertConfig}) {
    throw UnsupportedError("Operation not supported");
  }
}
