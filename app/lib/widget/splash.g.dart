// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    int? changelogFromVersion,
    double? upgradeProgress,
    String? upgradeText,
    bool? isDone,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic changelogFromVersion = copyWithNull,
    dynamic upgradeProgress = copyWithNull,
    dynamic upgradeText = copyWithNull,
    dynamic isDone,
  }) {
    return _State(
      changelogFromVersion:
          changelogFromVersion == copyWithNull
              ? that.changelogFromVersion
              : changelogFromVersion as int?,
      upgradeProgress:
          upgradeProgress == copyWithNull
              ? that.upgradeProgress
              : upgradeProgress as double?,
      upgradeText:
          upgradeText == copyWithNull
              ? that.upgradeText
              : upgradeText as String?,
      isDone: isDone as bool? ?? that.isDone,
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

extension _$_WrappedSplashNpLog on _WrappedSplash {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.splash._WrappedSplash");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.splash._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {changelogFromVersion: $changelogFromVersion, upgradeProgress: ${upgradeProgress == null ? null : "${upgradeProgress!.toStringAsFixed(3)}"}, upgradeText: $upgradeText, isDone: $isDone}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_ChangelogDismissedToString on _ChangelogDismissed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ChangelogDismissed {}";
  }
}
