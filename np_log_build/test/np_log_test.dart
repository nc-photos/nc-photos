import 'package:build_test/build_test.dart';
import 'package:np_log_build/src/np_log_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

// dummy class to free us from importing the actual logger library
class Logger {
  Logger(String name);
}

void main() async {
  tearDown(() {
    // Increment this after each test so the next test has it's own package
    _pkgCacheCount++;
  });

  test("NpLog", () async {
    final src = _genSrc("""
@npLog
class Foo {}
""");
    final expected = _genExpected(r"""
extension _$FooNpLog on Foo {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("test.Foo");
}
""");
    return _buildTest(src, expected);
  });
}

String _genSrc(String src, {List<String> extraImportStatements = const []}) {
  return """
import 'package:np_log_annotation/np_log_annotation.dart';
${extraImportStatements.join("\n")}
part 'test.g.dart';
$src
""";
}

String _genExpected(String src) {
  return """// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'test.dart';

// **************************************************************************
// NpLogGenerator
// **************************************************************************

$src""";
}

Future _buildTest(
  String src,
  String expected, {
  Map<String, Object>? extraSrcAssets,
}) async {
  final readerWriter = TestReaderWriter(rootPackage: _pkgName);
  await readerWriter.testing.loadIsolateSources();
  await testBuilder(
    PartBuilder([const NpLogGenerator()], ".g.dart"),
    {"$_pkgName|lib/test.dart": src, ...?extraSrcAssets},
    readerWriter: readerWriter,
    outputs: {"$_pkgName|lib/test.g.dart": decodedMatches(expected)},
  );
}

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
