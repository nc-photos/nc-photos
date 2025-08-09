import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/album.dart';
import 'package:nc_photos/entity/collection/content_provider/location_group.dart';
import 'package:nc_photos/entity/collection/content_provider/nc_album.dart';
import 'package:nc_photos/entity/collection/content_provider/person.dart';
import 'package:nc_photos/entity/collection/content_provider/tag.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/use_case/list_location_group.dart';

class CollectionBuilder {
  static Collection byAlbum(Account account, Album album) {
    return Collection(
      name: album.name,
      contentProvider: CollectionAlbumProvider(account: account, album: album),
    );
  }

  static Collection byLocationGroup(Account account, LocationGroup location) {
    return Collection(
      name: location.place,
      contentProvider: CollectionLocationGroupProvider(
        account: account,
        location: location,
      ),
    );
  }

  static Collection byNcAlbum(Account account, NcAlbum album) {
    return Collection(
      name: album.name,
      contentProvider: CollectionNcAlbumProvider(
        account: account,
        album: album,
      ),
    );
  }

  static Collection byPerson(Account account, Person person) {
    return Collection(
      name: person.name,
      contentProvider: CollectionPersonProvider(
        account: account,
        person: person,
      ),
    );
  }

  static Collection byTags(Account account, List<Tag> tags) {
    return Collection(
      name: tags.first.displayName,
      contentProvider: CollectionTagProvider(account: account, tags: tags),
    );
  }
}
