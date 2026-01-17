import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:np_common/size.dart';

/// Return the URL for a [file] where animated images (e.g., GIF) should play
String getPlayableViewUrlForImageFile(
  Account account,
  FileDescriptor file, {
  required SizeInt size,
  bool isKeepAspectRatio = true,
}) {
  if (file.fdMime == "image/gif") {
    return api_util.getFileUrl(account, file);
  } else if (file.fdMime == "image/jxl") {
    return api_util.getFileUrl(account, file);
  } else {
    return api_util.getFilePreviewUrl(
      account,
      file,
      width: size.width,
      height: size.height,
      isKeepAspectRatio: isKeepAspectRatio,
    );
  }
}

/// Return the URL for a [file] where animated images (e.g., GIF) should play
String getPlayableViewUrlForOriginalImageFile(
  Account account,
  FileDescriptor file, {
  required SizeInt size,
  bool isKeepAspectRatio = true,
}) {
  if (file.fdMime == "image/heic") {
    // HEIC not supported by the Image widget
    return api_util.getFilePreviewUrl(
      account,
      file,
      width: size.width,
      height: size.height,
      isKeepAspectRatio: isKeepAspectRatio,
    );
  } else {
    return api_util.getFileUrl(account, file);
  }
}

/// Return the URL for a [file] where animated images (e.g., GIF) will not play
String getStaticViewUrlForImageFile(
  Account account,
  FileDescriptor file, {
  required SizeInt size,
  bool isKeepAspectRatio = true,
}) {
  if (file.fdMime == "image/jxl") {
    return api_util.getFileUrl(account, file);
  } else {
    return api_util.getFilePreviewUrl(
      account,
      file,
      width: size.width,
      height: size.height,
      isKeepAspectRatio: isKeepAspectRatio,
    );
  }
}

String getViewerUrlForImageFile(Account account, FileDescriptor file) {
  return getPlayableViewUrlForImageFile(
    account,
    file,
    size: SizeInt.square(k.photoLargeSize),
  );
}

String getViewerUrlForOriginalImageFile(Account account, FileDescriptor file) {
  return getPlayableViewUrlForOriginalImageFile(
    account,
    file,
    size: SizeInt.square(k.photoLargeSize),
  );
}

String getThumbnailUrlForImageFile(Account account, FileDescriptor file) {
  return getStaticViewUrlForImageFile(
    account,
    file,
    size: SizeInt.square(k.photoThumbSize),
  );
}
