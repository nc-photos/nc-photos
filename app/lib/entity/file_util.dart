import 'package:clock/clock.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:np_api/np_api.dart' as api;
import 'package:np_platform_util/np_platform_util.dart';
import 'package:np_string/np_string.dart';
import 'package:path/path.dart' as path_lib;

bool isSupportedMime(String mime) => supportedFormatMimes.contains(mime);

bool isSupportedFormat(FileDescriptor file) =>
    isSupportedMime(file.fdMime ?? "");

bool isSupportedImageMime(String mime) =>
    supportedImageFormatMimes.contains(mime);

bool isSupportedImageFormat(FileDescriptor file) =>
    isSupportedImageMime(file.fdMime ?? "");

bool isSupportedVideoMime(String mime) =>
    supportedVideoFormatMimes.contains(mime);

bool isSupportedVideoFormat(FileDescriptor file) =>
    isSupportedVideoMime(file.fdMime ?? "");

bool isTrash(Account account, FileDescriptor file) =>
    file.fdPath.startsWith(api_util.getTrashbinPath(account));

bool isAlbumFile(Account account, FileDescriptor file) =>
    file.fdPath.startsWith(remote_storage_util.getRemoteAlbumsDir(account));

bool isNcAlbumFile(Account account, FileDescriptor file) =>
    file.fdPath.startsWith("${api.ApiPhotos.path}/");

/// Return if [file] is located under [dir]
///
/// Return false if [file] is [dir] itself (since it's not "under")
///
/// See [isOrUnderDir]
bool isUnderDir(FileDescriptor file, FileDescriptor dir) =>
    file.fdPath.startsWith("${dir.fdPath}/");

bool isUnderDirPath(String filePath, String dirPath) =>
    filePath.startsWith("$dirPath/");

/// Return if [file] is [dir] or located under [dir]
///
/// See [isUnderDir]
bool isOrUnderDir(FileDescriptor file, FileDescriptor dir) =>
    file.fdPath == dir.fdPath || isUnderDir(file, dir);

bool isOrUnderDirPath(String filePath, String dirPath) =>
    filePath == dirPath || isUnderDirPath(filePath, dirPath);

/// Convert a stripped path to a full path
///
/// See [File.strippedPath]
String unstripPath(Account account, String strippedPath) {
  final p = strippedPath == "." ? "" : strippedPath;
  return "${api_util.getWebdavRootUrlRelative(account)}/$p".trimRightAny("/");
}

/// For a path "remote.php/dav/files/foo/bar.jpg", return foo
CiString getUserDirName(File file) => getUserDirNamePath(file.path);

/// For a path "remote.php/dav/files/foo/bar.jpg", return foo
CiString getUserDirNamePath(String filePath) {
  if (filePath.startsWith("remote.php/dav/files/")) {
    const beg = "remote.php/dav/files/".length;
    final end = filePath.indexOf("/", beg);
    if (end != -1) {
      return filePath.substring(beg, end).toCi();
    }
  }
  throw ArgumentError("Invalid path: $filePath");
}

String renameConflict(String filename, int conflictCount) {
  final temp =
      "${path_lib.basenameWithoutExtension(filename)} ($conflictCount)";
  if (path_lib.extension(filename).isEmpty) {
    return temp;
  } else {
    return "$temp${path_lib.extension(filename)}";
  }
}

/// Return if this file is the no media marker
///
/// A no media marker marks the parent dir and its sub dirs as not containing
/// media files of interest
bool isNoMediaMarker(File file) => isNoMediaMarkerPath(file.path);

/// See [isNoMediaMarker]
bool isNoMediaMarkerPath(String path) {
  final filename = path_lib.basename(path);
  return filename == ".nomedia" || filename == ".noimage";
}

/// Return if there's missing metadata in [file]
///
/// Current this function will check both [File.metadata] and [File.location]
bool isMissingMetadata(File file) =>
    isSupportedImageFormat(file) &&
    (file.metadata == null || file.location == null);

DateTime getBestDateTime({
  DateTime? overrideDateTime,
  DateTime? metadataDateTime,
  DateTime? lastModified,
}) =>
    overrideDateTime ?? metadataDateTime ?? lastModified ?? clock.now().toUtc();

final supportedFormatMimes = [
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/heic",
  "image/gif",
  "image/jxl",
  "video/mp4",
  "video/quicktime",
  if ([NpPlatform.android, NpPlatform.web].contains(getRawPlatform()))
    "video/webm",
];

final supportedMetadataFormatMimes = [
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/heic",
  "image/gif",
  "image/jxl",
  // "video/mp4",
  // "video/quicktime",
];

final supportedImageFormatMimes =
    supportedFormatMimes.where((f) => f.startsWith("image/")).toList();

final supportedVideoFormatMimes =
    supportedFormatMimes.where((f) => f.startsWith("video/")).toList();
