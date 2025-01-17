import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'ls_dir.g.dart';

@toString
class LsDirBlocItem with EquatableMixin {
  LsDirBlocItem(this.file, this.isE2ee, this.children);

  @override
  String toString({bool isDeep = false}) {
    if (isDeep) {
      return "$runtimeType:${_toDeepString(0)}";
    } else {
      return _$toString();
    }
  }

  String _toDeepString(int level) {
    String product = "\n" + " " * (level * 2) + "-${file.path}";
    if (children != null) {
      for (final c in children!) {
        product += c._toDeepString(level + 1);
      }
    }
    return product;
  }

  @override
  get props => [
        file,
        children,
      ];

  final File file;
  final bool isE2ee;

  /// Child directories under this directory
  ///
  /// Null if this dir is not listed, due to things like depth limitation
  List<LsDirBlocItem>? children;
}

abstract class LsDirBlocEvent {
  const LsDirBlocEvent();
}

@toString
class LsDirBlocQuery extends LsDirBlocEvent {
  const LsDirBlocQuery(
    this.account,
    this.root, {
    this.depth = 1,
  });

  @override
  String toString() => _$toString();

  LsDirBlocQuery copyWith({
    Account? account,
    File? root,
    int? depth,
  }) {
    return LsDirBlocQuery(
      account ?? this.account,
      root ?? this.root,
      depth: depth ?? this.depth,
    );
  }

  final Account account;
  final File root;
  final int depth;
}

@toString
abstract class LsDirBlocState with EquatableMixin {
  const LsDirBlocState(this.account, this.root, this.items);

  @override
  String toString() => _$toString();

  @override
  get props => [
        account,
        root,
        items,
      ];

  final Account? account;
  final File root;
  final List<LsDirBlocItem> items;
}

class LsDirBlocInit extends LsDirBlocState {
  LsDirBlocInit() : super(null, File(path: ""), const []);
}

class LsDirBlocLoading extends LsDirBlocState {
  const LsDirBlocLoading(super.account, super.root, super.items);
}

class LsDirBlocSuccess extends LsDirBlocState {
  const LsDirBlocSuccess(super.account, super.root, super.items);
}

@toString
class LsDirBlocFailure extends LsDirBlocState {
  const LsDirBlocFailure(
      super.account, super.root, super.items, this.exception);

  @override
  String toString() => _$toString();

  @override
  get props => [
        ...super.props,
        exception,
      ];

  final dynamic exception;
}

/// A bloc that return all directories under a dir recursively
@npLog
class LsDirBloc extends Bloc<LsDirBlocEvent, LsDirBlocState> {
  LsDirBloc(
    this.fileRepo, {
    this.isListMinimal = false,
  }) : super(LsDirBlocInit()) {
    on<LsDirBlocEvent>(_onEvent);
  }

  Future<void> _onEvent(
      LsDirBlocEvent event, Emitter<LsDirBlocState> emit) async {
    _log.info("[_onEvent] $event");
    if (event is LsDirBlocQuery) {
      await _onEventQuery(event, emit);
    }
  }

  Future<void> _onEventQuery(
      LsDirBlocQuery ev, Emitter<LsDirBlocState> emit) async {
    try {
      emit(LsDirBlocLoading(ev.account, ev.root, state.items));
      emit(LsDirBlocSuccess(ev.account, ev.root, await _query(ev)));
    } catch (e) {
      _log.severe("[_onEventQuery] Exception while request", e);
      emit(LsDirBlocFailure(ev.account, ev.root, state.items, e));
    }
  }

  Future<List<LsDirBlocItem>> _query(LsDirBlocQuery ev) async {
    final product = <LsDirBlocItem>[];
    var files = _cache[ev.root.path];
    if (files == null) {
      final op = isListMinimal ? LsMinimal(fileRepo) : Ls(fileRepo);
      files = (await op(ev.account, ev.root))
          .where((f) => f.isCollection ?? false)
          .toList();
      _cache[ev.root.path] = files;
    }
    final removes = <File>[];
    for (final f in files) {
      try {
        List<LsDirBlocItem>? children;
        if (ev.depth > 1) {
          children = await _query(ev.copyWith(root: f, depth: ev.depth - 1));
        }
        product.add(LsDirBlocItem(f, false, children));
      } on ApiException catch (e) {
        if (e.response.statusCode == 404) {
          // this could happen when the server db contains dangling entries
          _log.warning(
              "[call] HTTP404 error while listing dir: ${logFilename(f.path)}");
          removes.add(f);
        } else if (f.isCollection == true && e.response.statusCode == 403) {
          // e2ee dir
          _log.warning("[call] HTTP403 error, likely E2EE dir: ${f.path}");
          product.add(LsDirBlocItem(f, true, []));
        } else {
          rethrow;
        }
      }
    }
    if (removes.isNotEmpty) {
      files.removeWhere((f) => removes.contains(f));
    }
    return product;
  }

  final FileRepo fileRepo;
  final bool isListMinimal;

  final _cache = <String, List<File>>{};
}
