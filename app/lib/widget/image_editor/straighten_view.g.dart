// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'straighten_view.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $StraightenArgumentsCopyWithWorker {
  StraightenArguments call({int? degree, Offset? position});
}

class _$StraightenArgumentsCopyWithWorkerImpl
    implements $StraightenArgumentsCopyWithWorker {
  _$StraightenArgumentsCopyWithWorkerImpl(this.that);

  @override
  StraightenArguments call({dynamic degree, dynamic position}) {
    return StraightenArguments(
      degree: degree as int? ?? that.degree,
      position: position as Offset? ?? that.position,
    );
  }

  final StraightenArguments that;
}

extension $StraightenArgumentsCopyWith on StraightenArguments {
  $StraightenArgumentsCopyWithWorker get copyWith => _$copyWith;
  $StraightenArgumentsCopyWithWorker get _$copyWith =>
      _$StraightenArgumentsCopyWithWorkerImpl(this);
}
