import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:euc/jis.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:logging/logging.dart';
import 'package:np_common/object_util.dart';
import 'package:quiver/iterables.dart';

import 'np_exiv2_bindings_generated.dart';

enum TypeId {
  unsignedByte,
  asciiString,
  unsignedShort,
  unsignedLong,
  unsignedRational,
  signedByte,
  undefined,
  signedShort,
  signedLong,
  signedRational,
  tiffFloat,
  tiffDouble,
  tiffIfd,
  unsignedLongLong,
  signedLongLong,
  tiffIfd8,
  string,
  date,
  time,
  comment,
  directory,
  xmpText,
  xmpAlt,
  xmpBag,
  xmpSeq,
  langAlt,
  invalidTypeId;

  factory TypeId.fromNative(Exiv2TypeId src) {
    return TypeId.values[src.index];
  }
}

class Date {
  const Date(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;
}

class Time {
  const Time(this.hour, this.minute, this.second, this.tzHour, this.tzMinute);

  final int hour;
  final int minute;
  final int second;
  final int tzHour;
  final int tzMinute;
}

class Rational {
  const Rational(this.numerator, this.denominator);

  double toDouble() => numerator / denominator;

  @override
  String toString() => "$numerator/$denominator";

  final int numerator;
  final int denominator;
}

class Value {
  const Value({
    required this.typeId,
    required Uint8List data,
    required int count,
  }) : _data = data,
       _count = count;

  T as<T>() => asTyped() as T;

