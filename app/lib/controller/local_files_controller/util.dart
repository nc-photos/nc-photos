part of '../local_files_controller.dart';

class _LocalFilesSummaryDiff with EquatableMixin {
  const _LocalFilesSummaryDiff({
    required this.onlyInThis,
    required this.onlyInOther,
    required this.updated,
  });

  @override
  List<Object?> get props => [onlyInThis, onlyInOther, updated];

  final Map<Date, int> onlyInThis;
  final Map<Date, int> onlyInOther;
  final Map<Date, int> updated;
}

extension on LocalFilesSummary {
  _LocalFilesSummaryDiff diff(LocalFilesSummary other) {
    final thisIt = items.entries.toList().reversed.iterator;
    final otherIt = other.items.entries.toList().reversed.iterator;
    final thisMissing = <Date, int>{};
    final otherMissing = <Date, int>{};
    final updated = <Date, int>{};
    while (true) {
      if (!thisIt.moveNext()) {
        // no more elements in this
        otherIt.iterate((obj) {
          thisMissing[obj.key] = obj.value;
        });
        return _LocalFilesSummaryDiff(
          onlyInOther: LinkedHashMap.fromEntries(
            thisMissing.entries.toList().reversed,
          ),
          onlyInThis: LinkedHashMap.fromEntries(
            otherMissing.entries.toList().reversed,
          ),
          updated: LinkedHashMap.fromEntries(updated.entries.toList().reversed),
        );
      }
      if (!otherIt.moveNext()) {
        // no more elements in other
        // needed because thisIt has already advanced
        otherMissing[thisIt.current.key] = thisIt.current.value;
        thisIt.iterate((obj) {
          otherMissing[obj.key] = obj.value;
        });
        return _LocalFilesSummaryDiff(
          onlyInOther: LinkedHashMap.fromEntries(
            thisMissing.entries.toList().reversed,
          ),
          onlyInThis: LinkedHashMap.fromEntries(
            otherMissing.entries.toList().reversed,
          ),
          updated: LinkedHashMap.fromEntries(updated.entries.toList().reversed),
        );
      }
      final result = _diffUntilEqual(thisIt, otherIt);
      thisMissing.addAll(result.onlyInOther);
      otherMissing.addAll(result.onlyInThis);
      updated.addAll(result.updated);
    }
  }

  _LocalFilesSummaryDiff _diffUntilEqual(
    Iterator<MapEntry<Date, int>> thisIt,
    Iterator<MapEntry<Date, int>> otherIt,
  ) {
    final thisObj = thisIt.current, otherObj = otherIt.current;
    final diff = thisObj.key.compareTo(otherObj.key);
    if (diff < 0) {
      // this < other
      if (!thisIt.moveNext()) {
        return _LocalFilesSummaryDiff(
          onlyInOther: Map.fromEntries([otherObj])..addAll(otherIt.toMap()),
          onlyInThis: Map.fromEntries([thisObj]),
          updated: const {},
        );
      } else {
        final result = _diffUntilEqual(thisIt, otherIt);
        return _LocalFilesSummaryDiff(
          onlyInOther: result.onlyInOther,
          onlyInThis: Map.fromEntries([thisObj])..addAll(result.onlyInThis),
          updated: const {},
        );
      }
    } else if (diff > 0) {
      // this > other
      if (!otherIt.moveNext()) {
        return _LocalFilesSummaryDiff(
          onlyInOther: Map.fromEntries([otherObj]),
          onlyInThis: Map.fromEntries([thisObj])..addAll(thisIt.toMap()),
          updated: const {},
        );
      } else {
        final result = _diffUntilEqual(thisIt, otherIt);
        return _LocalFilesSummaryDiff(
          onlyInOther: Map.fromEntries([otherObj])..addAll(result.onlyInOther),
          onlyInThis: result.onlyInThis,
          updated: const {},
        );
      }
    } else {
      // this == other
      return _LocalFilesSummaryDiff(
        onlyInOther: const {},
        onlyInThis: const {},
        updated:
            thisObj.value == otherObj.value
                ? const {}
                : Map.fromEntries([otherObj]),
      );
    }
  }
}
