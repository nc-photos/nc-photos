import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/use_case/collection/list_collection.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:nc_photos/use_case/list_tag.dart';
import 'package:nc_photos/use_case/person/list_person.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';
import 'package:woozy_search/woozy_search.dart';

part 'home_search_suggestion.g.dart';

abstract class HomeSearchResult {}

@toString
class HomeSearchCollectionResult implements HomeSearchResult {
  const HomeSearchCollectionResult(this.collection);

  @override
  String toString() => _$toString();

  final Collection collection;
}

@toString
class HomeSearchTagResult implements HomeSearchResult {
  const HomeSearchTagResult(this.tag);

  @override
  String toString() => _$toString();

  final Tag tag;
}

@toString
class HomeSearchPersonResult implements HomeSearchResult {
  const HomeSearchPersonResult(this.person);

  @override
  String toString() => _$toString();

  final Person person;
}

@toString
class HomeSearchLocationResult implements HomeSearchResult {
  const HomeSearchLocationResult(this.location);

  @override
  String toString() => _$toString();

  final LocationGroup location;
}

abstract class HomeSearchSuggestionBlocEvent {
  const HomeSearchSuggestionBlocEvent();
}

@toString
class HomeSearchSuggestionBlocPreloadData
    extends HomeSearchSuggestionBlocEvent {
  const HomeSearchSuggestionBlocPreloadData();

  @override
  String toString() => _$toString();
}

@toString
class HomeSearchSuggestionBlocSearch extends HomeSearchSuggestionBlocEvent {
  const HomeSearchSuggestionBlocSearch(this.phrase);

  @override
  String toString() => _$toString();

  final CiString phrase;
}

@toString
abstract class HomeSearchSuggestionBlocState {
  const HomeSearchSuggestionBlocState(this.results);

  @override
  String toString() => _$toString();

  final List<HomeSearchResult> results;
}

class HomeSearchSuggestionBlocInit extends HomeSearchSuggestionBlocState {
  const HomeSearchSuggestionBlocInit() : super(const []);
}

class HomeSearchSuggestionBlocLoading extends HomeSearchSuggestionBlocState {
  const HomeSearchSuggestionBlocLoading(super.results);
}

class HomeSearchSuggestionBlocSuccess extends HomeSearchSuggestionBlocState {
  const HomeSearchSuggestionBlocSuccess(super.results);
}

@toString
class HomeSearchSuggestionBlocFailure extends HomeSearchSuggestionBlocState {
  const HomeSearchSuggestionBlocFailure(
    List<HomeSearchTagResult> super.results,
    this.exception,
  );

  @override
  String toString() => _$toString();

  final Object exception;
}

