// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_controller.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $CollectionStreamDataCopyWithWorker {
  CollectionStreamData call({
    Collection? collection,
    CollectionItemsController? controller,
  });
}

class _$CollectionStreamDataCopyWithWorkerImpl
    implements $CollectionStreamDataCopyWithWorker {
  _$CollectionStreamDataCopyWithWorkerImpl(this.that);

  @override
  CollectionStreamData call({dynamic collection, dynamic controller}) {
    return CollectionStreamData(
      collection: collection as Collection? ?? that.collection,
      controller: controller as CollectionItemsController? ?? that.controller,
    );
  }

  final CollectionStreamData that;
}

extension $CollectionStreamDataCopyWith on CollectionStreamData {
  $CollectionStreamDataCopyWithWorker get copyWith => _$copyWith;
  $CollectionStreamDataCopyWithWorker get _$copyWith =>
      _$CollectionStreamDataCopyWithWorkerImpl(this);
}

abstract class $CollectionStreamEventCopyWithWorker {
  CollectionStreamEvent call({List<CollectionStreamData>? data, bool? hasNext});
}

class _$CollectionStreamEventCopyWithWorkerImpl
    implements $CollectionStreamEventCopyWithWorker {
  _$CollectionStreamEventCopyWithWorkerImpl(this.that);

  @override
  CollectionStreamEvent call({dynamic data, dynamic hasNext}) {
    return CollectionStreamEvent(
      data: data as List<CollectionStreamData>? ?? that.data,
      hasNext: hasNext as bool? ?? that.hasNext,
    );
  }

  final CollectionStreamEvent that;
}

extension $CollectionStreamEventCopyWith on CollectionStreamEvent {
  $CollectionStreamEventCopyWithWorker get copyWith => _$copyWith;
  $CollectionStreamEventCopyWithWorker get _$copyWith =>
      _$CollectionStreamEventCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$CollectionsControllerNpLog on CollectionsController {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "controller.collections_controller.CollectionsController",
  );
}
