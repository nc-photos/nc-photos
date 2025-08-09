import 'package:device_info_plus/device_info_plus.dart';
import 'package:logging/logging.dart';
import 'package:memory_info/memory_info.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'android_info.g.dart';

/// System info for Android
///
/// Only meaningful when running on Android. Must call [init] before accessing
/// the data fields
@npLog
@toString
class AndroidInfo {
  factory AndroidInfo() => _inst;

  const AndroidInfo._({required this.sdkInt, required this.totalMemMb});

  static Future<void> init() async {
    final info = await DeviceInfoPlugin().androidInfo;
    final sdkInt = info.version.sdkInt;

    final memInfo = await MemoryInfoPlugin().memoryInfo;
    final totalMemMb = memInfo.totalMem!.toDouble();

    _inst = AndroidInfo._(sdkInt: sdkInt, totalMemMb: totalMemMb);
    _log.info("[init] $_inst");
  }

  @override
  String toString() => _$toString();

  static late final AndroidInfo _inst;

  /// Corresponding to Build.VERSION.SDK_INT
  final int sdkInt;
  final double totalMemMb;

  static final _log = _$AndroidInfoNpLog.log;
}

abstract class AndroidVersion {
  static const O = 26;
  // ignore: constant_identifier_names
  static const O_MR1 = 27;
  static const P = 28;
  static const Q = 29;
  static const R = 30;
  static const S = 31;
}
