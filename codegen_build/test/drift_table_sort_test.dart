import 'package:np_codegen_build/src/drift_table_sort_generator.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() async {
  await resolveCompilationUnit("test/src/drift_table_sort.dart");
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

String _genSrc(String src) {
  return """
import 'package:np_codegen/np_codegen.dart';
part 'test.g.dart';
$src
""";
}

String _genExpected(String src) {
  return """// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// DriftTableSortGenerator
// **************************************************************************

$src""";
}

Future _buildTest(String src, String expected) => buildTest(
      generators: [const DriftTableSortGenerator()],
      pkgName: _pkgName,
      src: src,
      expected: expected,
    );

String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
