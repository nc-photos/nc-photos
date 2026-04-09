import 'package:build_test/build_test.dart';
import 'package:np_codegen_build/src/np_subject_accessor_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Future<void> main() async {
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

String _genSrc(String src, {List<String> extraImportStatements = const []}) {
  return """
import 'package:np_codegen/np_codegen.dart';
import 'package:rxdart/rxdart.dart';
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
// NpSubjectAccessorGenerator
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
    PartBuilder([const NpSubjectAccessorGenerator()], ".g.dart"),
    {"$_pkgName|lib/test.dart": src, ...?extraSrcAssets},
    readerWriter: readerWriter,
    outputs: {"$_pkgName|lib/test.g.dart": decodedMatches(expected)},
  );
}

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
