import 'package:build_test/build_test.dart';
import 'package:np_codegen_build/src/drift_table_sort_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() async {
  tearDown(() {
    // Increment this after each test so the next test has it's own package
    _pkgCacheCount++;
  });

  test("DriftTableSort", () {
    final src = _genSrc("""
@DriftTableSort("Database")
class Tests extends Table {
  IntColumn get test1 => integer()();
  TextColumn get test2 => text()();
}

class Table {}

class IntColumn {}

class TextColumn {}

IntColumn Function() integer() => () => IntColumn();

TextColumn Function() text() => () => TextColumn();
""");
    final expected = _genExpected(r"""
enum TestSort { test1Asc, test1Desc, test2Asc, test2Desc }

extension TestSortIterableExtension on Iterable<TestSort> {
  Iterable<OrderingTerm> toOrderingItem(Database db) {
    return map((s) {
      switch (s) {
        case TestSort.test1Asc:
          return OrderingTerm.asc(db.tests.test1);
        case TestSort.test1Desc:
          return OrderingTerm.desc(db.tests.test1);
        case TestSort.test2Asc:
          return OrderingTerm.asc(db.tests.test2);
        case TestSort.test2Desc:
          return OrderingTerm.desc(db.tests.test2);
      }
    });
  }
}
""");
    return _buildTest(src, expected);
  });
}

String _genSrc(String src, {List<String> extraImportStatements = const []}) {
  return """
import 'package:np_codegen/np_codegen.dart';
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
// DriftTableSortGenerator
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
    PartBuilder([const DriftTableSortGenerator()], ".g.dart"),
    {"$_pkgName|lib/test.dart": src, ...?extraSrcAssets},
    readerWriter: readerWriter,
    outputs: {"$_pkgName|lib/test.g.dart": decodedMatches(expected)},
  );
}

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
