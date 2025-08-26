import 'package:np_api/np_api.dart';
import 'package:test/test.dart';

void main() {
  group("RecognizeFaceItemParser", () {
    group("parse", () {
      test("empty", _empty);
      test("image", _image);
      test("imageWithSize", _imageWithSize);
    });
  });
}

Future<void> _empty() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/recognize/admin/faces/test/</d:href>
		<d:propstat>
			<d:prop>
				<d:resourcetype>
					<d:collection/>
				</d:resourcetype>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
		<d:propstat>
			<d:prop>
				<d:getcontentlength/>
				<d:getcontenttype/>
				<d:getetag/>
				<d:getlastmodified/>
				<nc:face-detections/>
				<nc:file-metadata-size/>
				<nc:has-preview/>
				<nc:realpath/>
				<oc:favorite/>
				<oc:fileid/>
				<oc:permissions/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await RecognizeFaceItemParser().parse(xml);
  expect(results, const [
    RecognizeFaceItem(href: "/remote.php/dav/recognize/admin/faces/test/"),
  ]);
}

Future<void> _image() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/recognize/admin/faces/test/</d:href>
		<d:propstat>
			<d:prop>
				<d:resourcetype>
					<d:collection/>
				</d:resourcetype>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
		<d:propstat>
			<d:prop>
				<d:getcontentlength/>
				<d:getcontenttype/>
				<d:getetag/>
				<d:getlastmodified/>
				<nc:face-detections/>
				<nc:file-metadata-size/>
				<nc:has-preview/>
				<nc:realpath/>
				<oc:favorite/>
				<oc:fileid/>
				<oc:permissions/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
	<d:response>
		<d:href>/remote.php/dav/recognize/admin/faces/test/test1.jpg</d:href>
		<d:propstat>
			<d:prop>
				<d:getcontentlength>12345</d:getcontentlength>
				<d:getcontenttype>image/jpeg</d:getcontenttype>
				<d:getetag>00000000000000000000000000000000</d:getetag>
				<d:getlastmodified>Sun, 1 Jan 2023 01:02:03 GMT</d:getlastmodified>
				<d:resourcetype/>
				<nc:face-detections>[{&quot;id&quot;:1,&quot;userId&quot;:&quot;test&quot;,&quot;fileId&quot;:2,&quot;x&quot;:0.5,&quot;y&quot;:0.5,&quot;height&quot;:0.1,&quot;width&quot;:0.1,&quot;vector&quot;:[-0.1,0.1,0.1,-0.01],&quot;clusterId&quot;:10,&quot;title&quot;:&quot;test&quot;}]</nc:face-detections>
				<nc:file-metadata-size>[]</nc:file-metadata-size>
				<nc:has-preview>true</nc:has-preview>
				<nc:realpath>/admin/files/test1.jpg</nc:realpath>
				<oc:favorite>0</oc:favorite>
				<oc:fileid>2</oc:fileid>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
		<d:propstat>
			<d:prop>
				<oc:permissions/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await RecognizeFaceItemParser().parse(xml);
  expect(results, [
    const RecognizeFaceItem(
      href: "/remote.php/dav/recognize/admin/faces/test/",
    ),
    RecognizeFaceItem(
      href: "/remote.php/dav/recognize/admin/faces/test/test1.jpg",
      contentLength: 12345,
      contentType: "image/jpeg",
      etag: "00000000000000000000000000000000",
      lastModified: DateTime.utc(2023, 1, 1, 1, 2, 3),
      faceDetections: [
        {
          "id": 1,
          "userId": "test",
          "fileId": 2,
          "x": 0.5,
          "y": 0.5,
          "height": 0.1,
          "width": 0.1,
          "vector": [-0.1, 0.1, 0.1, -0.01],
          "clusterId": 10,
          "title": "test",
        },
      ],
      fileMetadataSize: null,
      hasPreview: true,
      realPath: "/admin/files/test1.jpg",
      favorite: false,
      fileId: 2,
    ),
  ]);
}

Future<void> _imageWithSize() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/test/</d:href>
    <d:propstat>
      <d:prop>
        <nc:file-metadata-size/>
      </d:prop>
      <d:status>HTTP/1.1 404 Not Found</d:status>
    </d:propstat>
  </d:response>
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/test/test1.jpg</d:href>
    <d:propstat>
      <d:prop>
        <nc:file-metadata-size>{&quot;width&quot;:1024,&quot;height&quot;:768}</nc:file-metadata-size>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
</d:multistatus>
""";
  final results = await RecognizeFaceItemParser().parse(xml);
  expect(results, [
    const RecognizeFaceItem(
      href: "/remote.php/dav/recognize/admin/faces/test/",
    ),
    const RecognizeFaceItem(
      href: "/remote.php/dav/recognize/admin/faces/test/test1.jpg",
      fileMetadataSize: {"width": 1024, "height": 768},
    ),
  ]);
}
