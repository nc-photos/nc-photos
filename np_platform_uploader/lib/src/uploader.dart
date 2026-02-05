import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:np_platform_uploader/src/messages.g.dart' as api;
import 'package:to_string/to_string.dart';
import 'package:uuid/uuid.dart';

part 'uploader.g.dart';

class Uploadable with EquatableMixin {
  const Uploadable({
    required this.platformIdentifier,
    required this.uploadPath,
    required this.canConvert,
  });

  @override
  List<Object?> get props => [platformIdentifier, uploadPath, canConvert];

  final String platformIdentifier;
  final String uploadPath;
  final bool canConvert;
}

enum ConvertFormat {
  jpeg(0),
  jxl(1);

  const ConvertFormat(this.value);

  static ConvertFormat? tryParse(int value) {
    try {
      return ConvertFormat.values[value];
    } catch (_) {
      return null;
    }
  }

  String toDisplayString() {
    return switch (this) {
      ConvertFormat.jpeg => "JPEG",
      ConvertFormat.jxl => "JPEG-XL",
    };
  }

  final int value;
}

@genCopyWith
@toString
class ConvertConfig {
  const ConvertConfig({
    required this.format,
    required this.quality,
    this.downsizeMp,
  });

  @override
  String toString() => _$toString();

  final ConvertFormat format;
  final int quality;
  final double? downsizeMp;
}

class Uploader {
  static void asyncUpload({
    required List<Uploadable> uploadables,
    required Map<String, String> headers,
    ConvertConfig? convertConfig,
    void Function(Uploadable uploadable, bool isSuccess)? onResult,
  }) {
    _ensureInit();
    String taskId;
    do {
      taskId = const Uuid().v4();
    } while (_listeners.containsKey(taskId));
    final remainings = uploadables.toList();
    _listeners[taskId] = (
      onResult: (uploadable, isSuccess) {
        remainings.removeWhere(
          (e) => e.platformIdentifier == uploadable.platformIdentifier,
        );
        onResult?.call(uploadable, isSuccess);
      },
      onComplete: () {
        // assume all remaining files as failed
        for (final e in remainings) {
          onResult?.call(e, false);
        }
      },
    );
    _hostApi.asyncUpload(
      taskId: taskId,
      uploadables: uploadables.map((e) => e.toPigeon()).toList(),
      httpHeaders: headers,
      convertConfig: convertConfig?.toPigeon(),
    );
  }

  static void _ensureInit() {
    if (!_isInit) {
      _isInit = true;
      const flutterApi = _PigeonApiImpl();
      api.MyFlutterApi.setUp(flutterApi);
    }
  }

  static final _hostApi = api.MyHostApi();

  static var _isInit = false;
  static final _listeners =
      <
        String,
        ({
          void Function(Uploadable uploadable, bool isSuccess) onResult,
          void Function() onComplete,
        })
      >{};
}

class _PigeonApiImpl implements api.MyFlutterApi {
  const _PigeonApiImpl();

  @override
  void notifyUploadResult(
    String taskId,
    api.Uploadable uploadable,
    bool isSuccess,
  ) {
    Uploader._listeners[taskId]?.onResult(
      Uploadable(
        platformIdentifier: uploadable.platformIdentifier,
        uploadPath: uploadable.endPoint,
        canConvert: uploadable.canConvert,
      ),
      isSuccess,
    );
  }

  @override
  void notifyTaskComplete(String taskId) {
    Uploader._listeners[taskId]?.onComplete();
    Uploader._listeners.remove(taskId);
  }
}

extension on Uploadable {
  api.Uploadable toPigeon() {
    return api.Uploadable(
      platformIdentifier: platformIdentifier,
      endPoint: uploadPath,
      canConvert: canConvert,
    );
  }
}

extension on ConvertConfig {
  api.ConvertConfig toPigeon() {
    return api.ConvertConfig(
      format: format.value,
      quality: quality,
      downsizeMp: downsizeMp,
    );
  }
}
