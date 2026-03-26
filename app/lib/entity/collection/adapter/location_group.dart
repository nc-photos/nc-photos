import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/adapter/adapter_mixin.dart';
import 'package:nc_photos/entity/collection/content_provider/location_group.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/pref.dart';
import 'package:np_db/np_db.dart';

class CollectionLocationGroupAdapter
    with
        CollectionAdapterReadOnlyTag,
        CollectionAdapterUnremovableTag,
        CollectionAdapterUnshareableTag
    implements CollectionAdapter {
  CollectionLocationGroupAdapter(this._c, this.account, this.collection)
    : _provider = collection.contentProvider as CollectionLocationGroupProvider;

  @override
  Stream<List<CollectionItem>> listItem() async* {
    final files = await _c.fileRepo2.getFileDescriptors(
      account,
      file_util.unstripPath(
        account,
        AccountPref.of(account).getShareFolderOr(),
      ),
      location: DbFileQueryByLocation(
        place: _provider.location.place,
        countryCode: _provider.location.countryCode,
        isFuzzy: false,
      ),
      isAscending: false,
    );
    yield files
        .where((f) => file_util.isSupportedFormat(f))
        .map((f) => BasicCollectionFileItem(f))
        .toList();
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

  final CollectionLocationGroupProvider _provider;
}
