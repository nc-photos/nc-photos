import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/adapter/adapter_mixin.dart';
import 'package:nc_photos/entity/collection/content_provider/tag.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/basic_item.dart';
import 'package:nc_photos/use_case/list_tagged_file.dart';

class CollectionTagAdapter
    with
        CollectionAdapterReadOnlyTag,
        CollectionAdapterUnremovableTag,
        CollectionAdapterUnshareableTag
    implements CollectionAdapter {
  CollectionTagAdapter(this._c, this.account, this.collection)
    : assert(require(_c)),
      _provider = collection.contentProvider as CollectionTagProvider;

  static bool require(DiContainer c) => true;

  @override
  Stream<List<CollectionItem>> listItem() async* {
    final files = await ListTaggedFile(_c)(account, _provider.tags);
    yield files.map((f) => BasicCollectionFileItem(f)).toList();
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

  final CollectionTagProvider _provider;
}
