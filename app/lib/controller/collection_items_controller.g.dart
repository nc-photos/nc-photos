// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_items_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $CollectionItemStreamDataCopyWithWorker {
  CollectionItemStreamData call({List<CollectionItem>? items, bool? hasNext});
}

class _$CollectionItemStreamDataCopyWithWorkerImpl
    implements $CollectionItemStreamDataCopyWithWorker {
  _$CollectionItemStreamDataCopyWithWorkerImpl(this.that);

  @override
  CollectionItemStreamData call({dynamic items, dynamic hasNext}) {
    return CollectionItemStreamData(
      items: items as List<CollectionItem>? ?? that.items,
      hasNext: hasNext as bool? ?? that.hasNext,
    );
  }

  final CollectionItemStreamData that;
}

extension $CollectionItemStreamDataCopyWith on CollectionItemStreamData {
  $CollectionItemStreamDataCopyWithWorker get copyWith => _$copyWith;
  $CollectionItemStreamDataCopyWithWorker get _$copyWith =>
      _$CollectionItemStreamDataCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$CollectionItemsControllerNpLog on CollectionItemsController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "controller.collection_items_controller.CollectionItemsController",
  );
}
