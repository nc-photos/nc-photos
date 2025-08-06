import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/bloc/bloc_util.dart' as bloc_util;
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/use_case/list_tag.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'list_tag.g.dart';

abstract class ListTagBlocEvent {
  const ListTagBlocEvent();
}

@toString
class ListTagBlocQuery extends ListTagBlocEvent {
  const ListTagBlocQuery(this.account);

  @override
  String toString() => _$toString();

  final Account account;
}

@toString
abstract class ListTagBlocState {
  const ListTagBlocState(this.account, this.items);

  @override
  String toString() => _$toString();

  final Account? account;
  final List<Tag> items;
}

class ListTagBlocInit extends ListTagBlocState {
  const ListTagBlocInit() : super(null, const []);
}

class ListTagBlocLoading extends ListTagBlocState {
  const ListTagBlocLoading(super.account, super.items);
}

class ListTagBlocSuccess extends ListTagBlocState {
  const ListTagBlocSuccess(super.account, super.items);
}

@toString
class ListTagBlocFailure extends ListTagBlocState {
  const ListTagBlocFailure(super.account, super.items, this.exception);

  @override
  String toString() => _$toString();

  final dynamic exception;
}

/// List all tags for this account
@npLog
class ListTagBloc extends Bloc<ListTagBlocEvent, ListTagBlocState> {
  ListTagBloc(this._c)
    : assert(require(_c)),
      assert(ListTag.require(_c)),
      super(const ListTagBlocInit()) {
    on<ListTagBlocEvent>(_onEvent);
  }

  static bool require(DiContainer c) => true;

  static ListTagBloc of(Account account) {
    final name = bloc_util.getInstNameForAccount("ListTagBloc", account);
    try {
      _log.fine("[of] Resolving bloc for '$name'");
      return KiwiContainer().resolve<ListTagBloc>(name);
    } catch (_) {
      // no created instance for this account, make a new one
      _log.info("[of] New bloc instance for account: $account");
      final bloc = ListTagBloc(KiwiContainer().resolve<DiContainer>());
      KiwiContainer().registerInstance<ListTagBloc>(bloc, name: name);
      return bloc;
    }
  }

  Future<void> _onEvent(
    ListTagBlocEvent event,
    Emitter<ListTagBlocState> emit,
  ) async {
    _log.info("[_onEvent] $event");
    if (event is ListTagBlocQuery) {
      await _onEventQuery(event, emit);
    }
  }

  Future<void> _onEventQuery(
    ListTagBlocQuery ev,
    Emitter<ListTagBlocState> emit,
  ) async {
    try {
      emit(ListTagBlocLoading(ev.account, state.items));
      emit(ListTagBlocSuccess(ev.account, await _query(ev)));
    } catch (e, stackTrace) {
      _log.severe("[_onEventQuery] Exception while request", e, stackTrace);
      emit(ListTagBlocFailure(ev.account, state.items, e));
    }
  }

  Future<List<Tag>> _query(ListTagBlocQuery ev) => ListTag(_c)(ev.account);

  final DiContainer _c;

  static final _log = _$ListTagBlocNpLog.log;
}
