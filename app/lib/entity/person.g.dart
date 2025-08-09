// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $PersonCopyWithWorker {
  Person call({String? name, PersonContentProvider? contentProvider});
}

class _$PersonCopyWithWorkerImpl implements $PersonCopyWithWorker {
  _$PersonCopyWithWorkerImpl(this.that);

  @override
  Person call({dynamic name, dynamic contentProvider}) {
    return Person(
      name: name as String? ?? that.name,
      contentProvider:
          contentProvider as PersonContentProvider? ?? that.contentProvider,
    );
  }

  final Person that;
}

extension $PersonCopyWith on Person {
  $PersonCopyWithWorker get copyWith => _$copyWith;
  $PersonCopyWithWorker get _$copyWith => _$PersonCopyWithWorkerImpl(this);
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$PersonToString on Person {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Person {name: $name, contentProvider: $contentProvider}";
  }
}