@npLog
class HomeSearchSuggestionBloc
    extends Bloc<HomeSearchSuggestionBlocEvent, HomeSearchSuggestionBlocState> {
  HomeSearchSuggestionBloc(
    this.account,
    this.collectionsController,
    this.serverController,
    this.accountPrefController,
  ) : super(const HomeSearchSuggestionBlocInit()) {
    final c = KiwiContainer().resolve<DiContainer>();
    assert(require(c));
    assert(ListTag.require(c));
    _c = c.withLocalRepo();

    on<HomeSearchSuggestionBlocEvent>(_onEvent);

    add(const HomeSearchSuggestionBlocPreloadData());
  }

  static bool require(DiContainer c) => true;

  Future<void> _onEvent(
    HomeSearchSuggestionBlocEvent event,
    Emitter<HomeSearchSuggestionBlocState> emit,
  ) async {
    _log.info("[_onEvent] $event");
    if (event is HomeSearchSuggestionBlocSearch) {
      await _onEventSearch(event, emit);
    } else if (event is HomeSearchSuggestionBlocPreloadData) {
      await _onEventPreloadData(event, emit);
    }
  }

  Future<void> _onEventSearch(
    HomeSearchSuggestionBlocSearch ev,
    Emitter<HomeSearchSuggestionBlocState> emit,
  ) async {
    if (ev.phrase.raw.isEmpty) {
      emit(const HomeSearchSuggestionBlocSuccess([]));
      return;
    }

    emit(HomeSearchSuggestionBlocLoading(state.results));
    // doesn't work with upper case
    final results = _search.search(ev.phrase.toCaseInsensitiveString());
    if (isDevMode) {
      final str = results.map((e) => "${e.score}: ${e.text}").join("\n");
      _log.fine("[_onEventSearch] Search '${ev.phrase}':\n$str");
    }
    final matches =
        results
            .where((element) => element.score > 0)
            .map((e) {
              if (e.value!.toKeywords().any((k) => k.startsWith(ev.phrase))) {
                // prefer names that start exactly with the search phrase
                return (score: e.score + 1, item: e.value);
              } else {
                return (score: e.score, item: e.value);
              }
            })
            .sorted((a, b) => b.score.compareTo(a.score))
            .distinctIf(
              (a, b) => identical(a.item, b.item),
              (a) => a.item.hashCode,
            )
            .map((e) => e.item!.toResult())
            .toList();
    emit(HomeSearchSuggestionBlocSuccess(matches));
  }

  Future<void> _onEventPreloadData(
    HomeSearchSuggestionBlocPreloadData ev,
    Emitter<HomeSearchSuggestionBlocState> emit,
  ) async {
    final product = <_Searcheable>[];
    try {
      var collections =
          collectionsController
              .peekStream()
              .data
              .map((e) => e.collection)
              .toList();
      if (collections.isEmpty) {
        collections =
            await ListCollection(_c, serverController: serverController)(
              account,
            ).last;
      }
      product.addAll(collections.map(_CollectionSearcheable.new));
      _log.info(
        "[_onEventPreloadData] Loaded ${collections.length} collections",
      );
    } catch (e) {
      _log.warning("[_onEventPreloadData] Failed while ListCollection", e);
    }
    try {
      final tags = await ListTag(_c)(account);
      product.addAll(tags.map((t) => _TagSearcheable(t)));
      _log.info("[_onEventPreloadData] Loaded ${tags.length} tags");
    } catch (e) {
      _log.warning("[_onEventPreloadData] Failed while ListTag", e);
    }
    try {
      final persons =
          await ListPerson(_c)(
            account,
            accountPrefController.personProviderValue,
          ).last;
      product.addAll(persons.map((t) => _PersonSearcheable(t)));
      _log.info("[_onEventPreloadData] Loaded ${persons.length} people");
    } catch (e) {
      _log.warning("[_onEventPreloadData] Failed while ListPerson", e);
    }
    try {
      final locations = await ListLocationGroup(_c)(account);
      // make sure no duplicates
      final map = <String, LocationGroup>{};
      for (final l
          in locations.name +
              locations.admin1 +
              locations.admin2 +
              locations.countryCode) {
        map[l.place] = l;
      }
      product.addAll(map.values.map((e) => _LocationSearcheable(e)));
      _log.info(
        "[_onEventPreloadData] Loaded ${locations.name.length + locations.countryCode.length} locations",
      );
    } catch (e) {
      _log.warning("[_onEventPreloadData] Failed while ListLocationGroup", e);
    }

    _setSearchItems(product);
  }

  void _setSearchItems(List<_Searcheable> searcheables) {
    _search.setEntries([]);
    for (final s in searcheables) {
      for (final k in s.toKeywords()) {
        _search.addEntry(k.toCaseInsensitiveString(), value: s);
      }
    }
  }

  final Account account;
  final CollectionsController collectionsController;
  final ServerController serverController;
  final AccountPrefController accountPrefController;
  late final DiContainer _c;

  final _search = Woozy<_Searcheable>(limit: 10);
}

abstract class _Searcheable {
  List<CiString> toKeywords();
  HomeSearchResult toResult();
}

class _CollectionSearcheable implements _Searcheable {
  const _CollectionSearcheable(this.collection);

  @override
  toKeywords() => [collection.name.toCi()];

  @override
  toResult() => HomeSearchCollectionResult(collection);

  final Collection collection;
}

class _TagSearcheable implements _Searcheable {
  const _TagSearcheable(this.tag);

  @override
  toKeywords() => [tag.displayName.toCi()];

  @override
  toResult() => HomeSearchTagResult(tag);

  final Tag tag;
}

class _PersonSearcheable implements _Searcheable {
  const _PersonSearcheable(this.person);

  @override
  toKeywords() => [person.name.toCi()];

  @override
  toResult() => HomeSearchPersonResult(person);

  final Person person;
}

class _LocationSearcheable implements _Searcheable {
  const _LocationSearcheable(this.location);

  @override
  toKeywords() => [location.place.toCi()];

  @override
  toResult() => HomeSearchLocationResult(location);

  final LocationGroup location;
}
