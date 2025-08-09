import 'package:np_api/src/entity/entity.dart';
import 'package:np_api/src/entity/file_parser.dart';
import 'package:test/test.dart';

void main() {
  group("FileParser", () {
    group("parse", () {
      test("file", _files);
      test("file w/ 404 properties", _files404props);
      test("file w/ metadata", _filesMetadata);
      test("file w/ is-archived", _filesIsArchived);
      test("file w/ override-date-time", _filesOverrideDateTime);
      test("multiple files", _filesMultiple);
      test("directory", _filesDir);
      test("nextcloud hosted in subdir", _filesServerHostedInSubdir);
      test("file w/ metadata-photos-ifd0", _filesNc28MetadataIfd0);
      test("file w/ metadata-photos-exif", _filesNc28MetadataExif);
      test("file w/ metadata-photos-gps", _filesNc28MetadataGps);
      test("file w/ metadata-photos-size", _filesNc28MetadataSize);
    });
  });
}

Future<void> _files() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Nextcloud%20intro.mp4</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>video/mp4</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
  ]);
}

Future<void> _files404props() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Nextcloud%20intro.mp4</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>video/mp4</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
		<d:propstat>
			<d:prop>
				<d:quota-used-bytes/>
				<d:quota-available-bytes/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
  ]);
}

Future<void> _filesMetadata() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Photos/Nextcloud%20community.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;8950e39a034e369237d9285e2d815a50&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>797325</d:getcontentlength>
				<nc:has-preview>true</nc:has-preview>
				<x1:metadata xmlns:x1="com.nkming.nc_photos">{&quot;version&quot;:2,&quot;lastUpdated&quot;:&quot;2021-01-02T03:04:05.678Z&quot;,&quot;fileEtag&quot;:&quot;8950e39a034e369237d9285e2d815a50&quot;,&quot;imageWidth&quot;:3000,&quot;imageHeight&quot;:2000}</x1:metadata>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
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
    ),
  ]);
}

Future<void> _filesIsArchived() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Photos/Nextcloud%20community.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;8950e39a034e369237d9285e2d815a50&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
				<d:getcontentlength>797325</d:getcontentlength>
				<nc:has-preview>true</nc:has-preview>
				<x1:is-archived xmlns:x1="com.nkming.nc_photos">true</x1:is-archived>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/remote.php/dav/files/admin/Photos/Nextcloud community.jpg",
      contentLength: 797325,
      contentType: "image/jpeg",
      etag: "8950e39a034e369237d9285e2d815a50",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: true,
      isCollection: false,
      customProperties: {"com.nkming.nc_photos:is-archived": "true"},
    ),
  ]);
}

Future<void> _filesOverrideDateTime() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Photos/Nextcloud%20community.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;8950e39a034e369237d9285e2d815a50&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
				<d:getcontentlength>797325</d:getcontentlength>
				<nc:has-preview>true</nc:has-preview>
				<x1:override-date-time xmlns:x1="com.nkming.nc_photos">2021-01-02T03:04:05.000Z</x1:override-date-time>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
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
    ),
  ]);
}

Future<void> _filesMultiple() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Nextcloud%20intro.mp4</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>video/mp4</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
	<d:response>
		<d:href>/remote.php/dav/files/admin/Nextcloud.png</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Sat, 02 Jan 2021 03:04:05 GMT</d:getlastmodified>
				<d:getetag>&quot;48689d5b17c449d9db492ffe8f7ab8a6&quot;</d:getetag>
				<d:getcontenttype>image/png</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>124</oc:fileid>
				<d:getcontentlength>50598</d:getcontentlength>
				<nc:has-preview>true</nc:has-preview>
				<x1:metadata xmlns:x1="com.nkming.nc_photos">{&quot;version&quot;:2,&quot;lastUpdated&quot;:&quot;2021-01-02T03:04:05.678000Z&quot;,&quot;fileEtag&quot;:&quot;48689d5b17c449d9db492ffe8f7ab8a6&quot;,&quot;imageWidth&quot;:500,&quot;imageHeight&quot;:500}</x1:metadata>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
    File(
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
  ]);
}

Future<void> _filesDir() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/files/admin/Photos/</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;123456789abcd&quot;</d:getetag>
				<d:resourcetype>
					<d:collection/>
				</d:resourcetype>
        <oc:fileid>123</oc:fileid>
        <nc:has-preview>false</nc:has-preview>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
		<d:propstat>
			<d:prop>
				<d:getcontenttype/>
				<d:getcontentlength/>
				<x1:metadata xmlns:x1="com.nkming.nc_photos"/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/remote.php/dav/files/admin/Photos/",
      etag: "123456789abcd",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      isCollection: true,
      hasPreview: false,
      fileId: 123,
    ),
  ]);
}

Future<void> _filesServerHostedInSubdir() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/nextcloud/remote.php/dav/files/admin/Nextcloud%20intro.mp4</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>video/mp4</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/nextcloud/remote.php/dav/files/admin/Nextcloud intro.mp4",
      contentLength: 3963036,
      contentType: "video/mp4",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
    ),
  ]);
}

