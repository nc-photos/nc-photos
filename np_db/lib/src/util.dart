import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/src/api.dart';

class DbFilesSummaryDiff with EquatableMixin {
  const DbFilesSummaryDiff({
    required this.onlyInThis,
    required this.onlyInOther,
    required this.updated,
  });

  @override
  List<Object?> get props => [onlyInThis, onlyInOther, updated];

  final Map<Date, DbFilesSummaryItem> onlyInThis;
  final Map<Date, DbFilesSummaryItem> onlyInOther;
  final Map<Date, DbFilesSummaryItem> updated;
}

extension DbFilesSummaryExtension on DbFilesSummary {
  DbFilesSummaryDiff diff(DbFilesSummary other) {
    final thisIt = items.entries.toList().reversed.iterator;
    final otherIt = other.items.entries.toList().reversed.iterator;
    final thisMissing = <Date, DbFilesSummaryItem>{};
    final otherMissing = <Date, DbFilesSummaryItem>{};
    final updated = <Date, DbFilesSummaryItem>{};
    while (true) {
      if (!thisIt.moveNext()) {
        // no more elements in this
        otherIt.iterate((obj) {
          thisMissing[obj.key] = obj.value;
        });
        return DbFilesSummaryDiff(
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
        return DbFilesSummaryDiff(
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

  DbFilesSummaryDiff _diffUntilEqual(
    Iterator<MapEntry<Date, DbFilesSummaryItem>> thisIt,
    Iterator<MapEntry<Date, DbFilesSummaryItem>> otherIt,
  ) {
    final thisObj = thisIt.current, otherObj = otherIt.current;
    final diff = thisObj.key.compareTo(otherObj.key);
    if (diff < 0) {
      // this < other
      if (!thisIt.moveNext()) {
        return DbFilesSummaryDiff(
          onlyInOther: Map.fromEntries([otherObj])..addAll(otherIt.toMap()),
          onlyInThis: Map.fromEntries([thisObj]),
          updated: const {},
        );
      } else {
        final result = _diffUntilEqual(thisIt, otherIt);
        return DbFilesSummaryDiff(
          onlyInOther: result.onlyInOther,
          onlyInThis: Map.fromEntries([thisObj])..addAll(result.onlyInThis),
          updated: const {},
        );
      }
    } else if (diff > 0) {
      // this > other
      if (!otherIt.moveNext()) {
        return DbFilesSummaryDiff(
          onlyInOther: Map.fromEntries([otherObj]),
          onlyInThis: Map.fromEntries([thisObj])..addAll(thisIt.toMap()),
          updated: const {},
        );
      } else {
        final result = _diffUntilEqual(thisIt, otherIt);
        return DbFilesSummaryDiff(
          onlyInOther: Map.fromEntries([otherObj])..addAll(result.onlyInOther),
          onlyInThis: result.onlyInThis,
          updated: const {},
        );
      }
    } else {
      // this == other
      return DbFilesSummaryDiff(
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
