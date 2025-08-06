// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $CollectionCopyWithWorker {
  Collection call({String? name, CollectionContentProvider? contentProvider});
}

class _$CollectionCopyWithWorkerImpl implements $CollectionCopyWithWorker {
  _$CollectionCopyWithWorkerImpl(this.that);

  @override
  Collection call({dynamic name, dynamic contentProvider}) {
    return Collection(
      name: name as String? ?? that.name,
      contentProvider:
          contentProvider as CollectionContentProvider? ?? that.contentProvider,
    );
  }

  final Collection that;
}

extension $CollectionCopyWith on Collection {
  $CollectionCopyWithWorker get copyWith => _$copyWith;
  $CollectionCopyWithWorker get _$copyWith =>
      _$CollectionCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$CollectionToString on Collection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Collection {name: $name, contentProvider: $contentProvider}";
  }
}