Future<void> _filesNc28MetadataIfd0() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/nextcloud/remote.php/dav/files/admin/1.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
        <nc:metadata-photos-ifd0>
          <Make>SUPER</Make>
          <Model>Phone 1</Model>
          <Orientation>1</Orientation>
          <XResolution>72/1</XResolution>
          <YResolution>72/1</YResolution>
          <ResolutionUnit>2</ResolutionUnit>
          <Software>1.0</Software>
          <DateTime>2020:01:02 03:04:05</DateTime>
          <YCbCrPositioning>1</YCbCrPositioning>
        </nc:metadata-photos-ifd0>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/nextcloud/remote.php/dav/files/admin/1.jpg",
      contentLength: 3963036,
      contentType: "image/jpeg",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
      metadataPhotosIfd0: {
        "Make": "SUPER",
        "Model": "Phone 1",
        "Orientation": "1",
        "XResolution": "72/1",
        "YResolution": "72/1",
        "ResolutionUnit": "2",
        "Software": "1.0",
        "DateTime": "2020:01:02 03:04:05",
        "YCbCrPositioning": "1",
      },
    ),
  ]);
}

Future<void> _filesNc28MetadataExif() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/nextcloud/remote.php/dav/files/admin/1.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
        <nc:metadata-photos-exif>
          <ExposureTime>1/381</ExposureTime>
          <FNumber>9/5</FNumber>
          <ExposureProgram>2</ExposureProgram>
          <ISOSpeedRatings>20</ISOSpeedRatings>
          <ExifVersion>0231</ExifVersion>
          <DateTimeOriginal>2020:01:02 03:04:05</DateTimeOriginal>
          <DateTimeDigitized>2020:01:02 03:04:05</DateTimeDigitized>
          <UndefinedTag__x____>+01:00</UndefinedTag__x____>
          <ComponentsConfiguration/>
          <ShutterSpeedValue>126682/14777</ShutterSpeedValue>
          <ApertureValue>54823/32325</ApertureValue>
          <BrightnessValue>69659/9080</BrightnessValue>
          <ExposureBiasValue>0/1</ExposureBiasValue>
          <MeteringMode>5</MeteringMode>
          <Flash>16</Flash>
          <FocalLength>4/1</FocalLength>
          <MakerNote>SUPER</MakerNote>
          <ColorSpace>65535</ColorSpace>
          <ExifImageWidth>4032</ExifImageWidth>
          <ExifImageLength>3024</ExifImageLength>
          <SensingMethod>2</SensingMethod>
          <SceneType/>
          <ExposureMode>0</ExposureMode>
          <WhiteBalance>0</WhiteBalance>
          <FocalLengthIn__mmFilm>28</FocalLengthIn__mmFilm>
          <SceneCaptureType>0</SceneCaptureType>
        </nc:metadata-photos-exif>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/nextcloud/remote.php/dav/files/admin/1.jpg",
      contentLength: 3963036,
      contentType: "image/jpeg",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
      metadataPhotosExif: {
        "ExposureTime": "1/381",
        "FNumber": "9/5",
        "ExposureProgram": "2",
        "ISOSpeedRatings": "20",
        "ExifVersion": "0231",
        "DateTimeOriginal": "2020:01:02 03:04:05",
        "DateTimeDigitized": "2020:01:02 03:04:05",
        "UndefinedTag__x____": "+01:00",
        "ComponentsConfiguration": "",
        "ShutterSpeedValue": "126682/14777",
        "ApertureValue": "54823/32325",
        "BrightnessValue": "69659/9080",
        "ExposureBiasValue": "0/1",
        "MeteringMode": "5",
        "Flash": "16",
        "FocalLength": "4/1",
        "MakerNote": "SUPER",
        "ColorSpace": "65535",
        "ExifImageWidth": "4032",
        "ExifImageLength": "3024",
        "SensingMethod": "2",
        "SceneType": "",
        "ExposureMode": "0",
        "WhiteBalance": "0",
        "FocalLengthIn__mmFilm": "28",
        "SceneCaptureType": "0",
      },
    ),
  ]);
}

Future<void> _filesNc28MetadataGps() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/nextcloud/remote.php/dav/files/admin/1.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
        <nc:metadata-photos-gps>
          <latitude>1.23456</latitude>
          <longitude>2.34567</longitude>
          <altitude>3.45678</altitude>
        </nc:metadata-photos-gps>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/nextcloud/remote.php/dav/files/admin/1.jpg",
      contentLength: 3963036,
      contentType: "image/jpeg",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
      metadataPhotosGps: {
        "latitude": "1.23456",
        "longitude": "2.34567",
        "altitude": "3.45678",
      },
    ),
  ]);
}

Future<void> _filesNc28MetadataSize() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/nextcloud/remote.php/dav/files/admin/1.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getlastmodified>Fri, 01 Jan 2021 02:03:04 GMT</d:getlastmodified>
				<d:getetag>&quot;1324f58d4d5c8d81bed6e4ed9d5ea862&quot;</d:getetag>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:resourcetype/>
        <oc:fileid>123</oc:fileid>
				<d:getcontentlength>3963036</d:getcontentlength>
				<nc:has-preview>false</nc:has-preview>
        <nc:metadata-photos-size>
          <width>4032</width>
          <height>3024</height>
        </nc:metadata-photos-size>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await FileParser().parse(xml);
  expect(results, [
    File(
      href: "/nextcloud/remote.php/dav/files/admin/1.jpg",
      contentLength: 3963036,
      contentType: "image/jpeg",
      etag: "1324f58d4d5c8d81bed6e4ed9d5ea862",
      lastModified: DateTime.utc(2021, 1, 1, 2, 3, 4),
      hasPreview: false,
      fileId: 123,
      isCollection: false,
      metadataPhotosSize: {"width": "4032", "height": "3024"},
    ),
  ]);
}