  Object asTyped() {
    try {
      switch (typeId) {
        case TypeId.unsignedByte:
          return _listOrValue(_data);
        case TypeId.asciiString:
          // this is supposed to be ascii but vendors are putting utf-8 strings
          return _removeNullTerminator(utf8.decode(_data));
        case TypeId.unsignedShort:
          return _listOrValue(_data.buffer.asUint16List());
        case TypeId.unsignedLong:
        case TypeId.tiffIfd:
          return _listOrValue(_data.buffer.asUint32List());
        case TypeId.unsignedRational:
          return _listOrValue(
            partition(
              _data.buffer.asUint32List(),
              2,
            ).map((e) => Rational(e[0], e[1])).toList(),
          );
        case TypeId.signedByte:
          return _listOrValue(_data.buffer.asInt8List());
        case TypeId.signedShort:
          return _listOrValue(_data.buffer.asInt16List());
        case TypeId.signedLong:
          return _listOrValue(_data.buffer.asInt32List());
        case TypeId.signedRational:
          return _listOrValue(
            partition(
              _data.buffer.asInt32List(),
              2,
            ).map((e) => Rational(e[0], e[1])).toList(),
          );
        case TypeId.tiffFloat:
          return _listOrValue(_data.buffer.asFloat32List());
        case TypeId.tiffDouble:
          return _listOrValue(_data.buffer.asFloat64List());
        case TypeId.unsignedLongLong:
        case TypeId.tiffIfd8:
          return _listOrValue(_data.buffer.asUint64List());
        case TypeId.signedLongLong:
          return _listOrValue(_data.buffer.asInt64List());
        case TypeId.string:
          return _removeNullTerminator(utf8.decode(_data));
        case TypeId.date:
          return _data.buffer.asInt32List().let((e) => Date(e[0], e[1], e[2]));
        case TypeId.time:
          return _data.buffer.asInt32List().let(
            (e) => Time(e[0], e[1], e[2], e[3], e[4]),
          );
        case TypeId.comment:
          return _convertCommentValue();
        case TypeId.undefined:
        case TypeId.directory:
        case TypeId.invalidTypeId:
          return _data.buffer.asUint8List();
        case TypeId.xmpText:
          return _removeNullTerminator(utf8.decode(_data));
        case TypeId.xmpSeq:
          return _removeNullTerminator(utf8.decode(_data)).split(", ");
        case TypeId.xmpAlt:
        case TypeId.xmpBag:
        case TypeId.langAlt:
          throw UnsupportedError("XMP not fully supported");
      }
    } catch (e, stackTrace) {
      _log.severe(
        "[asTyped] Failed to convert data to type: $typeId, $_data",
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  String toDebugString() {
    return "Value{"
        "typeId: $typeId, "
        "size: ${_data.length}, "
        "count: $_count, "
        "}";
  }

  Object _listOrValue(List<Object> values) {
    return _count == 1 ? values.first : values;
  }

  String _convertCommentValue() {
    // the first 8 chars is the charset, valid values are [ASCII, JIS,
    // UNICODE]
    return _data.buffer.asUint8List().let((e) {
      String? charset;
      Uint8List data = e;
      if (e.length >= 8) {
        charset = ascii.decode(e.sublist(0, 8));
        data = e.sublist(8);
      }
      if (charset == "ASCII") {
        return _removeNullTerminator(ascii.decode(data, allowInvalid: true));
      } else if (charset == "JIS") {
        return _removeNullTerminator(ShiftJIS().decode(data));
      } else if (charset == "UNICODE") {
        // UTF16
        return _removeNullTerminator(
          String.fromCharCodes(data.buffer.asUint16List()),
        );
      } else {
        // unknown, treat as utf8
        return _removeNullTerminator(utf8.decode(data));
      }
    });
  }

  String _removeNullTerminator(String src) {
    // C strings are null terminated, dart's aren't
    if (src.isEmpty) {
      // ?
      return src;
    } else {
      var end = src.length;
      while (end > 0 && src[end - 1] == "\u0000") {
        --end;
      }
      if (end == 0) {
        return "";
      } else {
        return src.substring(0, end);
      }
    }
  }

  final TypeId typeId;
  final Uint8List _data;
  final int _count;

  static final _log = Logger("np_exiv2.Value");
}

class Metadatum {
  const Metadatum({required this.tagKey, required this.value});

  factory Metadatum.fromNative(Exiv2Metadatum src) {
    return Metadatum(
      tagKey: src.tag_key.cast<ffi.Utf8>().toDartString(),
      value: Value(
        typeId: TypeId.fromNative(src.type_id),
        count: src.count,
        data: Uint8List.fromList(src.data.asTypedList(src.size)),
      ),
    );
  }

  final String tagKey;
  final Value value;
}

class ReadResult {
  const ReadResult(
    this.width,
    this.height,
    this.iptcData,
    this.exifData,
    this.xmpData,
  );

  factory ReadResult.fromNative(Exiv2ReadResult src) {
    _log.fine(
      "[fromNative] w: ${src.width}, h: ${src.height}, iptcCount: ${src.iptc_count}, exifCount: ${src.exif_count}, xmpCount: ${src.xmp_count}",
    );
    final iptcData = <Metadatum>[];
    for (var i = 0; i < src.iptc_count; ++i) {
      iptcData.add(Metadatum.fromNative(src.iptc_data[i]));
    }
    final exifData = <Metadatum>[];
    for (var i = 0; i < src.exif_count; ++i) {
      exifData.add(Metadatum.fromNative(src.exif_data[i]));
    }
    final xmpData = <Metadatum>[];
    for (var i = 0; i < src.xmp_count; ++i) {
      xmpData.add(Metadatum.fromNative(src.xmp_data[i]));
    }
    return ReadResult(src.width, src.height, iptcData, exifData, xmpData);
  }

  // always 0 for videos, width of a video can only be retrieved from XMP (if
  // available)
  final int width;
  // always 0 for videos, height of a video can only be retrieved from XMP (if
  // available)
  final int height;
  final List<Metadatum> iptcData;
  final List<Metadatum> exifData;
  final List<Metadatum> xmpData;

  static final _log = Logger("np_exiv2.ReadResult");
}

ReadResult readFile(String path, {required bool isReadXmp}) {
  final stopwatch = Stopwatch()..start();
  final pathC = path.toNativeUtf8();
  try {
    _log.fine("[readFile] Reading $path");
    final result = _bindings.exiv2_read_file(pathC.cast(), isReadXmp ? 1 : 0);
    if (result == nullptr) {
      _log.severe("[readFile] Result is null for file: $path");
      throw StateError("Failed to read file");
    }
    try {
      return ReadResult.fromNative(result[0]);
    } finally {
      _bindings.exiv2_result_free(result);
    }
  } finally {
    ffi.malloc.free(pathC);
    _log.fine("[readFile] Done in ${stopwatch.elapsedMilliseconds}ms");
  }
}

ReadResult readBuffer(Uint8List buffer, {required bool isReadXmp}) {
  final stopwatch = Stopwatch()..start();
  Pointer<Uint8>? cbuffer;
  try {
    _log.fine("[readBuffer] Allocating buffer with size: ${buffer.length}");
    cbuffer = ffi.malloc.allocate<Uint8>(buffer.length);
    final cbufferView = cbuffer.asTypedList(buffer.length);
    cbufferView.setAll(0, buffer);
    _log.fine("[readBuffer] Reading buffer");
    final result = _bindings.exiv2_read_buffer(
      cbuffer,
      buffer.length,
      isReadXmp ? 1 : 0,
    );
    if (result == nullptr) {
      _log.severe("[readBuffer] Result is null for buffer");
      throw StateError("Failed to read buffer");
    }
    try {
      return ReadResult.fromNative(result[0]);
    } finally {
      _bindings.exiv2_result_free(result);
    }
  } finally {
    if (cbuffer != null) {
      ffi.malloc.free(cbuffer);
      _log.fine("[readBuffer] Done in ${stopwatch.elapsedMilliseconds}ms");
    }
  }
}

final _log = Logger("np_exiv2");
const String _libName = 'np_exiv2';

/// The dynamic library in which the symbols for [NpExiv2Bindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NpExiv2Bindings _bindings = NpExiv2Bindings(_dylib);
