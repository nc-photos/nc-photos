import 'package:np_api/np_api.dart';
import 'package:test/test.dart';

void main() {
  group("RecognizeFaceParser", () {
    group("parse", () {
      test("empty", _empty);
      test("unnamed", _unnamed);
      test("named", _named);
    });
  });
}

Future<void> _empty() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/</d:href>
    <d:propstat>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
        </d:resourcetype>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
</d:multistatus>
""";
  final results = await RecognizeFaceParser().parse(xml);
  expect(results, const [
    RecognizeFace(href: "/remote.php/dav/recognize/admin/faces/"),
  ]);
}

Future<void> _unnamed() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/</d:href>
    <d:propstat>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
        </d:resourcetype>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/10/</d:href>
    <d:propstat>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
        </d:resourcetype>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
</d:multistatus>
""";
  final results = await RecognizeFaceParser().parse(xml);
  expect(results, const [
    RecognizeFace(href: "/remote.php/dav/recognize/admin/faces/"),
    RecognizeFace(href: "/remote.php/dav/recognize/admin/faces/10/"),
  ]);
}

Future<void> _named() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/</d:href>
    <d:propstat>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
        </d:resourcetype>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
  <d:response>
    <d:href>/remote.php/dav/recognize/admin/faces/lovely%20face/</d:href>
    <d:propstat>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
        </d:resourcetype>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
</d:multistatus>
""";
  final results = await RecognizeFaceParser().parse(xml);
  expect(results, const [
    RecognizeFace(href: "/remote.php/dav/recognize/admin/faces/"),
    RecognizeFace(href: "/remote.php/dav/recognize/admin/faces/lovely face/"),
  ]);
}
