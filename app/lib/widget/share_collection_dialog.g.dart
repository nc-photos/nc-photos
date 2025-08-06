// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_collection_dialog.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    Collection? collection,
    List<CollectionShare>? processingShares,
    List<Sharee>? sharees,
    Suggester<Sharee>? shareeSuggester,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic collection,
    dynamic processingShares,
    dynamic sharees = copyWithNull,
    dynamic shareeSuggester = copyWithNull,
    dynamic error = copyWithNull,
  }) {
    return _State(
      collection: collection as Collection? ?? that.collection,
      processingShares:
          processingShares as List<CollectionShare>? ?? that.processingShares,
      sharees:
          sharees == copyWithNull ? that.sharees : sharees as List<Sharee>?,
      shareeSuggester:
          shareeSuggester == copyWithNull
              ? that.shareeSuggester
              : shareeSuggester as Suggester<Sharee>?,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.share_collection_dialog._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {collection: $collection, processingShares: [length: ${processingShares.length}], sharees: ${sharees == null ? null : "[length: ${sharees!.length}]"}, shareeSuggester: $shareeSuggester, error: $error}";
  }
}

extension _$_UpdateCollectionToString on _UpdateCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UpdateCollection {collection: $collection}";
  }
}

extension _$_LoadShareeToString on _LoadSharee {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadSharee {}";
  }
}

extension _$_RefreshSuggesterToString on _RefreshSuggester {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RefreshSuggester {}";
  }
}

extension _$_ShareToString on _Share {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Share {sharee: $sharee}";
  }
}

extension _$_UnshareToString on _Unshare {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Unshare {share: $share}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
