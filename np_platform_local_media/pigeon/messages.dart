import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: "lib/src/messages.g.dart",
    kotlinOut:
        'android/src/main/kotlin/com/nkming/nc_photos/np_platform_local_media/Messages.g.kt',
    kotlinOptions: KotlinOptions(
      package: "com.nkming.nc_photos.np_platform_local_media",
    ),
    swiftOut: "ios/Classes/Messages.g.swift",
  ),
)
class QueryResult {
  late final String id;
  late final String? displayName;
  late final int? dateModified;
  late final String? mimeType;
  late final int? dateTaken;
  late final int? width;
  late final int? height;
  late final int? size;

  // android specific
  // not null
  late final String? androidUri;
  // not null
  late final String? androidPath;
}

@HostApi()
abstract class MyHostApi {
  @async
  Map<String, int> getFilesSummary({List<String>? dirWhitelist});

  @async
  List<QueryResult> queryFiles({
    List<String>? fileIds,
    int? timeRangeBeg,
    bool? isTimeRangeBegInclusive,
    int? timeRangeEnd,
    bool? isTimeRangeEndInclusive,
    List<String>? dirWhitelist,
    required bool isAscending,
    int? offset,
    int? limit,
  });

  /// Read the content of a file identified by [platformIdentifier]
  ///
  /// [platformIdentifier] is platform-specific and should be a value returned
  /// in [QueryResult.platformIdentifier].
  @async
  Uint8List readFile(String platformIdentifier);

  /// Read the content of an image file, and downscale it to save memory
  ///
  /// Also see [readFile].
  @async
  Uint8List readThumbnail(
    String platformIdentifier, {
    required int width,
    required int height,
  });
}
