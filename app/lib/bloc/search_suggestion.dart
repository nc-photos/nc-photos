import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';
import 'package:woozy_search/woozy_search.dart';

part 'search_suggestion.g.dart';

abstract class SearchSuggestionBlocEvent<T> {
  const SearchSuggestionBlocEvent();
}

@toString
class SearchSuggestionBlocUpdateItemsEvent<T>
    extends SearchSuggestionBlocEvent<T> {
  const SearchSuggestionBlocUpdateItemsEvent(this.items);

  @override
  String toString() => _$toString();

  final List<T> items;
}

@toString
class SearchSuggestionBlocSearchEvent<T> extends SearchSuggestionBlocEvent<T> {
  const SearchSuggestionBlocSearchEvent(this.phrase);

  @override
  String toString() => _$toString();

  final CiString phrase;
}

@toString
abstract class SearchSuggestionBlocState<T> {
  const SearchSuggestionBlocState(this.results);

  @override
  String toString() => _$toString();

  final List<T> results;
}

class SearchSuggestionBlocInit<T> extends SearchSuggestionBlocState<T> {
  const SearchSuggestionBlocInit() : super(const []);
}

class SearchSuggestionBlocLoading<T> extends SearchSuggestionBlocState<T> {
  const SearchSuggestionBlocLoading(super.results);
}

class SearchSuggestionBlocSuccess<T> extends SearchSuggestionBlocState<T> {
  const SearchSuggestionBlocSuccess(super.results);
}

@npLog
class SearchSuggestionBloc<T>
    extends Bloc<SearchSuggestionBlocEvent, SearchSuggestionBlocState<T>> {
  SearchSuggestionBloc({
    required this.itemToKeywords,
  }) : super(SearchSuggestionBlocInit<T>()) {
    on<SearchSuggestionBlocEvent>(_onEvent);
  }

  Future<void> _onEvent(SearchSuggestionBlocEvent event,
      Emitter<SearchSuggestionBlocState<T>> emit) async {
    _log.info("[_onEvent] $event");
    if (event is SearchSuggestionBlocSearchEvent) {
      await _onEventSearch(event, emit);
    } else if (event is SearchSuggestionBlocUpdateItemsEvent<T>) {
      await _onEventUpdateItems(event, emit);
    }
  }

  Future<void> _onEventSearch(SearchSuggestionBlocSearchEvent ev,
      Emitter<SearchSuggestionBlocState<T>> emit) async {
    emit(SearchSuggestionBlocLoading(state.results));
    // doesn't work with upper case
    final results = _search.search(ev.phrase.toCaseInsensitiveString());
    if (isDevMode) {
      final str = results.map((e) => "${e.score}: ${e.text}").join("\n");
      _log.info("[_onEventSearch] Search '${ev.phrase}':\n$str");
    }
    final matches = results
        .where((element) => element.score > 0)
        .map((e) {
          if (itemToKeywords(e.value as T)
              .any((k) => k.startsWith(ev.phrase))) {
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
    emit(SearchSuggestionBlocSuccess(matches));
    _lastSearch = ev;
  }

  Future<void> _onEventUpdateItems(SearchSuggestionBlocUpdateItemsEvent<T> ev,
      Emitter<SearchSuggestionBlocState<T>> emit) async {
    _search.setEntries([]);
    for (final a in ev.items) {
      for (final k in itemToKeywords(a)) {
        _search.addEntry(k.toCaseInsensitiveString(), value: a);
      }
    }
    if (_lastSearch != null) {
      // search again
      await _onEventSearch(_lastSearch!, emit);
    }
  }

  final List<CiString> Function(T item) itemToKeywords;

  final _search = Woozy(limit: 5);
  SearchSuggestionBlocSearchEvent? _lastSearch;
}
