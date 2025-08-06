import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/adapter/adapter_mixin.dart';
import 'package:nc_photos/entity/collection/content_provider/person.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/use_case/person/list_person_face.dart';

class CollectionPersonAdapter
    with
        CollectionAdapterReadOnlyTag,
        CollectionAdapterUnremovableTag,
        CollectionAdapterUnshareableTag
    implements CollectionAdapter {
  CollectionPersonAdapter(this._c, this.account, this.collection)
    : _provider = collection.contentProvider as CollectionPersonProvider;

  @override
  Stream<List<CollectionItem>> listItem() {
    final rootDirs =
        account.roots
            .map((e) => File(path: file_util.unstripPath(account, e)))
            .toList();
    return ListPersonFace(_c)(account, _provider.person).map((faces) {
      return faces
          .map((e) => e.file)
          .where(
            (f) =>
                file_util.isSupportedFormat(f) &&
                rootDirs.any((dir) => file_util.isUnderDir(f, dir)),
          )
          .map((f) => BasicCollectionFileItem(f))
          .toList();
    });
  }

  @override
  Future<CollectionItem> adaptToNewItem(CollectionItem original) async {
    if (original is CollectionFileItem) {
      return BasicCollectionFileItem(original.file);
    } else {
      throw UnsupportedError("Unsupported type: ${original.runtimeType}");
    }
  }

  @override
  bool isItemDeletable(CollectionItem item) => true;

  @override
  bool isPermitted(CollectionCapability capability) =>
      _provider.capabilities.contains(capability);

  final DiContainer _c;
  final Account account;
  final Collection collection;

  final CollectionPersonProvider _provider;
}
