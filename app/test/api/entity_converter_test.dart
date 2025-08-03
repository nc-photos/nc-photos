import 'package:nc_photos/api/entity_converter.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:np_api/np_api.dart' as api;
import 'package:test/test.dart';

void main() {
  group("ApiFileConverter", () {
    group("fromApi", () {
      test("file", _files);
      test("file w/ metadata", _filesMetadata);
      test("file w/ is-archived", _filesIsArchived);
      test("file w/ override-date-time", _filesOverrideDateTime);
      test("multiple files", _filesMultiple);
      test("directory", _filesDir);
      test("nextcloud hosted in subdir", _filesServerHostedInSubdir);
    });
  });
  group("ApiRecognizeFaceItemConverter", () {
    group("fromApi", () {
      test("minimum", _recognizeFaceItemMinimum);
      test("size", _recognizeFaceItemSize);
    });
  });
}

Future<void> _files() async {
  final apiFile = api.File(
    href: "/remote.php/dav/files/admin/Nextcloud intro.mp4",
    contentLength: 3963036,
    contentType: "video/mp4",
    etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
    lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
    hasPreview: false,
    fileId: 123,
    isCollection: false,
  );
  expect(
    ApiFileConverter.fromApi(apiFile),
    File(
      path: "remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
  );
}

Future<void> _filesMetadata() async {
  final apiFile = api.File(
    href: "/remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
    contentLength: 797325,
    contentType: "image/jpeg",
    etag: "8950e39a034e369237d9285e2d815a50",
    lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
    hasPreview: true,
    fileId: 123,
    isCollection: false,
    customProperties: {
      "com.nkming.nc_photos:metadata":
          "{\"version\":2,\"lastUpdated\":\"2021-01-02T03:04:05.678Z\",\"fileEtag\":\"8950e39a034e369237d9285e2d815a50\",\"imageWidth\":3000,\"imageHeight\":2000}",
    },
  );
  expect(
    ApiFileConverter.fromApi(apiFile),
    File(
      path: "remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
      contentLength: 797325,
      contentType: "image/jpeg",
      etag: "8950e39a034e369237d9285e2d815a50",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: true,
      fileId: 123,
      isCollection: false,
      metadata: Metadata(
        lastUpdated: DateTime.utc(2021, 1, 2, 3, 4, 5, 678),
        fileEtag: "8950e39a034e369237d9285e2d815a50",
        imageWidth: 3000,
        imageHeight: 2000,
        src: MetadataSrc.legacy,
      ),
    ),
  );
}

Future<void> _filesIsArchived() async {
  final apiFile = api.File(
    href: "/remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
    contentLength: 797325,
    contentType: "image/jpeg",
    etag: "8950e39a034e369237d9285e2d815a50",
    lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
    hasPreview: true,
    isCollection: false,
    customProperties: {
      "com.nkming.nc_photos:is-archived": "true",
    },
  );
  expect(
    ApiFileConverter.fromApi(apiFile),
    File(
      path: "remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
      contentLength: 797325,
      contentType: "image/jpeg",
      etag: "8950e39a034e369237d9285e2d815a50",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: true,
      isCollection: false,
      isArchived: true,
    ),
  );
}

Future<void> _filesOverrideDateTime() async {
  final apiFile = api.File(
    href: "/remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
    contentLength: 797325,
    contentType: "image/jpeg",
    etag: "8950e39a034e369237d9285e2d815a50",
    lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
    hasPreview: true,
    isCollection: false,
    customProperties: {
      "com.nkming.nc_photos:override-date-time": "2021-01-02T03:04:05.000Z",
    },
  );
  expect(
    ApiFileConverter.fromApi(apiFile),
    File(
      path: "remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
      contentLength: 797325,
      contentType: "image/jpeg",
      etag: "8950e39a034e369237d9285e2d815a50",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: true,
      isCollection: false,
      overrideDateTime: DateTime.utc(2021, 1, 2, 3, 4, 5),
    ),
  );
}

Future<void> _filesMultiple() async {
  final apiFiles = [
    api.File(
      href: "/remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
    api.File(
      href: "/remote.php/dav/files/admin/Nextcloud.png",
      contentLength: 50598,
      contentType: "image/png",
      etag: "48689d5b17c449d9db492ffe8f7ab8a6",
      lastModified: DateTime.utc(2021, 1, 2, 3, 4, 5),
      hasPreview: true,
      fileId: 124,
      isCollection: false,
      customProperties: {
        "com.nkming.nc_photos:metadata":
            "{\"version\":2,\"lastUpdated\":\"2021-01-02T03:04:05.678000Z\",\"fileEtag\":\"48689d5b17c449d9db492ffe8f7ab8a6\",\"imageWidth\":500,\"imageHeight\":500}",
      },
    ),
  ];
  expect(
    apiFiles.map(ApiFileConverter.fromApi).toList(),
    [
      File(
        path: "remote.php/dav/files/admin/Nextcloud intro.mp4",
        contentLength: 3963036,
        contentType: "video/mp4",
        etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
        lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
        hasPreview: false,
        fileId: 123,
        isCollection: false,
      ),
      File(
        path: "remote.php/dav/files/admin/Nextcloud.png",
        contentLength: 50598,
        contentType: "image/png",
        etag: "48689d5b17c449d9db492ffe8f7ab8a6",
        lastModified: DateTime.utc(2021, 1, 2, 3, 4, 5),
        hasPreview: true,
        fileId: 124,
        isCollection: false,
        metadata: Metadata(
          fileEtag: "48689d5b17c449d9db492ffe8f7ab8a6",
          imageWidth: 500,
          imageHeight: 500,
          lastUpdated: DateTime.utc(2021, 1, 2, 3, 4, 5, 678),
          src: MetadataSrc.legacy,
        ),
      ),
    ],
  );
}

Future<void> _filesDir() async {
  final apiFile = api.File(
    href: "/remote.php/dav/files/admin/Photos/",
    etag: "123456789abcd",
    lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
    isCollection: true,
    hasPreview: false,
    fileId: 123,
  );
  expect(
    ApiFileConverter.fromApi(apiFile),
    File(
      path: "remote.php/dav/files/admin/Photos",
      etag: "123456789abcd",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      isCollection: true,
      hasPreview: false,
      fileId: 123,
    ),
  );
}

Future<void> _filesServerHostedInSubdir() async {
  final apiFile = api.File(
    href: "/nextcloud/remote.php/dav/files/admin/Nextcloud intro.mp4",
    contentLength: 3963036,
    contentType: "video/mp4",
    etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
    lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
    hasPreview: false,
    fileId: 123,
    isCollection: false,
  );
  expect(
    ApiFileConverter.fromApi(apiFile),
    File(
      path: "remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
  );
}

void _recognizeFaceItemMinimum() {
  const apiItem = api.RecognizeFaceItem(
    href: "/remote.php/dav/recognize/admin/faces/test/test1.jpg",
    fileId: 123,
  );
  expect(
    ApiRecognizeFaceItemConverter.fromApi(apiItem),
    const RecognizeFaceItem(
      path: "remote.php/dav/recognize/admin/faces/test/test1.jpg",
      fileId: 123,
    ),
  );
}

void _recognizeFaceItemSize() {
  const apiItem = api.RecognizeFaceItem(
    href: "/remote.php/dav/recognize/admin/faces/test/test1.jpg",
    fileId: 123,
    fileMetadataSize: {
      "width": 1024,
      "height": 768,
    },
  );
  expect(
    ApiRecognizeFaceItemConverter.fromApi(apiItem),
    const RecognizeFaceItem(
      path: "remote.php/dav/recognize/admin/faces/test/test1.jpg",
      fileId: 123,
      fileMetadataWidth: 1024,
      fileMetadataHeight: 768,
    ),
  );
}
