import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

// Taken from source_gen_test, unclear why this is needed...
Future<void> resolveCompilationUnit(String filePath) async {
  final assetId = AssetId.parse('a|lib/${p.basename(filePath)}');
  final files =
      Directory(p.dirname(filePath)).listSync().whereType<File>().toList();

  final fileMap = Map<String, String>.fromEntries(files.map(
      (f) => MapEntry('a|lib/${p.basename(f.path)}', f.readAsStringSync())));

  await resolveSources(fileMap, (item) async {
    return await item.libraryFor(assetId);
  }, resolverFor: 'a|lib/${p.basename(filePath)}');
}

Future buildTest({
  required List<Generator> generators,
  required String pkgName,
  required String src,
  required String expected,
}) {
  return testBuilder(
    PartBuilder(generators, ".g.dart"),
    {"$pkgName|lib/test.dart": src},
    generateFor: {'$pkgName|lib/test.dart'},
    outputs: {"$pkgName|lib/test.g.dart": decodedMatches(expected)},
  );
}
