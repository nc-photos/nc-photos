import 'package:np_api/np_api.dart';
import 'package:test/test.dart';

void main() {
  group("NcAlbumParser", () {
    test("no album", _noAlbum);
    test("empty", _empty);
    test("basic", _basic);
    test("collaborative", _collaborative);
  });
}

Future<void> _noAlbum() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo/>
				<nc:nbItems/>
				<nc:location/>
				<nc:dateRange/>
				<nc:collaborators/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await NcAlbumParser().parse(xml);
  expect(results, [
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/",
      lastPhoto: null,
      nbItems: null,
      location: null,
      dateRange: null,
      collaborators: [],
    ),
  ]);
}

Future<void> _empty() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo/>
				<nc:nbItems/>
				<nc:location/>
				<nc:dateRange/>
				<nc:collaborators/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/test/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo>-1</nc:last-photo>
				<nc:nbItems>0</nc:nbItems>
				<nc:location></nc:location>
				<nc:dateRange>{&quot;start&quot;:null,&quot;end&quot;:null}</nc:dateRange>
				<nc:collaborators/>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await NcAlbumParser().parse(xml);
  expect(results, [
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/",
      lastPhoto: null,
      nbItems: null,
      location: null,
      dateRange: null,
      collaborators: [],
    ),
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/test/",
      lastPhoto: -1,
      nbItems: 0,
      location: null,
      dateRange: <String, dynamic>{"start": null, "end": null},
      collaborators: [],
    ),
  ]);
}

Future<void> _basic() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo/>
				<nc:nbItems/>
				<nc:location/>
				<nc:dateRange/>
				<nc:collaborators/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/test/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo>1</nc:last-photo>
				<nc:nbItems>1</nc:nbItems>
				<nc:location></nc:location>
				<nc:dateRange>{&quot;start&quot;:1577934245,&quot;end&quot;:1580702706}</nc:dateRange>
				<nc:collaborators/>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await NcAlbumParser().parse(xml);
  expect(results, [
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/",
      lastPhoto: null,
      nbItems: null,
      location: null,
      dateRange: null,
      collaborators: [],
    ),
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/test/",
      lastPhoto: 1,
      nbItems: 1,
      location: null,
      dateRange: <String, dynamic>{"start": 1577934245, "end": 1580702706},
      collaborators: [],
    ),
  ]);
}

Future<void> _collaborative() async {
  const xml = """
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:"
	xmlns:s="http://sabredav.org/ns"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns">
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo/>
				<nc:nbItems/>
				<nc:location/>
				<nc:dateRange/>
				<nc:collaborators/>
			</d:prop>
			<d:status>HTTP/1.1 404 Not Found</d:status>
		</d:propstat>
	</d:response>
	<d:response>
		<d:href>/remote.php/dav/photos/admin/albums/test/</d:href>
		<d:propstat>
			<d:prop>
				<nc:last-photo>1</nc:last-photo>
				<nc:nbItems>1</nc:nbItems>
				<nc:location></nc:location>
				<nc:dateRange>{&quot;start&quot;:1577934245,&quot;end&quot;:1580702706}</nc:dateRange>
				<nc:collaborators>
					<nc:collaborator>
						<id>user2</id>
						<label>User2</label>
						<type>0</type>
					</nc:collaborator>
				</nc:collaborators>
			</d:prop>
			<d:status>HTTP/1.1 200 OK</d:status>
		</d:propstat>
	</d:response>
</d:multistatus>
""";
  final results = await NcAlbumParser().parse(xml);
  expect(results, [
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/",
      lastPhoto: null,
      nbItems: null,
      location: null,
      dateRange: null,
      collaborators: [],
    ),
    const NcAlbum(
      href: "/remote.php/dav/photos/admin/albums/test/",
      lastPhoto: 1,
      nbItems: 1,
      location: null,
      dateRange: <String, dynamic>{"start": 1577934245, "end": 1580702706},
      collaborators: [
        NcAlbumCollaborator(id: "user2", label: "User2", type: 0),
      ],
    ),
  ]);
}
