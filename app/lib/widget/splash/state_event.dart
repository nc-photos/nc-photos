part of 'splash.dart';

@genCopyWith
@toString
class _State {
  const _State({
    this.changelogFromVersion,
    this.upgradeProgress,
    this.upgradeText,
    required this.isDone,
  });

  factory _State.init() => const _State(isDone: false);

  @override
  String toString() => _$toString();

  final int? changelogFromVersion;
  final double? upgradeProgress;
  final String? upgradeText;
  final bool isDone;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _ChangelogDismissed implements _Event {
  const _ChangelogDismissed();

  @override
  String toString() => _$toString();
}
