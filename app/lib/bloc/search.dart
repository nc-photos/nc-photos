import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/search.dart';
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/throttler.dart';
import 'package:nc_photos/use_case/search.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'search.g.dart';

abstract class SearchBlocEvent {
  const SearchBlocEvent();
}

@toString
class SearchBlocQuery extends SearchBlocEvent {
  const SearchBlocQuery(this.account, this.criteria);

  @override
  String toString() => _$toString();

  final Account account;
  final SearchCriteria criteria;
}

/// An external event has happened and may affect the state of this bloc
@toString
class _SearchBlocExternalEvent extends SearchBlocEvent {
  const _SearchBlocExternalEvent();

  @override
  String toString() => _$toString();
}

@toString
class SearchBlocResetLanding extends SearchBlocEvent {
  const SearchBlocResetLanding(this.account);

  @override
  String toString() => _$toString();

  final Account account;
}

@toString
abstract class SearchBlocState {
  const SearchBlocState(this.account, this.criteria, this.items);

  @override
  String toString() => _$toString();

  final Account? account;
  final SearchCriteria criteria;
  final List<FileDescriptor> items;
}

class SearchBlocInit extends SearchBlocState {
  SearchBlocInit() : super(null, SearchCriteria("", []), const []);
}

class SearchBlocLoading extends SearchBlocState {
  const SearchBlocLoading(super.account, super.criteria, super.items);
}

class SearchBlocSuccess extends SearchBlocState {
  const SearchBlocSuccess(super.account, super.criteria, super.items);
}

@toString
class SearchBlocFailure extends SearchBlocState {
  const SearchBlocFailure(
      super.account, super.criteria, super.items, this.exception);

  @override
  String toString() => _$toString();

  final Object exception;
}

/// The state of this bloc is inconsistent. This typically means that the data
/// may have been changed externally
class SearchBlocInconsistent extends SearchBlocState {
  const SearchBlocInconsistent(super.account, super.criteria, super.items);
}

@npLog
class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  SearchBloc(this._c)
      : assert(require(_c)),
        assert(Search.require(_c)),
        super(SearchBlocInit()) {
    _fileRemovedEventListener.begin();
    _filePropertyUpdatedEventListener.begin();
    // not listening to restore event because search works only with local data
    // sources and they are not aware of restore events

    on<SearchBlocEvent>(_onEvent);
  }

  static bool require(DiContainer c) => true;

  @override
  close() {
    _fileRemovedEventListener.end();
    _filePropertyUpdatedEventListener.end();
    return super.close();
  }

  Future<void> _onEvent(
      SearchBlocEvent event, Emitter<SearchBlocState> emit) async {
    _log.info("[_onEvent] $event");
    if (event is SearchBlocQuery) {
      await _onEventQuery(event, emit);
    } else if (event is SearchBlocResetLanding) {
      emit(SearchBlocInit());
    } else if (event is _SearchBlocExternalEvent) {
      await _onExternalEvent(event, emit);
    }
  }

  Future<void> _onEventQuery(
      SearchBlocQuery ev, Emitter<SearchBlocState> emit) async {
    try {
      emit(SearchBlocLoading(ev.account, ev.criteria, state.items));
      emit(SearchBlocSuccess(ev.account, ev.criteria, await _query(ev)));
    } catch (e, stackTrace) {
      _log.severe("[_onEventQuery] Exception while request", e, stackTrace);
      emit(SearchBlocFailure(ev.account, ev.criteria, state.items, e));
    }
  }

  Future<void> _onExternalEvent(
      _SearchBlocExternalEvent ev, Emitter<SearchBlocState> emit) async {
    emit(SearchBlocInconsistent(state.account, state.criteria, state.items));
  }

  void _onFileRemovedEvent(FileRemovedEvent ev) {
    if (state is SearchBlocInit) {
      // no data in this bloc, ignore
      return;
    }
    if (_isFileOfInterest(ev.file)) {
      _refreshThrottler.trigger(
        maxResponceTime: const Duration(seconds: 3),
        maxPendingCount: 10,
      );
    }
  }

  void _onFilePropertyUpdatedEvent(FilePropertyUpdatedEvent ev) {
    if (!ev.hasAnyProperties([
      FilePropertyUpdatedEvent.propMetadata,
      FilePropertyUpdatedEvent.propIsArchived,
      FilePropertyUpdatedEvent.propOverrideDateTime,
      FilePropertyUpdatedEvent.propFavorite,
    ])) {
      // not interested
      return;
    }
    if (state is SearchBlocInit) {
      // no data in this bloc, ignore
      return;
    }
    if (!_isFileOfInterest(ev.file)) {
      return;
    }

    if (ev.hasAnyProperties([
      FilePropertyUpdatedEvent.propIsArchived,
      FilePropertyUpdatedEvent.propOverrideDateTime,
      FilePropertyUpdatedEvent.propFavorite,
    ])) {
      _refreshThrottler.trigger(
        maxResponceTime: const Duration(seconds: 3),
        maxPendingCount: 10,
      );
    } else {
      _refreshThrottler.trigger(
        maxResponceTime: const Duration(seconds: 10),
        maxPendingCount: 10,
      );
    }
  }

  Future<List<FileDescriptor>> _query(SearchBlocQuery ev) =>
      Search(_c)(ev.account, ev.criteria);

  bool _isFileOfInterest(FileDescriptor file) {
    if (!file_util.isSupportedFormat(file)) {
      return false;
    }

    for (final r in state.account?.roots ?? []) {
      final dir = File(path: file_util.unstripPath(state.account!, r));
      if (file_util.isUnderDir(file, dir)) {
        return true;
      }
    }
    return false;
  }

  final DiContainer _c;

  late final _fileRemovedEventListener =
      AppEventListener<FileRemovedEvent>(_onFileRemovedEvent);
  late final _filePropertyUpdatedEventListener =
      AppEventListener<FilePropertyUpdatedEvent>(_onFilePropertyUpdatedEvent);

  late final _refreshThrottler = Throttler(
    onTriggered: (_) {
      add(const _SearchBlocExternalEvent());
    },
    logTag: "SearchBloc.refresh",
  );
}
