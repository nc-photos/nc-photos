import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:source_gen/source_gen.dart';

/// Generate a enum class with all columns to define sorting without exposing
/// drift internals
class DriftTableSortGenerator extends GeneratorForAnnotation<DriftTableSort> {
  const DriftTableSortGenerator();

  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      print("Not a class");
      return null;
    }
    final driftTableSort = DriftTableSort(
      annotation.read("dbClass").stringValue,
    );
    final clazz = element;
    if (!clazz.allSupertypes.any((t) => t.element.name == "Table")) {
      print("Not a drift table");
      return null;
    }
    final columns = clazz.fields.where((f) => _shouldIncludeField(f)).toList();
    if (columns.isEmpty) {
      print("No columns");
      return null;
    }

    final sortEnumName =
        "${clazz.name.substring(0, clazz.name.length - 1)}Sort";
    final enumValues = columns
        .map((f) => "${f.name}Asc, ${f.name}Desc, ")
        .reduce((a, b) => a + b);
    final cases = columns
        .map((f) {
          return """
case $sortEnumName.${f.name}Asc:
  return OrderingTerm.asc(db.${clazz.name.replaceRange(0, 1, clazz.name[0].toLowerCase())}.${f.name});
case $sortEnumName.${f.name}Desc:
  return OrderingTerm.desc(db.${clazz.name.replaceRange(0, 1, clazz.name[0].toLowerCase())}.${f.name});
""";
        })
        .reduce((a, b) => a + b);
    return """
enum $sortEnumName { $enumValues }

extension ${sortEnumName}IterableExtension on Iterable<$sortEnumName> {
  Iterable<OrderingTerm> toOrderingItem(${driftTableSort.dbClass} db) {
    return map((s) {
      switch (s) { $cases }
    });
  }
}
""";
  }

  bool _shouldIncludeField(FieldElement field) {
    if (!field.isSynthetic) {
      // columns are getters
      return false;
    }
    // it's a very rough way but well...
    if (field.type.element?.name?.endsWith("Column") ?? false) {
      return true;
    }
    return false;
  }
}
