import 'package:np_api/np_api.dart';
import 'package:test/test.dart';

void main() {
  group("FavoriteParser", () {
    test("parse", _favorites);
  });
}

Future<void> _favorites() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
  <d:response>
    <d:status>HTTP/1.1 200 OK</d:status>
    <d:href>/remote.php/dav/files/admin/Nextcloud%20intro.mp4</d:href>
    <d:propstat>
      <d:prop>
        <oc:fileid>12345</oc:fileid>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
  <d:response>
    <d:status>HTTP/1.1 200 OK</d:status>
    <d:href>/remote.php/dav/files/admin/Nextcloud.png</d:href>
    <d:propstat>
      <d:prop>
        <oc:fileid>23456</oc:fileid>
      </d:prop>
      <d:status>HTTP/1.1 200 OK</d:status>
    </d:propstat>
  </d:response>
</d:multistatus>
""";
  final results = await FavoriteParser().parse(xml);
  expect(results, const [
    Favorite(
      href: "/remote.php/dav/files/admin/Nextcloud intro.mp4",
      fileId: 12345,
    ),
    Favorite(href: "/remote.php/dav/files/admin/Nextcloud.png", fileId: 23456),
  ]);
}
