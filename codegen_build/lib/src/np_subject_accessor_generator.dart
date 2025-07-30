import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:source_gen/source_gen.dart';

class NpSubjectAccessorGenerator
    extends GeneratorForAnnotation<NpSubjectAccessor> {
  const NpSubjectAccessorGenerator();

  @override
  Future<String?> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      // not class, probably field
      return null;
    }
    final clazz = element;
    final fields = await _getFields(buildStep.resolver, clazz);
    return """
extension \$${clazz.name}NpSubjectAccessor on ${clazz.name} {
  ${_buildBody(fields)}
}
""";
  }

  String _buildBody(List<_FieldMeta> fields) {
    final results = <String>[];
    for (final f in fields) {
      results
        ..add("// ${f.fullname}")
        ..add(
          "ValueStream<${f.typeStr}> get ${f.name} => ${f.fullname}.stream;",
        )
        ..add("Stream<${f.typeStr}> get ${f.name}New => ${f.name}.skip(1);")
        ..add(
          "Stream<${f.typeStr}> get ${f.name}Change => ${f.name}.distinct().skip(1);",
        )
        ..add("${f.typeStr} get ${f.name}Value => ${f.fullname}.value;");
    }
    return results.join("\n");
  }

  Future<List<_FieldMeta>> _getFields(
    Resolver resolver,
    ClassElement clazz,
  ) async {
    const typeChecker = TypeChecker.fromRuntime(NpSubjectAccessor);
    final data = <_FieldMeta>[];
    for (final f in clazz.fields.where(typeChecker.hasAnnotationOf)) {
      // final annotation = typeChecker.annotationsOf(f).first;
      // final type = annotation.getField("type")!.toTypeValue()!;
      final parseName = _parseName(f);
      final parseType = await _parseTypeString(resolver, f);
      data.add(
        _FieldMeta(
          name: parseName.name,
          fullname: parseName.fullname,
          typeStr: parseType.typeStr,
        ),
      );
    }
    return data;
  }

  _NameParseResult _parseName(FieldElement field) {
    var name = field.name;
    if (name.startsWith("_")) {
      name = name.substring(1);
    }
    if (name.endsWith("Controller")) {
      name = name.substring(0, name.length - 10);
    }
    return _NameParseResult(name: name, fullname: field.name);
  }

  Future<_TypeParseResult> _parseTypeString(
    Resolver resolver,
    FieldElement field,
  ) async {
    String? typeStr;
    if (const TypeChecker.fromRuntime(
      NpSubjectAccessor,
    ).hasAnnotationOf(field)) {
      final annotation =
          const TypeChecker.fromRuntime(
            NpSubjectAccessor,
          ).annotationsOf(field).first;
      final type = annotation.getField("type")?.toStringValue();
      typeStr = type;
    }

    if (typeStr == null) {
      final astNode = await resolver.astNodeFor(field, resolve: true);
      typeStr =
          (astNode! as VariableDeclaration).initializer!.staticType!
              .getDisplayString();
      if (typeStr.startsWith("BehaviorSubject<")) {
        typeStr = typeStr.substring(16, typeStr.length - 1);
      }
      if (typeStr == "InvalidType") {
        throw UnsupportedError(
          "Type can't be parsed, please specify the type in annotation: ${field.name}",
        );
      }
    }
    return _TypeParseResult(typeStr: typeStr);
  }
}

class _NameParseResult {
  const _NameParseResult({required this.name, required this.fullname});

  final String name;
  final String fullname;
}

class _TypeParseResult {
  const _TypeParseResult({required this.typeStr});

  final String typeStr;
}

class _FieldMeta {
  const _FieldMeta({
    required this.name,
    required this.fullname,
    required this.typeStr,
  });

  final String name;
  final String fullname;
  final String typeStr;
}
