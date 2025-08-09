import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:np_codegen_build/src/np_subject_accessor_generator.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Future<void> main() async {
  await _resolveCompilationUnit("test/src/np_subject_accessor.dart");
  tearDown(() {
    // Increment this after each test so the next test has it's own package
    _pkgCacheCount++;
  });

  group("NpSubjectAccessor", () {
    test("empty", () async {
      final src = _genSrc("""
@npSubjectAccessor
class Empty {}
""");
      final expected = _genExpected(r"""
extension $EmptyNpSubjectAccessor on Empty {}
""");
      return _buildTest(src, expected);
    });

    test("int", () async {
      final src = _genSrc("""
@npSubjectAccessor
class IntTest {
  @npSubjectAccessor
  final _barController = BehaviorSubject.seeded(1);
}
""");
      final expected = _genExpected(r"""
extension $IntTestNpSubjectAccessor on IntTest {
  // _barController
  ValueStream<int> get bar => _barController.stream;
  Stream<int> get barNew => bar.skip(1);
  Stream<int> get barChange => bar.distinct().skip(1);
  int get barValue => _barController.value;
}
""");
      return _buildTest(src, expected);
    });

    test("int nullable", () async {
      final src = _genSrc("""
@npSubjectAccessor
class IntNullableTest {
  @npSubjectAccessor
  final _barController = BehaviorSubject<int?>.seeded(1);
}
""");
      final expected = _genExpected(r"""
extension $IntNullableTestNpSubjectAccessor on IntNullableTest {
  // _barController
  ValueStream<int?> get bar => _barController.stream;
  Stream<int?> get barNew => bar.skip(1);
  Stream<int?> get barChange => bar.distinct().skip(1);
  int? get barValue => _barController.value;
}
""");
      return _buildTest(src, expected);
    });
  });
}

String _genSrc(String src) {
  return """
import 'package:np_codegen/np_codegen.dart';
import 'package:rxdart/rxdart.dart';
part 'test.g.dart';

$src
""";
}

String _genExpected(String src) {
  return """// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// NpSubjectAccessorGenerator
// **************************************************************************

$src""";
}

Future _buildTest(String src, String expected) {
  return testBuilder(
    PartBuilder([const NpSubjectAccessorGenerator()], ".g.dart"),
    {"$_pkgName|lib/test.dart": src},
    generateFor: {'$_pkgName|lib/test.dart'},
    outputs: {"$_pkgName|lib/test.g.dart": decodedMatches(expected)},
  );
}

// Taken from source_gen_test, unclear why this is needed...
Future<void> _resolveCompilationUnit(String filePath) async {
  final assetId = AssetId.parse('a|lib/${p.basename(filePath)}');
  final files =
      Directory(p.dirname(filePath)).listSync().whereType<File>().toList();

  final fileMap = Map<String, String>.fromEntries(
    files.map(
      (f) => MapEntry('a|lib/${p.basename(f.path)}', f.readAsStringSync()),
    ),
  );

  await resolveSources(fileMap, (item) async {
    return await item.libraryFor(assetId);
  }, resolverFor: 'a|lib/${p.basename(filePath)}');
}

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
