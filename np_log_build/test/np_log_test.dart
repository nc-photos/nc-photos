import 'package:np_log_build/src/np_log_generator.dart';
import 'package:test/test.dart';

import 'util.dart';

// dummy class to free us from importing the actual logger library
class Logger {
  Logger(String name);
}

void main() async {
  await resolveCompilationUnit("test/src/np_log.dart");
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

String _genSrc(String src) {
  return """
import 'package:np_log/np_log.dart';
part 'test.g.dart';
$src
""";
}

String _genExpected(String src) {
  return """// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// NpLogGenerator
// **************************************************************************

$src""";
}

Future _buildTest(String src, String expected) => buildTest(
      generators: [const NpLogGenerator()],
      pkgName: _pkgName,
      src: src,
      expected: expected,
    );

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
