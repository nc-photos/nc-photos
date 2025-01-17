import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/use_case/scan_local_dir.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'scan_local_dir.g.dart';

abstract class ScanLocalDirBlocEvent {
  const ScanLocalDirBlocEvent();
}

@toString
class ScanLocalDirBlocQuery extends ScanLocalDirBlocEvent {
  const ScanLocalDirBlocQuery(this.relativePaths);

  @override
  String toString() => _$toString();

  @Format(r"${$?.toReadableString()}")
  final List<String> relativePaths;
}

@toString
class _ScanLocalDirBlocFileDeleted extends ScanLocalDirBlocEvent {
  const _ScanLocalDirBlocFileDeleted(this.files);

  @override
  String toString() => _$toString();

  @Format(r"${$?.map((f) => f.logTag).toReadableString()}")
  final List<LocalFile> files;
}

@toString
abstract class ScanLocalDirBlocState {
  const ScanLocalDirBlocState(this.files);

  @override
  String toString() => _$toString();

  final List<LocalFile> files;
}

class ScanLocalDirBlocInit extends ScanLocalDirBlocState {
  const ScanLocalDirBlocInit() : super(const []);
}

class ScanLocalDirBlocLoading extends ScanLocalDirBlocState {
  const ScanLocalDirBlocLoading(super.files);
}

class ScanLocalDirBlocSuccess extends ScanLocalDirBlocState {
  const ScanLocalDirBlocSuccess(super.files);
}

@toString
class ScanLocalDirBlocFailure extends ScanLocalDirBlocState {
  const ScanLocalDirBlocFailure(super.files, this.exception);

  @override
  String toString() => _$toString();

  final dynamic exception;
}

@npLog
class ScanLocalDirBloc
    extends Bloc<ScanLocalDirBlocEvent, ScanLocalDirBlocState> {
  ScanLocalDirBloc() : super(const ScanLocalDirBlocInit()) {
    on<ScanLocalDirBlocQuery>(_onScanLocalDirBlocQuery);
    on<_ScanLocalDirBlocFileDeleted>(_onScanLocalDirBlocFileDeleted);

    _fileDeletedEventListener.begin();
  }

  @override
  close() {
    _fileDeletedEventListener.end();
    return super.close();
  }

  Future<void> _onScanLocalDirBlocQuery(
      ScanLocalDirBlocQuery event, Emitter<ScanLocalDirBlocState> emit) async {
    final shouldEmitIntermediate = state.files.isEmpty;
    try {
      emit(ScanLocalDirBlocLoading(state.files));
      final c = KiwiContainer().resolve<DiContainer>();
      final products = <LocalFile>[];
      for (final p in event.relativePaths) {
        if (shouldEmitIntermediate) {
          emit(ScanLocalDirBlocLoading(products.toList()));
        }
        final files = await ScanLocalDir(c)(p);
        products.addAll(files);
      }
      emit(ScanLocalDirBlocSuccess(products));
    } catch (e, stackTrace) {
      _log.severe(
          "[_onScanLocalDirBlocQuery] Exception while request", e, stackTrace);
      emit(ScanLocalDirBlocFailure(state.files, e));
    }
  }

  Future<void> _onScanLocalDirBlocFileDeleted(
      _ScanLocalDirBlocFileDeleted event,
      Emitter<ScanLocalDirBlocState> emit) async {
    final newFiles = state.files
        .where((f) => !event.files.any((d) => d.compareIdentity(f)))
        .toList();
    if (newFiles.length != state.files.length) {
      emit(ScanLocalDirBlocSuccess(newFiles));
    }
  }

  void _onFileDeletedEvent(LocalFileDeletedEvent ev) {
    if (state is ScanLocalDirBlocInit) {
      return;
    }
    add(_ScanLocalDirBlocFileDeleted(ev.files));
  }

  late final _fileDeletedEventListener =
      AppEventListener<LocalFileDeletedEvent>(_onFileDeletedEvent);
}
