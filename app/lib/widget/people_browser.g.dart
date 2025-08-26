// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_browser.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<Person>? persons,
    bool? isLoading,
    List<_Item>? transformedItems,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic persons,
    dynamic isLoading,
    dynamic transformedItems,
    dynamic error = copyWithNull,
  }) {
    return _State(
      persons: persons as List<Person>? ?? that.persons,
      isLoading: isLoading as bool? ?? that.isLoading,
      transformedItems:
          transformedItems as List<_Item>? ?? that.transformedItems,
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

extension _$_WrappedPeopleBrowserStateNpLog on _WrappedPeopleBrowserState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.people_browser._WrappedPeopleBrowserState");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.people_browser._Bloc");
}

extension _$_ItemNpLog on _Item {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.people_browser._Item");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {persons: [length: ${persons.length}], isLoading: $isLoading, transformedItems: [length: ${transformedItems.length}], error: $error}";
  }
}

extension _$_LoadPersonsToString on _LoadPersons {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadPersons {}";
  }
}

extension _$_ReloadToString on _Reload {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Reload {}";
  }
}

extension _$_TransformItemsToString on _TransformItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformItems {persons: [length: ${persons.length}]}";
  }
}
