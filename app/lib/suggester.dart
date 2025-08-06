import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:woozy_search/woozy_search.dart';

part 'suggester.g.dart';

@npLog
class Suggester<T> {
  Suggester({
    required this.items,
    required this.itemToKeywords,
    int maxResult = 5,
  }) : _searcher = Woozy(limit: maxResult) {
    for (final a in items) {
      for (final k in itemToKeywords(a)) {
        _searcher.addEntry(k.toCaseInsensitiveString(), value: a);
      }
    }
  }

  List<T> search(CiString phrase) {
    final results = _searcher.search(phrase.toCaseInsensitiveString());
    if (isDevMode) {
      final str = results.map((e) => "${e.score}: ${e.text}").join("\n");
      _log.info("[search] Search '$phrase':\n$str");
    }
    final matches =
        results
            .where((e) => e.score > 0)
            .map((e) {
              if (itemToKeywords(
                e.value as T,
              ).any((k) => k.startsWith(phrase))) {
                // prefer names that start exactly with the search phrase
                return (score: e.score + 1, item: e.value as T);
              } else {
                return (score: e.score, item: e.value as T);
              }
            })
            .sorted((a, b) => a.score.compareTo(b.score))
            .reversed
            .distinctIf(
              (a, b) => identical(a.item, b.item),
              (a) => a.item.hashCode,
            )
            .map((e) => e.item)
            .toList();
    return matches;
  }

  final List<T> items;
  final List<CiString> Function(T item) itemToKeywords;

  final Woozy _searcher;
}
